import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramadan_tracker/Data/data.dart';

import '../../../app/common/utils/ramadan_utils.dart';
import '../../../app/constants/app_color.dart';
import '../../../app/routes/app_pages.dart';
import '../../../app/translation/translation_keys.dart';
import '../controller/dashboard_controller.dart';

class RamadanDaysList extends GetWidget<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
          for (var i = 0; i < controller.ramadanList.length; i++) ...[
              Card(
                elevation: 7.2,
                shape: RoundedRectangleBorder(
                  side: i + 1 <= calculate2025RamadanDate() &&
                          controller.current_month == "Ramadan"
                      ? BorderSide(color: AppColors.primary, width: 1)
                      : BorderSide(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  // border radius with cliprrect  and color with ternary operator
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  tileColor: i + 1 > 20 ? Colors.grey[250] : Colors.white,
                  title: i + 1 == calculate2025RamadanDate() &&
                          controller.current_month == "Ramadan"
                      ? Text('${TranslationKeys.ramadan.tr} - ${controller.ramadanList[i]}${Utils.getNumberSuffix(controller.ramadanList[i])} (${TranslationKeys.today.tr}) ')
                      : i + 1 > 20
                          ? Text(
                              '${TranslationKeys.ramadan.tr} - ${controller.ramadanList[i]}${Utils.getNumberSuffix(controller.ramadanList[i])} ',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text('${TranslationKeys.ramadan.tr} - ${controller.ramadanList[i]}${Utils.getNumberSuffix(controller.ramadanList[i])} '),
                  subtitle: i + 1 > 20
                      ? Text(
                          '${  TranslationKeys.trackRamadan.tr}',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                        )
                      : Text('${  TranslationKeys.trackRamadan.tr}'),
                  trailing: i + 1 > 20
                      ? i + 1 == 21 ||
                              i + 1 == 23 ||
                              i + 1 == 25 ||
                              i + 1 == 27 ||
                              i + 1 == 29
                          ? Icon(
                              Icons.diamond_rounded,
                              color: AppColors.primary,
                            )
                          : Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.primary,
                            )
                      : Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Get.toNamed(Routes.ramadanPlanner, arguments: {'ramadan_day': i+1});

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) =>
                    //           RamadanPlanner(ramadan_day: i + 1)),
                    // );
                  },
                ),
              ),
            ],
    ],);
  }
}
