import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/common/binding/global_binding.dart';
import 'app/common/controller/app_update_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/translation/app_translation.dart';
import 'app/translation/language_controller.dart';
import 'modules/dashboard/controller/dashboard_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
   final languageController = Get.put(LanguageController());  // Direct put (not lazy)

  // Ensure locale is loaded before app starts
  await languageController.loadLocale();   // New function you will add below
  Get.lazyPut(() => DashboardController());
  Get.lazyPut(() => AppUpdateController());

    
  // Get.put<ApiHelper>(ApiHelper());           // Add this!
  // Get.put<AppUpdateController>(AppUpdateController());
  // await languageController.appLocale(); // Load locale before app start

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Locale? initialLocale;

  MyApp({Key? key, this.initialLocale}) : super(key: key);
  final AppUpdateController updateController = Get.put(AppUpdateController());

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => updateController.checkForUpdate());
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ramadan Tracker',
          theme: ThemeData(primarySwatch: Colors.blue),
          initialBinding: GlobalBinding(),
          initialRoute: Routes.splash,
          getPages: AppPages.routes,
          // Localization
          translations: AppTranslation(),
          locale: Get.find<LanguageController>().appLocale ?? Get.deviceLocale,
          fallbackLocale: const Locale('bn', 'BD'), // Default to Bangla
        );
      },
    );
  }
}
