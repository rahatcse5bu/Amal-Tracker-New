import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding

import 'package:ramadan_tracker/colors.dart';
import 'package:ramadan_tracker/login.dart';
import 'package:ramadan_tracker/main.dart';

class Borjoniyo extends StatefulWidget {
  const Borjoniyo({super.key});

  @override
  State<Borjoniyo> createState() => _BorjoniyoState();
}

class _BorjoniyoState extends State<Borjoniyo> {
  late Future<List<dynamic>> borjoniyoList;

  @override
  void initState() {
    super.initState();
    borjoniyoList = fetchBorjoniyo();
  }

  Future<List<dynamic>> fetchBorjoniyo() async {
    final response = await http.get(Uri.parse(
        'https://ramadan-tracker-server.vercel.app/api/v1/borjoniyos'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data[
          'data']; // Assuming the structure is similar to the koroniyo API
    } else {
      throw Exception('Failed to load borjoniyo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: Container(
            margin: EdgeInsets.fromLTRB(10, 0, 2, 0),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, '/koroniyo');
              },
            ),
          ),
          title: Text(
            "রমাদ্বনে বর্জনীয়",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: AppColors.PrimaryColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_forward),
              color: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder<List<dynamic>>(
              future: borjoniyoList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Column(
                    children: [
                      ...snapshot.data!
                          .map((item) => Card(
                                elevation: 3.5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: ListTile(
                                  leading: Icon(Icons.close),
                                  title: Text(item[
                                      'text']), // Assuming 'text' is the key for the text you want to display
                                ),
                              ))
                          .toList(),
                      SizedBox(height: 20), // Optional spacing
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.PrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          minimumSize: Size(double.infinity, 50), // full width
                        ),
                        onPressed: () {
                          // Navigator.pushNamed(context, '/dashboard');
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           Dashboard()), // Directly go to Borjoniyo class
                          // ); // Replace '/nextPage' with your actual next page route
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoginScreen()), // Directly go to Borjoniyo class
                          ); // Replace '/nextPage' with your actual next page route
                        },
                        child: const Text(
                          "পরবর্তী পৃষ্ঠা দেখুন",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
