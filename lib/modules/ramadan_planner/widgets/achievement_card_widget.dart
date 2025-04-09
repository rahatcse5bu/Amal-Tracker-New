import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:ramadan_tracker/app/common/storage/storage_controller.dart';

import '../../../Data/data.dart';
import '../../../app/constants/app_color.dart';
import '../controller/ramadan_planner_controller.dart';

class AchievementWidget extends GetWidget<RamadanPlannerController> {
  final int ramadan_day;

  const AchievementWidget({
    Key? key,
    required this.ramadan_day,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin: EdgeInsets.only(bottom: 5),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6)),
                      color: AppColors.primary),
                  child: Center(
                    child: Text(
                      "বিশেষ অর্জন",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controller.specialAchievementController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'আপনার বিশেষ অর্জন টাইপ করুন...',
                  ),
                  maxLines: 5,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.primary),
                  ),
                  onPressed: () async {
                    controller.saveAchievement(controller.ramadan_date_key.value);
                 
                  },
                  child: Text(
                    'আপনার অর্জন সাবমিট করুন',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
