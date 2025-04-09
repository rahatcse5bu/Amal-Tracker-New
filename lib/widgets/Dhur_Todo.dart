//import main.dart
import 'dart:convert';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ramadan_tracker/colors.dart';

import 'package:ramadan_tracker/Data/data.dart';

import '../Data/localStorageFunc.dart';

class Dhuhr_Todo extends StatefulWidget {
  Dhuhr_Todo({super.key, required this.ramadan_day});
  int ramadan_day;
  @override
  State<Dhuhr_Todo> createState() => _Dhuhr_TodoState();
}

class _Dhuhr_TodoState extends State<Dhuhr_Todo> {
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
                          "যোহর ট্রাকিং",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    // CheckboxListTile

                    for (var i = 0; i < Dhuhr_Items.length; i++) ...[
                      CheckboxListTile(
                        secondary: Dhuhr_Items[i]['isChecked'] == false
                            ? Icon(
                                Icons.close,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.check,
                                color: AppColors.PrimaryColor,
                              ),
                        activeColor: Dhuhr_Items[i]['isChecked'] == false
                            ? Colors.red
                            : AppColors.PrimaryColor,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(Dhuhr_Items[i]['title']),
                        isThreeLine: true,
                        subtitle: ExpandableText(
                          Dhuhr_Items[i]['subTitle'],
                          expandText: 'show more',
                          collapseText: 'show less',
                          maxLines: 2,
                          linkColor: Colors.blue,
                          style: TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 12),
                        ),
                        value: Dhuhr_Items[i]['isChecked'],
                        onChanged: (newValue) {
                          setState(() {
                            Dhuhr_Items[i]['isChecked'] = newValue;
                            setValueToLocalStorage(
                                'Dhuhr_Items' + widget.ramadan_day.toString(),
                                json.encode(Dhuhr_Items));
                            if (Dhuhr_Items.where((e) => e['isChecked'] == true)
                                    .length ==
                                Dhuhr_Items.length) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    //confetti animation

                                    return AlertDialog(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.check_circle,
                                              color: AppColors.PrimaryColor),
                                          SizedBox(width: 2),
                                          Text('জাযাকাল্লহু খইরন!'),
                                        ],
                                      ),
                                      content: Text(
                                          "জাযাকাল্লহু খইরন। আপনি সফলভাবে আজকের যোহরের কাজগুলো সম্পন্ন করেছেন! "),
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
                                'Dhuhr_Items_Count' +
                                    widget.ramadan_day.toString(),
                                Dhuhr_Items.where((e) => e['isChecked'] == true)
                                    .length);
                            print(
                                Dhuhr_Items.where((e) => e['isChecked'] == true)
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
