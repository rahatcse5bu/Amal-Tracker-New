import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'app/common/controller/app_update_controller.dart';
import 'app/common/storage/storage_controller.dart';
import 'app/routes/app_pages.dart';
import 'colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalStorage storage = LocalStorage('ramadan_tracker');
  final AppUpdateController updateController = Get.find<AppUpdateController>();

  // @override
  // void initState() {
  //   super.initState();
  //   _navigateToNextScreen();
  // }

  // Future<void> _navigateToNextScreen() async {
  //   await storage.ready;
  //   // Mimic loading time or perform actual initialization/loading work
  //   await Future.delayed(Duration(seconds: 5));
  //   // Check if user is logged in or not and navigate accordingly
  //     bool isLoggedIn = await StorageHelper.isLoggedIn();
  //     if (isLoggedIn) {
  //       Get.offAllNamed(Routes.home);  // Go to Home if logged in
  //     } else {
  //       Get.offAllNamed(Routes.login); // Go to Login if not logged in
  //     }
  // }
  @override
  void initState() {
    super.initState();
    _checkForUpdateAndNavigate();
  }

  Future<void> _checkForUpdateAndNavigate() async {
    await storage.ready;

    // Check for update before doing anything else
    final updateNeeded = await updateController.checkForUpdateWithResult();

    if (updateNeeded) {
      // Stop further navigation if update is required
      return;
    }

    // If no update required, continue normal flow (login check)
    await Future.delayed(Duration(seconds: 5));

    bool isLoggedIn = await StorageHelper.isLoggedIn();
    if (isLoggedIn) {
      Get.offAllNamed(Routes.home); // Go to Home if logged in
    } else {
      Get.offAllNamed(Routes.login); // Go to Login if not logged in
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.PrimaryColor,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/Ramadan_Tracker.png',
                height: 80,
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              SizedBox(height: 25),
              CircularProgressIndicator(backgroundColor: Colors.white),
              SizedBox(height: 20),
              Text("Developed By: ", style: GoogleFonts.nanumMyeongjo(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white))),
              SizedBox(height: 5),
              _developerInfo("Md. Rahat", "CSE 5th Batch", "University of Barisal"),
              SizedBox(height: 5,),
             Divider(height: 2,indent: 100,endIndent: 100,),
              SizedBox(height: 5,),
              SizedBox(width: 10),
              _developerInfo("Md. Anis Molla", "CSE 5th Batch", "University of Barisal"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _developerInfo(String name, String batch, String university) {
    return Column(
      children: [
        Text(name, style: GoogleFonts.nanumMyeongjo(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white))),
        SizedBox(height: 5),
        Text(batch, style: GoogleFonts.nanumMyeongjo(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white))),
        SizedBox(height: 5),
        Text(university, style: GoogleFonts.nanumMyeongjo(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white))),
      ],
    );
  }
}
