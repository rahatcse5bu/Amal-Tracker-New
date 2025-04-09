//import main.dart
import 'dart:convert';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ramadan_tracker/colors.dart';
import 'package:ramadan_tracker/Data/data.dart';

import '../Data/localStorageFunc.dart';

class Fajr_Todo extends StatefulWidget {
  Fajr_Todo({super.key, required this.ramadan_day});
  int ramadan_day;
  @override
  State<Fajr_Todo> createState() => _Fajr_TodoState();
}

class _Fajr_TodoState extends State<Fajr_Todo> {
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
                  padding: EdgeInsets.all(10.0),
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
                          "ফজর ট্রাকিং:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    // CheckboxListTile

                    for (var i = 0; i < Fajr_Items.length; i++) ...[
                      SwitchListTile(
                        secondary: Fajr_Items[i]['isChecked'] == false
                            ? Icon(
                                Icons.close,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.check,
                                color: AppColors.PrimaryColor,
                              ),
                        activeColor: Fajr_Items[i]['isChecked'] == false
                            ? Colors.red
                            : AppColors.PrimaryColor,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(Fajr_Items[i]['title']),
                        isThreeLine: true,
                        subtitle: ExpandableText(
                          Fajr_Items[i]['subTitle'],
                          expandText: 'show more',
                          collapseText: 'show less',
                          maxLines: 2,
                          linkColor: Colors.blue,
                          style: TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 12),
                        ),
                        value: Fajr_Items[i]['isChecked'],
                        onChanged: (bool? newValue) {
                          setState(() {
                            Fajr_Items[i]['isChecked'] = newValue;
                            setValueToLocalStorage(
                                'Fajr_Items' + widget.ramadan_day.toString(),
                                json.encode(Fajr_Items));
                            if (Fajr_Items.where((e) => e['isChecked'] == true)
                                    .length ==
                                Fajr_Items.length) {
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
                                          "জাযাকাল্লহু খইরন। আপনি সফলভাবে আজকের ফজরের কাজগুলো সম্পন্ন করেছেন! "),
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
                                'Fajr_Items_Count' +
                                    widget.ramadan_day.toString(),
                                Fajr_Items.where((e) => e['isChecked'] == true)
                                    .length);

                            print(
                                Fajr_Items.where((e) => e['isChecked'] == true)
                                    .length);
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
