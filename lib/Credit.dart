import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'colors.dart';

class Credit extends StatefulWidget {
  const Credit({super.key});

  @override
  State<Credit> createState() => _CreditState();
}

class _CreditState extends State<Credit> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        Container(
            width: double.infinity,
            color: AppColors.PrimaryColor.withOpacity(0.026),
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Developed By:",
                  style: TextStyle(color: AppColors.PrimaryColor, fontSize: 20),
                ),
                SizedBox(
                  height: 6,
                ),
                GestureDetector(
                  onTap: () async {
                    await launchUrl(Uri.parse('https://pncsoft.tech'));
                  },
                  child: Text(
                    "PNC Soft Tech",
                    style:
                        TextStyle(color: AppColors.PrimaryColor, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                GestureDetector(
                  onTap: () async {
                    await launchUrl(Uri.parse('https://pncsoft.tech'));
                  },
                  child: Text(
                    "Website: https://pncsoft.tech",
                    style:
                        TextStyle(color: AppColors.PrimaryColor, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                GestureDetector(
                  onTap: () async {
                    await launchUrl(Uri.parse('https://wa.me/+8801793278360'));
                  },
                  child: Text(
                    "Whatsapp: +8801793278360",
                    style:
                        TextStyle(color: AppColors.PrimaryColor, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
              ],
            )),
        SizedBox(height: 8),
      ],
    );
  }
}
