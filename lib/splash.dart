import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';
import 'app/common/storage/storage_controller.dart';
import 'app/routes/app_pages.dart';
import 'colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalStorage storage = LocalStorage('amal_tracker');

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await storage.ready;
    await Future.delayed(Duration(seconds: 2));

    bool isLoggedIn = await StorageHelper.isLoggedIn();
    if (isLoggedIn) {
      Get.offAllNamed(Routes.main);
    } else {
      Get.offAllNamed(Routes.login);
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
              CircularProgressIndicator(backgroundColor: Colors.white),
              SizedBox(height: 20),
              Text("Developed By: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
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
        Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
        SizedBox(height: 5),
        Text(batch, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
        SizedBox(height: 5),
        Text(university, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}
