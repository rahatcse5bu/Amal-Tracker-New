import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ramadan_tracker/app/common/widgets/custom_appbar_widget.dart';
import '../../../app/constants/app_color.dart';
import '../../../app/translation/translation_keys.dart';
import '../controller/borjoniyo_controller.dart';

class BorjoniyoView extends GetView<BorjoniyoController> {
  const BorjoniyoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar: CustomAppBar.appBar(title: '', leadingWidget: Icon(Icons.arrow_back,color: Colors.white,),leadingWidth: 90.w, onLeadingPressed: ()=>
        Get.back()
      ),
      body: 
      Obx(()=>Center(
          child: Align(
        alignment: Alignment.center,
        child: SizedBox(
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
                              '${TranslationKeys.ramadaneBorjoniyo.tr}',
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
                  :    Expanded(
                child: ListView.builder(
                    itemCount: controller.borjoniyoList.length,
                    itemBuilder: (context, index) {
                      String borjoniyoText =
                          controller.borjoniyoList[index].text;

                      return Card(
                        elevation: 3.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.dangerous_sharp, color: Colors.red,),
                          title: Text(
                              borjoniyoText), // Assuming 'text' is the key for the text you want to display
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      )),)
    );
  }
}
