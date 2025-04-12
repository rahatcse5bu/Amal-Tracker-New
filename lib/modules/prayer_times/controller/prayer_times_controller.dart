import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' show Position, LocationPermission, Geolocator;
import 'package:geocoding/geocoding.dart';
import '../models/prayer_time_model.dart';
import 'dart:async';

class PrayerTimesController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxString currentLocation = 'Loading...'.obs;
  final Rx<Position?> position = Rx<Position?>(null);
  final Rx<PrayerTimes?> prayerTimes = Rx<PrayerTimes?>(null);
  final RxString nextPrayer = ''.obs;
  final RxString timeUntilNextPrayer = ''.obs;
  final RxString currentPrayer = ''.obs;
  final RxString currentPrayerTime = ''.obs;
  final RxString prayerEndTime = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    // Update prayer times every minute
    ever(prayerTimes, (_) => updateCurrentPrayer());
    Timer.periodic(const Duration(minutes: 1), (_) => updateCurrentPrayer());
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading(true);
      
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // Get current position
      Position currentPosition = await Geolocator.getCurrentPosition();
      position.value = currentPosition;

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        currentLocation.value = '${place.locality}, ${place.country}';
      }

      // Fetch prayer times for current location
      await fetchPrayerTimes();
      
    } catch (e) {
      print('Error getting location: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchPrayerTimes() async {
    if (position.value == null) return;

    // TODO: Implement API call to fetch prayer times
    // This is a placeholder for the actual API implementation
    await Future.delayed(const Duration(seconds: 1));
    
    updateNextPrayer();
  }

  void updateNextPrayer() {
    final now = DateTime.now();
    if (prayerTimes.value == null) {
      nextPrayer.value = 'Loading...';
      timeUntilNextPrayer.value = '--:--';
      return;
    }

    final times = [
      {'name': 'Fajr', 'time': _parseTime(prayerTimes.value!.fajr.toString())},
      {'name': 'Sunrise', 'time': _parseTime(prayerTimes.value!.sunrise.toString())},
      {'name': 'Dhuhr', 'time': _parseTime(prayerTimes.value!.dhuhr.toString())},
      {'name': 'Asr', 'time': _parseTime(prayerTimes.value!.asr.toString())},
      {'name': 'Maghrib', 'time': _parseTime(prayerTimes.value!.maghrib.toString())},
      {'name': 'Isha', 'time': _parseTime(prayerTimes.value!.isha.toString())},
    ];

    var nextPrayerFound = false;
    for (var prayer in times) {
      final prayerTime = prayer['time'] as DateTime;
      if (prayerTime.isAfter(now)) {
        nextPrayer.value = prayer['name'] as String;
        final difference = prayerTime.difference(now);
        timeUntilNextPrayer.value = _formatDuration(difference);
        nextPrayerFound = true;
        break;
      }
    }

    if (!nextPrayerFound) {
      nextPrayer.value = 'Fajr';
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final fajrTime = _parseTime(prayerTimes.value!.fajr.starts)
          .add(const Duration(days: 1));
      timeUntilNextPrayer.value = _formatDuration(fajrTime.difference(now));
    }
  }

  void updateCurrentPrayer() {
    final now = DateTime.now();
    if (prayerTimes.value == null) {
      currentPrayer.value = 'Loading...';
      currentPrayerTime.value = '--:--';
      return;
    }

    final times = [
      {'name': 'Fajr', 'start': _parseTime(prayerTimes.value!.fajr.starts), 'end': _parseTime(prayerTimes.value!.sunrise.ends)},
      {'name': 'Dhuhr', 'start': _parseTime(prayerTimes.value!.dhuhr.starts), 'end': _parseTime(prayerTimes.value!.asr.ends)},
      {'name': 'Asr', 'start': _parseTime(prayerTimes.value!.asr.starts), 'end': _parseTime(prayerTimes.value!.maghrib.ends)},
      {'name': 'Maghrib', 'start': _parseTime(prayerTimes.value!.maghrib.starts), 'end': _parseTime(prayerTimes.value!.isha.ends)},
      {'name': 'Isha', 'start': _parseTime(prayerTimes.value!.isha.starts), 'end': _parseTime(prayerTimes.value!.fajr.ends).add(const Duration(days: 1))},
    ];

    // Find current prayer time
    var currentPrayerFound = false;
    for (var prayer in times) {
      final startTime = prayer['start'] as DateTime;
      final endTime = prayer['end'] as DateTime;
      
      if (now.isAfter(startTime) && now.isBefore(endTime)) {
        currentPrayer.value = prayer['name'] as String;
        currentPrayerTime.value = '${_formatTime(startTime)} - ${_formatTime(endTime)}';
        currentPrayerFound = true;
        break;
      }
    }

    if (!currentPrayerFound) {
      currentPrayer.value = 'Between Prayers';
      currentPrayerTime.value = 'Waiting for next prayer';
    }

    // Update next prayer info
    updateNextPrayer();
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  DateTime _parseTime(String timeStr) {
    final now = DateTime.now();
    final parts = timeStr.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  Future<void> changeLocation(String query) async {
    try {
      isLoading(true);
      
      // Get coordinates for the searched location
      List<Location> locations = await locationFromAddress(query);
      
      if (locations.isNotEmpty) {
        Position newPosition = Position(
          latitude: locations[0].latitude,
          longitude: locations[0].longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
        
        position.value = newPosition;
        currentLocation.value = query;
        
        await fetchPrayerTimes();
      }
    } catch (e) {
      print('Error changing location: $e');
    } finally {
      isLoading(false);
    }
  }
}
