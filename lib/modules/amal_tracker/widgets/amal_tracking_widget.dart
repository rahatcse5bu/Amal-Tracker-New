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
              ),
            ],
          ),
        ],
      )
    );
  }

  Widget _buildStatusIndicators(BuildContext context, TrackingController controller) {
    // Organize by tracking type instead of prayer vs other
    final sortedOptions = controller.trackingOptions.toList()
      ..sort((a, b) {
        if (a.isSalatTracking == b.isSalatTracking) return a.index.compareTo(b.index);
        return a.isSalatTracking ? -1 : 1;
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.getTrackingName(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...sortedOptions.map((option) => _buildAmalCard(context, controller, option)),
      ],
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

          // Add prayer-specific options in grid layout when checked
          if (checked && option.isSalatTracking) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Primary options grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.5,
                    children: [
                      _buildGridItem(
                        'মসজিদে',
                        controller.optionInMosque[option.id] ?? false,
                        (val) => controller.toggleOptionProperty(option.id, 'isInMosque', val),
                        Icons.mosque,
                      ),
                      _buildGridItem(
                        'জামাতে',
                        controller.optionInJamayat[option.id] ?? false,
                        (val) => controller.toggleOptionProperty(option.id, 'isInJamayat', val),
                        Icons.groups,
                      ),
                      _buildGridItem(
                        'নিয়মিত',
                        controller.optionRegularOrder[option.id] ?? false,
                        (val) => controller.toggleOptionProperty(option.id, 'isRegularOrder', val),
                        Icons.schedule,
                      ),
                      _buildGridItem(
                        'খুশু-খুযু',
                        controller.optionKhushuKhuzu[option.id] ?? false,
                        (val) => controller.toggleOptionProperty(option.id, 'isKhushuKhuzu', val),
                        Icons.psychology,
                      ),
                    ],
                  ),

                  // Khushu Level Slider
                  if (controller.optionKhushuKhuzu[option.id] == true) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.trending_up, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Slider(
                            value: (controller.optionKhushuLevel[option.id] ?? 0).toDouble(),
                            min: 0,
                            max: 5,
                            divisions: 5,
                            label: '${controller.optionKhushuLevel[option.id] ?? 0}',
                            onChanged: (value) => controller.updateKhushuLevel(option.id, value.toInt()),
                          ),
                        ),
                        Container(
                          width: 24,
                          alignment: Alignment.center,
                          child: Text(
                            '${controller.optionKhushuLevel[option.id] ?? 0}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 8),

                  // Secondary options grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.2,
                    children: [
                      _buildGridItem(
                        'ক্বাদা',
                        controller.optionQadha[option.id] ?? false,
                        (val) => controller.toggleOptionProperty(option.id, 'isQadha', val),
                        Icons.update,
                      ),
                      _buildGridItem(
                        'হায়েয',
                        controller.optionHayez[option.id] ?? false,
                        (val) => controller.toggleOptionProperty(option.id, 'isHayez', val),
                        Icons.do_not_disturb,
                      ),
                      _buildGridItem(
                        'ক্বসর',
                        controller.optionQasr[option.id] ?? false,
                        (val) => controller.toggleOptionProperty(option.id, 'isQasr', val),
                        Icons.compress,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGridItem(String label, bool value, Function(bool) onChanged, IconData icon) {
    return Material(
      color: value ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade50,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: value ? AppColors.primary : Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: value ? AppColors.primary : Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: value ? AppColors.primary : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyRow(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}





