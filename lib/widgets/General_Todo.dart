//import main.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ramadan_tracker/colors.dart';
import 'package:ramadan_tracker/Data/data.dart';

import '../Data/localStorageFunc.dart';

class General_Todo extends StatefulWidget {
  General_Todo({super.key, required this.ramadan_day});
  int ramadan_day;
  @override
  State<General_Todo> createState() => _General_TodoState();
}

class _General_TodoState extends State<General_Todo> {
  bool? val = false;
  final LocalStorage storage = new LocalStorage('ramadan_planner_1');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Todo list with SwitchListTile widget and a button to add new todo
        Column(children: [
          Card(
              elevation: 5,
              child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Column(children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      margin: EdgeInsets.only(bottom: 5),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6)),
                          color: AppColors.PrimaryColor),
                      child: Center(
                        child: Text(
                          "অত্যন্ত প্রয়োজনীয়:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    // CheckboxListTile

                    for (var i = 0; i < General_Items.length; i++) ...[
                      SwitchListTile(
                        secondary: General_Items[i]['isChecked'] == false
                            ? Icon(
                                Icons.close,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.check,
                                color: AppColors.PrimaryColor,
                              ),
                        activeColor: General_Items[i]['isChecked'] == false
                            ? Colors.red
                            : AppColors.PrimaryColor,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(General_Items[i]['title']),
                        isThreeLine: true,
                        subtitle: Text(
                          General_Items[i]['subTitle'],
                          style: TextStyle(fontSize: 10),
                        ),
                        value: General_Items[i]['isChecked'],
                        onChanged: (bool? newValue) {
                          setState(() {
                            General_Items[i]['isChecked'] = newValue;
                            setValueToLocalStorage(
                                'General_Items' + widget.ramadan_day.toString(),
                                json.encode(General_Items));
                            if (General_Items.where(
                                    (e) => e['isChecked'] == true).length ==
                                General_Items.length) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.check_circle,
                                              color: AppColors.PrimaryColor),
                                          SizedBox(width: 2),
                                          Text('জাযাকাল্লহু খইরন!'),
                                        ],
                                      ),
                                      content: Text(
                                          "জাযাকাল্লহু খইরন। আপনি সফলভাবে আজকের কাজগুলো সম্পন্ন করেছেন! "),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Center(child: Text('ঠিক আছে')),
                                        ),
                                      ],
                                    );
                                  });
                              print("All Done");
                            }
                            storage.setItem(
                                'General_Items_Count' +
                                    widget.ramadan_day.toString(),
                                General_Items.where(
                                    (e) => e['isChecked'] == true).length);
                            print(General_Items.where(
                                (e) => e['isChecked'] == true).length);
                          });
                        },
                      ),
                    ]
                  ]))),
        ])
      ],
    );
  }
}
