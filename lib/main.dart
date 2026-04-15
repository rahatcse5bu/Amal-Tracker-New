import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'app/common/binding/global_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/translation/app_translation.dart';
import 'app/translation/language_controller.dart';
import 'modules/dashboard/controller/dashboard_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();

  // Initialize location service
  await Geolocator.requestPermission();
  await Geolocator.isLocationServiceEnabled();

  final languageController =
      Get.put(LanguageController()); // Direct put (not lazy)

  // Ensure locale is loaded before app starts
  await languageController.loadLocale(); // New function you will add below
  Get.lazyPut(() => DashboardController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Locale? initialLocale;

  MyApp({Key? key, this.initialLocale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
