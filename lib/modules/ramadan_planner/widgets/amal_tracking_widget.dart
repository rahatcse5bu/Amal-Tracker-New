import 'dart:developer';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../app/common/utils/ramadan_utils.dart';
import '../../../app/constants/app_color.dart';
import '../controller/tracking_controller.dart';
import '../models/tracking_options_model.dart';

class AmalTracker extends StatelessWidget {
  final int ramadan_day;
  final String slug;
  final String type;

  const AmalTracker({
    Key? key,
    required this.ramadan_day,
    required this.slug,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TrackingController controller = Get.put(
      TrackingController(ramadanDay: ramadan_day, slug: slug, type: type),
      tag: '$slug-$ramadan_day',
    );

    log("AmalTracker rendered for $slug - Day: $ramadan_day");

    return Obx(() {
      if (controller.isLoadingOptions.value) {
        return const Center(
          child: CupertinoActivityIndicator(color: AppColors.primary)
        );
      }

      if (controller.trackingOptions.isEmpty) {
        return const Center(child: Text("No options available"));
      }

      return Stack(
        children: [
          Card(
            elevation: 5,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.getTrackingName(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "Day ${ramadan_day}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),

                  // Laylatul Qadr message for last 10 days
                  if (ramadan_day > 20 && slug == 'qadr_tracking')
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ramadan_day % 2 == 0 
                            ? Colors.amber.withOpacity(0.2)
                            : Colors.green.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ramadan_day % 2 == 0 ? Colors.amber : Colors.green,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        ramadan_day % 2 == 0
                            ? "আজ ${ramadan_day}${Utils.getNumberSuffix(ramadan_day)} রমাদ্বন। আজ শেষ দশকের একটি (জোড়) রাত। আজ রাতেও 'আমাল করুন।জোড় রাতেও লাইলাতুল ক্বদর হতে পারে।"
                            : "আজ ${ramadan_day}${Utils.getNumberSuffix(ramadan_day)} রমাদ্বন। আজ শেষ দশকের বিজোড় রাত।  বিজোড় রাতে বেশি বেশি 'আমাল করুন।সারারাত ধরে 'আমাল করুন।  বিজোড় রাতগুলিতে লাইলাতুল ক্বদর হওয়ার সম্ভাবনা প্রবল।",
                        style: TextStyle(
                          color: ramadan_day % 2 == 0 ? Colors.amber.shade800 : Colors.green.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Progress Summary and stats
                  _buildProgressSummary(controller),

                  const SizedBox(height: 20),
                  
                  // Status indicators and attributes
                  _buildStatusIndicators(context, controller),
                ],
              ),
            ),
          ),
          
          // Confetti animation
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: controller.confettiController,
              blastDirection: -1.0,
              emissionFrequency: 0.8,
              numberOfParticles: 60,
              maxBlastForce: 20,
              minBlastForce: 15,
              gravity: 0.6,
              shouldLoop: false,
              colors: const [
                Colors.green,
                AppColors.primary,
                AppColors.primaryOpacity,
                Colors.black,
                Colors.cyanAccent,
                Colors.blue,
                Colors.deepOrange,
                Colors.pink,
                Colors.deepPurpleAccent,
                Colors.white,
                Colors.orange,
                Colors.purple,
                Colors.deepPurple,
                Colors.orangeAccent,
                Colors.cyan,
              ],
            ),
          ),
        ],
      );
      });
    }
  }

  Widget _buildProgressSummary(TrackingController controller) {
    // Calculate statistics based on tracking options
    final int totalMilestones = controller.trackingOptions.fold(0, 
        (sum, option) => sum + (option.milestone > 0 ? 1 : 0));
    
    final int completedMilestones = controller.trackingOptions.fold(0, 
        (sum, option) => sum + ((option.milestone > 0 && option.totalCount >= option.milestone) ? 1 : 0));
    
    final int totalPoints = controller.trackingOptions.fold(0, 
        (sum, option) => controller.checkedStates[option.id] == true ? sum + option.point : sum);
    
    final double percentCompleted = controller.trackingOptions.isEmpty ? 0 :
        controller.trackingOptions.where((option) => controller.checkedStates[option.id] == true).length /
        controller.trackingOptions.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Circular progress indicator
              CircularPercentIndicator(
                radius: 45.0,
                lineWidth: 10.0,
                animation: true,
                percent: percentCompleted,
                center: Text(
                  "${(percentCompleted * 100).toInt()}%",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                footer: const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Completion",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: AppColors.primary,
                backgroundColor: Colors.grey.shade200,
              ),
              
              const SizedBox(width: 16),
              
              // Stats section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatRow(
                      Icons.emoji_events,
                      "Milestones Completed",
                      "$completedMilestones / $totalMilestones",
                      Colors.amber,
                    ),
                    const SizedBox(height: 12),
                    _buildStatRow(
                      Icons.star,
                      "Total Points Earned",
                      "$totalPoints pts",
                      Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    _buildStatRow(
                      Icons.repeat,
                      "Avg. Completion Time",
                      "${controller.getAverageCompletionTime()} min",
                      Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Overall progress section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Overall Progress",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: percentCompleted,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      )
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicators(BuildContext context, TrackingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Amal Tracking Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // Amal options list with individual properties
        ...controller.trackingOptions.map((option) {
          return _buildAmalCard(context, controller, option);
        }).toList(),
      ],
    );
  }

  Widget _buildAmalCard(BuildContext context, TrackingController controller, TrackingOption option) {
    final bool checked = controller.checkedStates[option.id] ?? false;
    final bool isLoading = controller.loadingStates[option.id] ?? false;
    final int currentProgress = controller.getCurrentProgress(option.id);
    final bool isMilestoneCompleted = option.milestone > 0 && currentProgress >= option.milestone;
    final maxValue = option.milestone > 0 ? option.milestone : 100;
    final clampedProgress = currentProgress.clamp(0, maxValue).toDouble();

    // Calculate milestone metrics
    final int completedMilestones = option.milestone > 0 ? (currentProgress ~/ option.milestone) : 0;
    final int remainingForNext = option.milestone > 0 
        ? ((completedMilestones + 1) * option.milestone) - currentProgress 
        : 0;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: checked ? AppColors.primary.withOpacity(0.5) : Colors.grey.shade200,
          width: checked ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Main content section
          InkWell(
            onTap: () {
              final newValue = !checked;
              controller.updateTrackingOption(option.id, newValue);
              controller.submitPoints(newValue ? option.point : -option.point);
            },
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status icon with animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: checked 
                          ? AppColors.primary 
                          : Colors.grey.shade100,
                      border: Border.all(
                        color: checked 
                            ? AppColors.primary.withOpacity(0.2) 
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                      boxShadow: checked ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ] : [],
                    ),
                    child: isLoading
                        ? const CupertinoActivityIndicator(color: AppColors.primary)
                        : Icon(
                            checked ? Icons.check : Icons.circle_outlined,
                            color: checked ? Colors.white : Colors.grey.shade400,
                            size: 28,
                          ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Content section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                option.title,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: checked ? AppColors.primary : Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: checked 
                                    ? AppColors.primary 
                                    : AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: checked ? Colors.white : AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${option.point}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: checked ? Colors.white : AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          option.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (option.milestone > 0) ...[
                          const SizedBox(height: 12),
                          // Progress bar with gradient
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: currentProgress / option.milestone,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isMilestoneCompleted ? Colors.green : AppColors.primary,
                              ),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.flag_rounded,
                                    size: 16,
                                    color: isMilestoneCompleted ? Colors.green : Colors.orange,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "$currentProgress/${option.milestone}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: isMilestoneCompleted ? Colors.green : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.workspace_premium,
                                    size: 16,
                                    color: Colors.amber.shade700,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "× $completedMilestones completed",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.amber.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (remainingForNext > 0 && !isMilestoneCompleted)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_circle_up,
                                    size: 16,
                                    color: AppColors.primary.withOpacity(0.7),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "$remainingForNext more for next milestone",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary.withOpacity(0.7),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (isMilestoneCompleted) 
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.celebration,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Current milestone completed!",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Properties and count section in expansion tile
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Row(
                children: [
                  Icon(
                    Icons.settings,
                    size: 16,
                    color: AppColors.primary.withOpacity(0.8),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Properties & Count",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Property toggles
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildPropertyChip(
                            "In Mosque",
                            option.isInMosque,
                            Icons.mosque,
                            (value) => controller.toggleOptionProperty(option.id, 'isInMosque', value),
                          ),
                          _buildPropertyChip(
                            "In Jamayat",
                            option.isInJamayat,
                            Icons.groups,
                            (value) => controller.toggleOptionProperty(option.id, 'isInJamayat', value),
                          ),
                          _buildPropertyChip(
                            "Qadha",
                            option.isQadha,
                            Icons.update,
                            (value) => controller.toggleOptionProperty(option.id, 'isQadha', value),
                            isNegative: true,
                          ),
                          _buildPropertyChip(
                            "Regular",
                            option.isRegularOrder,
                            Icons.format_list_numbered,
                            (value) => controller.toggleOptionProperty(option.id, 'isRegularOrder', value),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      // Khushu Level Rating
                      _buildKhushuRating(
                        controller,
                        option.id,
                        controller.optionKhushuLevel[option.id] ?? 0,
                      ),
                      const Divider(),
                      // Count controls
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            color: AppColors.primary,
                            onPressed: () => controller.decrementOptionCount(option.id),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                activeTrackColor: AppColors.primary,
                                inactiveTrackColor: AppColors.primary.withOpacity(0.2),
                                thumbColor: AppColors.primary,
                                overlayColor: AppColors.primary.withOpacity(0.1),
                              ),
                              child: Slider(
                                value: clampedProgress,
                                min: 0,
                                max: maxValue.toDouble(),
                                divisions: maxValue,
                                label: currentProgress.toString(),
                                onChanged: (value) => controller.updateOptionCount(option.id, value.toInt()),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            color: AppColors.primary,
                            onPressed: () => controller.incrementOptionCount(option.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyChip(String label, bool value, IconData icon, Function(bool) onTap, {bool isNegative = false}) {
    final color = isNegative ? Colors.red : AppColors.primary;
    
    return InkWell(
      onTap: () => onTap(!value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: value ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: value ? color : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: value ? color : Colors.grey.shade500,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: value ? FontWeight.w600 : FontWeight.normal,
                color: value ? color : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKhushuRating(TrackingController controller, String optionId, int currentLevel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Khushu Level",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            final level = index + 1;
            return InkWell(
              onTap: () => controller.updateKhushuLevel(optionId, level),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: level <= currentLevel
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.1),
                ),
                child: Text(
                  "$level",
                  style: TextStyle(
                    color: level <= currentLevel ? Colors.white : AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }




