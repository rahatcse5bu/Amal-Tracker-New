import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/prayer_time_model.dart' as model;
import 'dart:async';

class PrayerTimesController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxString currentLocation = 'Loading...'.obs;
  final Rx<model.PrayerTimes?> prayerTimes = Rx<model.PrayerTimes?>(null); // Observable for storing prayer times
  final Rx<Position?> position = Rx<Position?>(null); // Observable for storing the current position
  final RxString nextPrayer = ''.obs;
  final RxString timeUntilNextPrayer = ''.obs;
  final RxString currentPrayer = ''.obs;
  final RxString currentPrayerTime = ''.obs;
  final RxString prayerEndTime = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAndRequestLocation();
    // Update times every minute and when prayer times change
    ever(prayerTimes, (_) => updateCurrentPrayer());
    Timer.periodic(const Duration(minutes: 1), (_) {
      updateCurrentPrayer();
      // Refresh prayer times at midnight
      final now = DateTime.now();
      if (now.hour == 0 && now.minute == 0) {
        fetchPrayerTimes();
      }
    });
  }

  Future<void> _checkAndRequestLocation() async {
    try {
      // First check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Get.dialog(
          AlertDialog(
            title: const Text('Location Services Disabled'),
            content: const Text('Please enable location services to get prayer times for your area.'),
            actions: [
              TextButton(
                onPressed: () async {
                  Get.back();
                  await Geolocator.openLocationSettings();
                  // Check again after settings
                  await _checkAndRequestLocation();
                },
                child: const Text('ENABLE'),
              ),
            ],
          ),
        );
        return;
      }

      // Check permission status
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Permission Required',
            'Location permission is needed to show prayer times',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await Get.dialog(
          AlertDialog(
            title: const Text('Permission Denied'),
            content: const Text('Location permission is permanently denied. Please enable it in app settings.'),
            actions: [
              TextButton(
                onPressed: () async {
                  Get.back();
                  await Geolocator.openAppSettings();
                  // Check again after settings
                  await _checkAndRequestLocation();
                },
                child: const Text('OPEN SETTINGS'),
              ),
            ],
          ),
        );
        return;
      }

      // If we get here, we have permission, so get location
      await getCurrentLocation();
    } catch (e) {
      print('Error in location check: $e');
      Get.snackbar(
        'Error',
        'Failed to initialize location services',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading(true);
      
      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Show dialog instead of snackbar for better visibility
        await Get.dialog(
          AlertDialog(
            title: const Text('Location Service Disabled'),
            content: const Text('Please enable location services to get prayer times.'),
            actions: [
              TextButton(
                onPressed: () async {
                  Get.back();
                  await Geolocator.openLocationSettings();
                },
                child: const Text('OPEN SETTINGS'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
        return;
      }

      // Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Error',
            'Location permission denied. Prayer times will not be accurate.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await Get.dialog(
          AlertDialog(
            title: const Text('Permission Denied'),
            content: const Text(
              'Location permission is permanently denied. Please enable it in app settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () async {
                  Get.back();
                  await Geolocator.openAppSettings();
                },
                child: const Text('OPEN SETTINGS'),
              ),
            ],
          ),
        );
        return;
      }

      // Get position with timeout
      print('Getting position...');
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Location request timed out');
        },
      );

      print('Position received: ${currentPosition.latitude}, ${currentPosition.longitude}');
      position.value = currentPosition;

      // Get address from coordinates
      final placemarks = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        currentLocation.value = '${place.locality ?? ''}, ${place.country ?? ''}';
        print('Location set to: ${currentLocation.value}');
      }

      // Fetch prayer times
      await fetchPrayerTimes();
      
    } catch (e, stackTrace) {
      print('Error getting location: $e');
      print('Stack trace: $stackTrace');
      
      Get.snackbar(
        'Error',
        'Failed to get location: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        mainButton: TextButton(
          onPressed: () => getCurrentLocation(),
          child: const Text('RETRY', style: TextStyle(color: Colors.white)),
        ),
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchPrayerTimes() async {
    if (position.value == null) return;
    
    try {
      isLoading(true);
      final coordinates = Coordinates(
        position.value!.latitude,
        position.value!.longitude,
      );

      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.hanafi;

      final date = DateComponents.from(DateTime.now());
      final adhanTimes = PrayerTimes(coordinates, date, params);

      // Debug print
      print('Fajr time: ${adhanTimes.fajr}');
      print('Current coordinates: ${coordinates.latitude}, ${coordinates.longitude}');

      try {
        prayerTimes.value = model.PrayerTimes(
          date: DateTime.now(),
          fajr: model.Prayer(
            starts: _formatDateTime(adhanTimes.fajr),
            ends: _formatDateTime(adhanTimes.sunrise),
            iqamah: _formatDateTime(adhanTimes.fajr.add(const Duration(minutes: 20))),
          ),
          sunrise: model.Prayer(
            starts: _formatDateTime(adhanTimes.sunrise),
            ends: _formatDateTime(adhanTimes.sunrise.add(const Duration(minutes: 15))),
            iqamah: '',
          ),
          dhuhr: model.Prayer(
            starts: _formatDateTime(adhanTimes.dhuhr),
            ends: _formatDateTime(adhanTimes.asr),
            iqamah: _formatDateTime(adhanTimes.dhuhr.add(const Duration(minutes: 20))),
          ),
          asr: model.Prayer(
            starts: _formatDateTime(adhanTimes.asr),
            ends: _formatDateTime(adhanTimes.maghrib),
            iqamah: _formatDateTime(adhanTimes.asr.add(const Duration(minutes: 20))),
          ),
          maghrib: model.Prayer(
            starts: _formatDateTime(adhanTimes.maghrib),
            ends: _formatDateTime(adhanTimes.isha),
            iqamah: _formatDateTime(adhanTimes.maghrib.add(const Duration(minutes: 5))),
          ),
          isha: model.Prayer(
            starts: _formatDateTime(adhanTimes.isha),
            ends: _formatDateTime(adhanTimes.fajr.add(const Duration(days: 1))),
            iqamah: _formatDateTime(adhanTimes.isha.add(const Duration(minutes: 20))),
          ),
          sehri: model.SpecialTiming(
            starts: _formatDateTime(adhanTimes.fajr.subtract(const Duration(minutes: 90))),
            ends: _formatDateTime(adhanTimes.fajr),
          ),
          iftar: model.SpecialTiming(
            starts: _formatDateTime(adhanTimes.maghrib),
            ends: _formatDateTime(adhanTimes.maghrib.add(const Duration(minutes: 30))),
          ),
          ishrak: model.SpecialTiming(
            starts: _formatDateTime(adhanTimes.sunrise.add(const Duration(minutes: 20))),
            ends: _formatDateTime(adhanTimes.dhuhr.subtract(const Duration(minutes: 20))),
          ),
          tahajjud: model.SpecialTiming(
            starts: _formatDateTime(adhanTimes.isha.add(const Duration(hours: 2))),
            ends: _formatDateTime(adhanTimes.fajr.subtract(const Duration(minutes: 30))),
          ),
          forbiddenPeriods: [
            model.ForbiddenPeriod(
              name: 'Sunrise Period',
              starts: _formatDateTime(adhanTimes.sunrise.subtract(const Duration(minutes: 10))),
              ends: _formatDateTime(adhanTimes.sunrise.add(const Duration(minutes: 15))),
              reason: 'Prayer is forbidden during sunrise',
            ),
            model.ForbiddenPeriod(
              name: 'Zawaal',
              starts: _formatDateTime(adhanTimes.dhuhr.subtract(const Duration(minutes: 10))),
              ends: _formatDateTime(adhanTimes.dhuhr),
              reason: 'Prayer is forbidden at zenith',
            ),
            model.ForbiddenPeriod(
              name: 'Sunset Period',
              starts: _formatDateTime(adhanTimes.maghrib.subtract(const Duration(minutes: 10))),
              ends: _formatDateTime(adhanTimes.maghrib),
              reason: 'Prayer is forbidden during sunset',
            ),
          ],
        );

        // Add debug prints
        print('Prayer times calculated: ${prayerTimes.value}');
        print('Fajr time: ${prayerTimes.value?.fajr.starts}');

        updateNextPrayer();
        updateCurrentPrayer();
      } catch (e) {
        print('Error in prayer time conversion: $e');
        // Add stack trace for better debugging
        print(StackTrace.current);
        throw Exception('Failed to convert prayer times');
      }
    } catch (e) {
      print('Error calculating prayer times: $e');
      Get.snackbar(
        'Error',
        'Failed to calculate prayer times: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  void updateNextPrayer() {
    final now = DateTime.now();
    if (prayerTimes.value == null) {
      nextPrayer.value = 'Loading...';
      timeUntilNextPrayer.value = '--:--';
      return;
    }

    final times = [
      {'name': 'Fajr', 'time': _parseTime(prayerTimes.value!.fajr.starts)},
      {'name': 'Sunrise', 'time': _parseTime(prayerTimes.value!.sunrise.starts)},
      {'name': 'Dhuhr', 'time': _parseTime(prayerTimes.value!.dhuhr.starts)},
      {'name': 'Asr', 'time': _parseTime(prayerTimes.value!.asr.starts)},
      {'name': 'Maghrib', 'time': _parseTime(prayerTimes.value!.maghrib.starts)},
      {'name': 'Isha', 'time': _parseTime(prayerTimes.value!.isha.starts)},
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

  String _formatDateTime(DateTime time) {
    try {
      return DateFormat('HH:mm').format(time);
    } catch (e) {
      print('Error formatting time: $e');
      return '--:--';
    }
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
