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
                  _buildStatusIndicators(controller),
                  
                  const SizedBox(height: 20),
                  
                  const Text(
                    "Amal Tracking Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Amal options list
                  ...controller.trackingOptions.map((option) {
                    return _buildAmalCard(context, controller, option);
                  }).toList(),
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

  Widget _buildStatusIndicators(TrackingController controller) {
    // Set of common attributes that can be tracked across options
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tracking Properties",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // Property widgets in a grid layout for better space usage
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3.0,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildPropertyToggle(
              "In Mosque", 
              controller.isInMosque.value,
              Icons.mosque,
              (value) => controller.toggleMosqueStatus(),
            ),
            _buildPropertyToggle(
              "Khushu & Khuzu", 
              controller.isKhushuKhuzu.value,
              Icons.volunteer_activism,
              (value) => controller.toggleKhushuStatus(),
            ),
            _buildPropertyToggle(
              "Qadha",
              controller.isQadha.value,
              Icons.update,
              (value) => controller.toggleQadhaStatus(),
              isNegative: true,
            ),
            _buildPropertyToggle(
              "Regular Order",
              controller.isRegularOrder.value,
              Icons.format_list_numbered,
              (value) => controller.toggleRegularOrderStatus(),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Count Management Section
        const Text(
          "Count Management",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        _buildCountManager(controller),
      ],
    );
  }
  
  Widget _buildPropertyToggle(
      String label, bool value, IconData icon, Function(bool) onChanged, {bool isNegative = false}) {
    return Container(
      decoration: BoxDecoration(
        color: value 
            ? (isNegative ? Colors.red.withOpacity(0.1) : AppColors.primary.withOpacity(0.1)) 
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: value 
              ? (isNegative ? Colors.red : AppColors.primary) 
              : Colors.grey.shade300,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => onChanged(!value),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: value 
                      ? (isNegative ? Colors.red : AppColors.primary) 
                      : Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: value 
                          ? (isNegative ? Colors.red : AppColors.primary) 
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: isNegative ? Colors.red : AppColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeTrackColor: isNegative 
                      ? Colors.red.withOpacity(0.4) 
                      : AppColors.primary.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountManager(TrackingController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Current Count",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${controller.getCurrentCount()}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Count",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${controller.getTotalCount()}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Count controls
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 32),
                color: AppColors.primary,
                onPressed: () => controller.decrementCount(),
              ),
              Expanded(
                child: Slider(
                  value: controller.getCurrentCount().toDouble().clamp(0, 100),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  activeColor: AppColors.primary,
                  label: controller.getCurrentCount().toString(),
                  onChanged: (value) => controller.updateCurrentCount(value.toInt()),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 32),
                color: AppColors.primary,
                onPressed: () => controller.incrementCount(),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Reset button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text("Reset Count"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                side: BorderSide(color: Colors.grey.shade400),
              ),
              onPressed: () => controller.resetCount(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmalCard(BuildContext context, TrackingController controller, TrackingOption option) {
    final bool checked = controller.checkedStates[option.id] ?? false;
    final bool isLoading = controller.loadingStates[option.id] ?? false;
    final int currentProgress = controller.getCurrentProgress(option.id);
    final bool isMilestoneCompleted = option.milestone > 0 && currentProgress >= option.milestone;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: checked ? AppColors.primary.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: checked ? AppColors.primary : Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            final newValue = !checked;
            controller.updateTrackingOption(option.id, newValue);
            controller.submitPoints(newValue ? option.point : -option.point);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: checked ? AppColors.primary : Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: isLoading
                          ? const CupertinoActivityIndicator(color: Colors.white)
                          : Icon(
                              checked ? Icons.check : Icons.hourglass_empty_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Title and description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: checked ? AppColors.primary : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            option.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Points badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: checked ? AppColors.primary : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${option.point} pts",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: checked ? Colors.white : Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Properties and attributes for this amal
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (option.isInMosque)
                      _buildAmalProperty("Mosque", Icons.mosque),
                    if (option.isKhushuKhuzu)
                      _buildAmalProperty("Khushu", Icons.volunteer_activism),
                    if (option.isQadha)
                      _buildAmalProperty("Qadha", Icons.update, isNegative: true),
                    if (option.isRegularOrder)
                      _buildAmalProperty("Regular", Icons.format_list_numbered),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Milestone progress indicator
                if (option.milestone > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.flag,
                            size: 16,
                            color: isMilestoneCompleted ? Colors.green : Colors.orange,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Milestone: ${option.milestone}",
                            style: TextStyle(
                              fontSize: 12,
                              color: isMilestoneCompleted ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Progress: $currentProgress/${option.milestone}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: option.milestone > 0 ? currentProgress / option.milestone : 0,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isMilestoneCompleted ? Colors.green : AppColors.primary,
                          ),
                          minHeight: 6,
                        ),
                      ),
                      
                      if (isMilestoneCompleted) 
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.celebration,
                                size: 14,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Milestone Completed! Total completed: ${option.totalCount}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                
                // Total completion times
                if (option.totalCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.repeat,
                          size: 14,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Completed ${option.totalCount} / ${option.milestone} times",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmalProperty(String label, IconData icon, {bool isNegative = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isNegative ? Colors.red.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: isNegative ? Colors.red : AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isNegative ? Colors.red : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
