//import main.dart
import 'dart:convert';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ramadan_tracker/colors.dart';
import 'package:ramadan_tracker/Data/data.dart';
//import firebase core and firestore
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../Data/localStorageFunc.dart';

class Qadr_Todo extends StatefulWidget {
  Qadr_Todo({super.key, required this.ramadan_day});
  int ramadan_day;
  @override
  State<Qadr_Todo> createState() => _Qadr_TodoState();
}

class _Qadr_TodoState extends State<Qadr_Todo> {
  bool? val = false;
  LocalStorage storage = new LocalStorage('ramadan_planner_1');

  // final CollectionReference _users =
  //     FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //ExpansionTile

        // Todo list with SwitchListTile widget and a button to add new todo
        Column(children: [
          SizedBox(height: 10),
          widget.ramadan_day > 20
              ? ExpansionTile(
                  //icon background color
                  collapsedBackgroundColor: Colors.transparent,
                  collapsedIconColor: Colors.white,
                  // backgroundColor: AppColors.PrimaryColor,
                  iconColor: Colors.white,
                  subtitle: Center(
                      child: widget.ramadan_day % 2 == 0
                          ? Text(
                              "আজ ${widget.ramadan_day} রমাদ্বন। আজ শেষ দশকের একটি (জোড়) রাত। আজ রাতেও 'আমাল করুন।জোড় রাতেও লাইলাতুল ক্বদর হতে পারে।(ক্বদের বিশেষ 'আমাল পেতে ডানপাশের অ্যারো বাটনে ক্লিক করুন)",
                              style: TextStyle(color: AppColors.PrimaryColor),
                            )
                          : Text(
                              "আজ ${widget.ramadan_day} রমাদ্বন। আজ শেষ দশকের বিজোড় রাত।  বিজোড় রাতে বেশি বেশি 'আমাল করুন।সারারাত ধরে 'আমাল করুন।  বিজোড় রাতগুলিতে লাইলাতুল ক্বদর হওয়ার সম্ভাবনা প্রবল।(ক্বদের বিশেষ 'আমাল পেতে ডানপাশের অ্যারো বাটনে ক্লিক করুন)",
                              style: TextStyle(color: AppColors.PrimaryColor),
                            )),
                  trailing: Icon(Icons.arrow_drop_down_circle,
                      color: AppColors.PrimaryColor, size: 30),
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    margin: EdgeInsets.only(bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6)),
                        color: AppColors.PrimaryColor),
                    child: Center(
                      child: Text(
                        "ক্বদর ট্রাকিং:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  children: [
                    Card(
                        elevation: 5,
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 10),
                            child: Column(children: [
                              // Container(
                              //   padding: EdgeInsets.symmetric(
                              //       vertical: 10, horizontal: 10),
                              //   margin: EdgeInsets.only(bottom: 5),
                              //   width: MediaQuery.of(context).size.width,
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.only(
                              //           topLeft: Radius.circular(6),
                              //           topRight: Radius.circular(6)),
                              //       color: AppColors.PrimaryColor),
                              //   child: Center(
                              //     child: Text(
                              //       "ক্বদর ট্রাকিং:",
                              //       style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //           fontSize: 20,
                              //           color: Colors.white),
                              //     ),
                              //   ),
                              // ),
                              // CheckboxListTile

                              for (var i = 0; i < Qadr_Data.length; i++) ...[
                                CheckboxListTile(
                                  secondary: Qadr_Data[i]['isChecked'] == false
                                      ? Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        )
                                      : Icon(
                                          Icons.check,
                                          color: AppColors.PrimaryColor,
                                        ),
                                  activeColor:
                                      Qadr_Data[i]['isChecked'] == false
                                          ? Colors.red
                                          : AppColors.PrimaryColor,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(Qadr_Data[i]['title']),
                                  isThreeLine: true,
                                  subtitle: ExpandableText(
                                    Qadr_Data[i]['description'],
                                    expandText: 'show more',
                                    collapseText: 'show less',
                                    maxLines: 2,
                                    linkColor: Colors.blue,
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12),
                                  ),
                                  // Text(
                                  //   Qadr_Data[i]['subTitle'],
                                  //   style: TextStyle(fontSize: 10),
                                  // ),
                                  value: Qadr_Data[i]['isChecked']!,
                                  onChanged: (newValue) async {
                                    Qadr_Data[i]['isChecked'] = newValue;

                                    setState(() {
                                      Qadr_Data[i]['isChecked'] = newValue;
                                      setValueToLocalStorage(
                                          'Qadr_Data' +
                                              widget.ramadan_day.toString(),
                                          json.encode(Qadr_Data));
                                      if (Qadr_Data.where(
                                                  (e) => e['isChecked'] == true)
                                              .length ==
                                          Qadr_Data.length) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Icon(Icons.check_circle,
                                                        color: AppColors
                                                            .PrimaryColor),
                                                    SizedBox(width: 2),
                                                    Text('জাযাকাল্লহু খইরন!'),
                                                  ],
                                                ),
                                                content: Text(
                                                    "জাযাকাল্লহু খইরন। আপনি সফলভাবে আজকের রাতের কাজগুলো সম্পন্ন করেছেন! "),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Center(
                                                        child: Text('ঠিক আছে')),
                                                  ),
                                                ],
                                              );
                                            });
                                        print("All Done");
                                      }

                                      storage.setItem(
                                          'Qadr_Data_Count' +
                                              widget.ramadan_day.toString(),
                                          Qadr_Data.where(
                                                  (e) => e['isChecked'] == true)
                                              .length);
                                      setState(() {
                                        todays_point = Qadr_Data.where(
                                                (e) => e['isChecked'] == true)
                                            .length;
                                        // _users.add({"name": "Rahat", "price": 23});
                                      });
                                      print("todays point" +
                                          todays_point.toString());
                                      print("Day: " +
                                          widget.ramadan_day.toString());
                                      print(Qadr_Data.where(
                                              (e) => e['isChecked'] == true)
                                          .length);
                                    });
                                  },
                                ),
                              ]
                            ])))
                  ],
                )
              : Container(),
        ])
      ],
    );
  }
}
