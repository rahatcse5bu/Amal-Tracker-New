import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ramadan_tracker/login.dart'; // Assuming this is your login screen
import 'package:ramadan_tracker/main.dart';
import 'splash.dart'; // Assuming this is your splash screen


class InitData extends StatefulWidget {
  const InitData({Key? key}) : super(key: key);

  @override
  State<InitData> createState() => _InitDataState();
}

class _InitDataState extends State<InitData> {
  final LocalStorage storage = LocalStorage('ramadan_tracker');

  @override
  void initState() {
    super.initState();
    storage.ready.then((_) => setState(() {}));
  }

  Future<bool> checkUserLoggedIn() async {
    await Future.delayed(Duration(seconds: 5)); // Simulating some waiting time
    return storage.getItem('userName') != null || storage.getItem('fullName') != null && storage.getItem('_id') != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkUserLoggedIn(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen(); // Assuming this returns a splash screen widget
        } else if (snapshot.data == true) {
          // return Dashboard(); // Assuming Dashboard is your main screen when logged in
          return Wrap(); // Assuming Dashboard is your main screen when logged in
        } else {
          return LoginScreen(); // Your login screen widget
        }
      },
    );
  }
}
