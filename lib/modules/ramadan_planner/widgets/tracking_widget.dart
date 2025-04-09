import 'dart:developer';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expandable_text/expandable_text.dart';
import '../../../app/common/utils/ramadan_utils.dart';
import '../../../app/constants/app_color.dart';
import '../controller/tracking_controller.dart';

class TrackingWidget extends StatelessWidget {
  final int ramadan_day;
  final String slug;
  final String type;

  const TrackingWidget({
    Key? key,
    required this.ramadan_day,
    required this.slug,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TrackingController controller = Get.put(
      TrackingController(ramadanDay: ramadan_day, slug: slug, type: type),
      tag: '$slug-$ramadan_day', // Ensures unique controller instance
    );

    log("TrackingWidget rendered for $slug - Day: $ramadan_day");

    return Obx(() {
      if (controller.trackingOptions.isEmpty) {
        return const Center(child: Text("No options available"));
      }
      if (controller.isLoadingOptions.value) {
        return const Center(
            child: CupertinoActivityIndicator(
          color: AppColors.primary,
        ));
      } else
        return Stack(
          children: [
            Column(
              children: [
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          margin: const EdgeInsets.only(bottom: 5),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6)),
                            color: AppColors.primary,
                          ),
                          child: Center(
                            child: Text(
                              controller.getTrackingName(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        if (ramadan_day > 20 && slug=='qadr_tracking')
                          Center(
                              child: ramadan_day % 2 == 0
                                  ? Text(
                                      "আজ ${ramadan_day}${Utils.getNumberSuffix(ramadan_day)} রমাদ্বন। আজ শেষ দশকের একটি (জোড়) রাত। আজ রাতেও 'আমাল করুন।জোড় রাতেও লাইলাতুল ক্বদর হতে পারে।",
                                      style:
                                          TextStyle(color: AppColors.primary),
                                    )
                                  : Text(
                                      "আজ ${ramadan_day}${Utils.getNumberSuffix(ramadan_day)} রমাদ্বন। আজ শেষ দশকের বিজোড় রাত।  বিজোড় রাতে বেশি বেশি 'আমাল করুন।সারারাত ধরে 'আমাল করুন।  বিজোড় রাতগুলিতে লাইলাতুল ক্বদর হওয়ার সম্ভাবনা প্রবল।",
                                      style:
                                          TextStyle(color: AppColors.primary),
                                    )),

                        // ✅ Mapping over tracking options
                        ...controller.trackingOptions.map<Widget>((option) {
                          final checked =
                              controller.checkedStates[option['_id']] ?? false;

                          // ✅ Checkbox List
                          if (controller.type == "checkbox") {
                            return CheckboxListTile(
                              secondary:
                                  controller.loadingStates[option['_id']] ==
                                          true
                                      ? const CupertinoActivityIndicator(
                                          color: AppColors.primary,
                                        )
                                      : checked
                                          ? Icon(Icons.check_circle,
                                              color: AppColors.primary)
                                          : const Icon(
                                              Icons.hourglass_empty_rounded,
                                              color: Colors.red),
                              activeColor:
                                  checked ? AppColors.primary : Colors.red,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(
                                  "${option['title']} [${option['point']} Points]"),
                              subtitle: ExpandableText(
                                option['description'],
                                expandText: 'show more',
                                collapseText: 'show less',
                                maxLines: 2,
                                linkColor: Colors.blue,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 12),
                              ),
                              value: checked,
                              onChanged: (bool? newValue) {
                                if (newValue != null) {
                                  controller.updateTrackingOption(
                                      option['_id'], newValue);
                                  controller.submitPoints(newValue
                                      ? option['point']
                                      : -option['point']);
                                }
                              },
                            );
                          }

                          // ✅ Switch List
                          if (controller.type == "switch") {
                            return SwitchListTile(
                              secondary:
                                  controller.loadingStates[option['_id']] ==
                                          true
                                      ? const CupertinoActivityIndicator(
                                          color: AppColors.primary,
                                        )
                                      : checked
                                          ? Icon(Icons.check_circle,
                                              color: AppColors.primary)
                                          : const Icon(
                                              Icons.hourglass_empty_rounded,
                                              color: Colors.red),
                              activeColor:
                                  checked ? AppColors.primary : Colors.red,
                              title: Text(
                                  "${option['title']} [${option['point']} Points]"),
                              subtitle: ExpandableText(
                                option['description'],
                                expandText: 'show more',
                                collapseText: 'show less',
                                maxLines: 2,
                                linkColor: Colors.blue,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 12),
                              ),
                              value: checked,
                              onChanged: (bool newValue) {
                                controller.updateTrackingOption(
                                    option['_id'], newValue);
                                controller.submitPoints(newValue
                                    ? option['point']
                                    : -option['point']);
                              },
                            );
                          }

                          return const SizedBox(); // Prevents returning null
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: controller.confettiController,
                blastDirection: -1.0, // Confetti falls down
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
