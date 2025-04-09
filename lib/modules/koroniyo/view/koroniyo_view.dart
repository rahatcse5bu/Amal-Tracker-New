import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ramadan_tracker/app/common/widgets/custom_appbar_widget.dart';
import '../../../app/constants/app_color.dart';
import '../../../app/translation/translation_keys.dart';
import '../controller/koroniyo_controller.dart';

class KoroniyoView extends GetView<KoroniyoController> {
  const KoroniyoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(title: '', leadingWidget: Icon(Icons.arrow_back,color: Colors.white,),leadingWidth: 110.w, onLeadingPressed: ()=>
        Get.back()
      ),
      body: Obx(
        () => Center(
            child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
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
                              '${TranslationKeys.ramadaneKoroniyo.tr}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 10.h,
              ),
              controller.isLoading.value
                  ? Center(
                    child: CupertinoActivityIndicator(
                        color: AppColors.primary,
                      ),
                  )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: controller.koroniyoList.length,
                          itemBuilder: (context, index) {
                            String koroniyoText =
                                controller.koroniyoList[index].text;

                            return Card(
                              elevation: 3.5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: ListTile(
                                leading: Icon(Icons.check_circle_outline_sharp),
                                title: Text(
                                    koroniyoText), // Assuming 'text' is the key for the text you want to display
                              ),
                            );
                          }),
                    ),
            ],
          ),
        )),
      ),
    );
  }
}
