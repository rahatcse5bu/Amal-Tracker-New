import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/prayer_times_controller.dart';
import '../../../app/constants/app_color.dart';

class PrayerTimesView extends GetView<PrayerTimesController> {
  const PrayerTimesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location Section
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(controller.currentLocation.value),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showLocationPicker(context),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Next Prayer Card
                Card(
                  color: AppColors.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          controller.nextPrayer.value,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.timeUntilNextPrayer.value,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Prayer Times Grid
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildPrayerTimeRow('Fajr', '5:12 AM'),
                        const Divider(),
                        _buildPrayerTimeRow('Sunrise', '6:32 AM'),
                        const Divider(),
                        _buildPrayerTimeRow('Dhuhr', '12:15 PM'),
                        const Divider(),
                        _buildPrayerTimeRow('Asr', '4:30 PM'),
                        const Divider(),
                        _buildPrayerTimeRow('Maghrib', '6:45 PM'),
                        const Divider(),
                        _buildPrayerTimeRow('Isha', '8:00 PM'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPrayerTimeRow(String name, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Location'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter city name',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (value) {
            controller.changeLocation(value);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
