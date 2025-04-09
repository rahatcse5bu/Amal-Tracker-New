//import main.dart
import 'dart:convert';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ramadan_tracker/colors.dart';
import 'package:ramadan_tracker/Data/data.dart';

import '../Data/localStorageFunc.dart';

class Evening_Todo extends StatefulWidget {
  Evening_Todo({super.key, required this.ramadan_day});
  int ramadan_day;
  @override
  State<Evening_Todo> createState() => _Evening_TodoState();
}

class _Evening_TodoState extends State<Evening_Todo> {
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
                          "সন্ধ্যা ট্রাকিং",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    // CheckboxListTile

                    for (var i = 0; i < Evening_Items.length; i++) ...[
                      SwitchListTile(
                        secondary: Evening_Items[i]['isChecked'] == false
                            ? Icon(
                                Icons.close,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.check,
                                color: AppColors.PrimaryColor,
                              ),
                        activeColor: Evening_Items[i]['isChecked'] == false
                            ? Colors.red
                            : AppColors.PrimaryColor,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(Evening_Items[i]['title']),
                        isThreeLine: true,
                        subtitle: ExpandableText(
                          Evening_Items[i]['subTitle'],
                          expandText: 'show more',
                          collapseText: 'show less',
                          maxLines: 2,
                          linkColor: Colors.blue,
                          style: TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 12),
                        ),
                        //  Text(
                        //   Evening_Items[i]['subTitle'],
                        //   style: TextStyle(fontSize: 10),
                        // ),
                        value: Evening_Items[i]['isChecked'],
                        onChanged: (bool? newValue) {
                          setState(() {
                            Evening_Items[i]['isChecked'] = newValue;
                            setValueToLocalStorage(
                                'Evening_Items' + widget.ramadan_day.toString(),
                                json.encode(Evening_Items));
                            if (Evening_Items.where(
                                    (e) => e['isChecked'] == true).length ==
                                Evening_Items.length) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
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
                                          "জাযাকাল্লহু খইরন। আপনি সফলভাবে আজকের সন্ধ্যার কাজগুলো সম্পন্ন করেছেন! "),
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
                                'Evening_Items_Count' +
                                    widget.ramadan_day.toString(),
                                Evening_Items.where(
                                    (e) => e['isChecked'] == true).length);
                            print(Evening_Items.where(
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
