import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For json decoding

import 'package:ramadan_tracker/colors.dart';

import 'page_2.dart';

class Koroniyo extends StatefulWidget {
  const Koroniyo({super.key});

  @override
  State<Koroniyo> createState() => _KoroniyoState();
}

class _KoroniyoState extends State<Koroniyo> {
  late Future<List<dynamic>> koroniyoList;

  @override
  void initState() {
    super.initState();
    koroniyoList = fetchKoroniyo();
  }

  Future<List<dynamic>> fetchKoroniyo() async {
    final response = await http.get(Uri.parse(
        'https://ramadan-tracker-server.vercel.app/api/v1/koroniyos'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load koroniyo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              "রমাদ্বনে করণীয়",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: AppColors.PrimaryColor,
            actions: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(2, 0, 10, 0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, '/borjoniyo');
                  },
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: FutureBuilder<List<dynamic>>(
                future: koroniyoList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: const CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      children: <Widget>[
                        ...snapshot.data!.map((koroniyo) => Card(
                              elevation: 3.5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.wb_sunny),
                                title: Text(koroniyo['text']),
                              ),
                            )),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.PrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15), // Add vertical padding
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Borjoniyo()), // Directly go to Borjoniyo class
                                  );
                                  print("clicked");
                                },
                                child: const Text(
                                  "পরবর্তী পৃষ্ঠা দেখুন",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }
}
