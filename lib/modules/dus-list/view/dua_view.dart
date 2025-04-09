import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ramadan_tracker/modules/dus-list/models/dua_model.dart';
import '../../../app/common/widgets/custom_appbar_widget.dart';
import '../../../app/constants/app_color.dart';
import '../controller/dua_controller.dart';
import '../widgets/dua_card_widget.dart';

class DuaView extends GetView<DuaController> {
  const DuaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(title: 'আজকের দোয়া', leadingWidget: Icon(Icons.arrow_back,color: Colors.white,),leadingWidth: 90.w, onLeadingPressed: ()=>
        Get.back()
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
        Column(
          children: [
                  SizedBox(
                height: 10.h,
              ),
              Card(
                color: Colors.white,
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
                              // '${TranslationKeys.ramadaneKoroniyo.tr}',
                              "দু'আ সমুহ",
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
           Obx(()=> Expanded(
              child: ListView.builder(
                itemCount: controller.DuaList.length,
                itemBuilder: (context, index) {
                 DuaModel dua= controller.DuaList[index];
                return DuaCardWidget(dua: dua);
              },),
            ),)
          ],
        )
        //  DuaCardWidget(),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
