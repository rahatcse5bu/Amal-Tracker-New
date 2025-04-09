import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

import 'app/constants/app_color.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  LocalStorage storage = new LocalStorage('ramadan_tracker');
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse(
          'https://ramadan-tracker-server.vercel.app/api/v1/users/login'), // Replace with your API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'identifier': _identifierController.text,
        'password': _passwordController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      // Handle successful login
      final data = json.decode(response.body);
      print("logged data" + data.toString());

// Access the nested user data correctly
      String _id = data['data']['user']['_id'];
      String userName = data['data']['user']['userName'];
      String fullName = data['data']['user']['fullName'];

// Ensure the LocalStorage is ready before setting items
      await storage.ready;

      storage.setItem('_id', _id);
      storage.setItem('userName', userName);
      storage.setItem('fullName', fullName);
            Fluttertoast.showToast(
                                  msg: "আপনার লগিন সফল হয়েছে",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
      // Navigator.of(context).pushNamed('/dashboard');
      Navigator.of(context).pushNamed('/koroniyo');
      // Navigate to another screen or show a success message
    } else {
      // Handle error
      final error = json.decode(response.body);
      // Show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: Container(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: AppColors.primary,
              child: Image.asset("images/Ramadan_Tracker.png")),
            TextFormField(
              controller: _identifierController,
              decoration: InputDecoration(
                labelText: 'Username/Email',
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.primary), // Border color
                  borderRadius: BorderRadius.circular(10.0), // Border radius
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.primary), // Border color
                  borderRadius: BorderRadius.circular(10.0), // Border radius
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : Container(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the radius according to your preference
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.primary, // Text color
                      ),
                      onPressed: _login,
                      child: Text('Login',style: TextStyle(fontSize: 20,color:Colors.white),),
                    ),
                  ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/register');
              },
              child: Text(
                "New to Ramadan Tracker? Register here",
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
