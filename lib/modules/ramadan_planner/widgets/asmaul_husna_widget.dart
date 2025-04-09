import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import '../../../Data/data.dart';
import '../../../app/constants/app_color.dart';
import '../controller/ramadan_planner_controller.dart';

class AsmaulHusnaWidget extends GetWidget<RamadanPlannerController> {
  const AsmaulHusnaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: Obx(() {
          // Ensure reactive updates by accessing controller values inside Obx
          final start = controller.startName.value;
          final end = controller.endName.value;

          return Table(
            border: TableBorder.all(
                color: AppColors.primary,
                width: 1,
                style:
                    BorderStyle.solid, //tablerow margin 10 from top and bottom
                borderRadius: BorderRadius.circular(5)),

            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            //tablerow margin 10 from top and bottom and 5 from left and

            children: [
              // Generate table rows for the current range
              for (int index = start; index < end; index++)
                _buildTableRow(Asmaul_Husna[index]),
            ],
          );
        }));
  }
}

TableRow _buildTableRow(String name) {
  return TableRow(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
    ),
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  );
}
