import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:ramadan_tracker/InputTracking.dart';
import 'package:ramadan_tracker/Tracking-Old.dart';
import 'package:ramadan_tracker/login.dart';
import 'Credit.dart';
import 'Data/data.dart';
import 'PlannerController.dart';
import 'Tracking.dart';
import 'colors.dart';

import 'main.dart';
import 'widgets/Evening_Todo.dart';
import 'widgets/General_Todo.dart';
import 'widgets/Good_Afternoon_Todo.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';

class RamadanPlanner extends StatefulWidget {
  RamadanPlanner({super.key, required this.ramadan_day});
    final GlobalKey<_RamadanPlannerState> plannerKey = GlobalKey();
    
  int ramadan_day;
  State<RamadanPlanner> createState() => _RamadanPlannerState();
}

class _RamadanPlannerState extends State<RamadanPlanner> {
   
  var current_month = HijriCalendar.now().getLongMonthName();
  var current_date = HijriCalendar.now().hDay;
  var current_year = HijriCalendar.now().hYear;
  final _random = new Random();
  var todays_point = 0;
  var endName = 0;
  var startName = 0;
  TextEditingController special_achievemnt_controller =
      new TextEditingController();

  String ajkerHadith = "";
  String ajkerDuaTitle = "";
  String ajkerDuaBangla = "";
  String ajkerDuaArabic = "";
  String ajkerAyat = "";
  bool isLoadingHadith = true;
  bool isLoadingDua = true;
  bool isLoadingAyat = true;
  bool isLoadingPoint = true;
  Timer? _timer;
  final LocalStorage storage = LocalStorage('ramadan_tracker');
  final PlannerController plannerController = Get.put(PlannerController());

  // Future<int> fetchTodaysPoint() async {
  //   await storage.ready;
  //   String user_id = storage.getItem('_id');
  //   final response = await http.get(Uri.parse(
  //       'https://ramadan-tracker-server.vercel.app/api/v1/users/points/' +
  //           user_id.toString() +
  //           '/day' +
  //           widget.ramadan_day.toString()));
  //   // print('https://ramadan-tracker-server.vercel.app/api/v1/users/points/' +
  //   //     user_id.toString() +
  //   //     '/day' +
  //   //     widget.ramadan_day.toString());
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     // print("ponits=?>"+data.toString());
  //     if (data["success"]) {
  //       print("ponits=??>" + data["data"]['total'].toString());
  //       setState(() {
  //         todays_point = data["data"]["total"];
  //         isLoadingPoint = false;
  //       });
  //       return todays_point;
  //     }
  //   }
  //   return 0;
  // }

  Future<void> fetchAjkerHadith() async {
    final response = await http.get(Uri.parse(
        'https://ramadan-tracker-server.vercel.app/api/v1/ajkerhadiths'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["success"]) {
        setState(() {
          ajkerAyat = data["data"][0]["text"];
          isLoadingHadith = false;
        });
      }
    }
  }

  Future<void> fetchAjkerAyat() async {
    final response = await http.get(Uri.parse(
        'https://ramadan-tracker-server.vercel.app/api/v1/ajkerqurans'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["success"]) {
        setState(() {
          ajkerHadith = data["data"][0]["text"];
          isLoadingAyat = false;
        });
      }
    }
  }

  Future<void> fetchAjkerDua() async {
    final response = await http.get(Uri.parse(
        'https://ramadan-tracker-server.vercel.app/api/v1/ajkerduas'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["success"]) {
        setState(() {
          ajkerDuaTitle = data["data"][0]["title"];
          ajkerDuaBangla = data["data"][0]["bangla"];
          ajkerDuaArabic = data["data"][0]["arabic"];

          isLoadingDua = false;
        });
      }
    }
  }

  Future<void> addInputValueForUser() async {
    await storage.ready;
    var user_id = storage.getItem('_id');
    final Uri apiUri = Uri.parse(
        'https://ramadan-tracker-server.vercel.app/api/v1/users/add-values/$user_id');
    final response = await http.post(
      apiUri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'day': widget.ramadan_day.toString(),
        'value': special_achievemnt_controller.text,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully added the value
      Fluttertoast.showToast(msg: "Value added successfully");
    } else {
      // Handle errors or unsuccessful attempts
      Fluttertoast.showToast(msg: "Failed to add value. Please try again.");
    }
  }

  @override
  void initState() {
    fetchAjkerHadith();
    fetchAjkerDua();
    fetchAjkerAyat();
    // fetchTodaysPoint();
     plannerController.fetchTodaysPoint(widget.ramadan_day);
   
  String initialValue = storage.getItem("special_achievement${widget.ramadan_day}") ?? '';
  special_achievemnt_controller = TextEditingController(text: initialValue);
    // _timer =
    //     Timer.periodic(Duration(seconds: 5), (Timer t) => fetchTodaysPoint());
    endName = widget.ramadan_day * 3;
    startName = endName - 3;
    super.initState();
  }

  // @override
  // void dispose() {
  //   _timer?.cancel(); // Cancel the timer when the widget is disposed
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var yearAH;
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.fromLTRB(10, 0, 2, 0),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
                  plannerController.fetchCurrentUserPoints();
              Navigator.of(context).pop();
            
                  //  Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) =>
                  //                   Dashboard()), // Directly go to Borjoniyo class
                  //         ); 
                   Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoginScreen()), // Directly go to Borjoniyo class
                          ); 
            },
          ),
        ),
        backgroundColor: AppColors.PrimaryColor,
        title: Text(
          '${widget.ramadan_day} রমাদ্বন ${current_year}',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body:

//checklist tile widget

          SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),

              Card(
                child: Container(
                  // color: AppColors.PrimaryColor,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6)),
                    color: AppColors.PrimaryColor,
                  ),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  child: Column(
                    children: [
                  Obx(() => Text(
      "আজকের পয়েন্ট: ${plannerController.todaysPoint}",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white),
    ))
                    ],
                  ),
                ),
              ),

              // 2 columns with card  for hadith and ayat of the day
              Column(
                children: [
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 10),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            margin: EdgeInsets.only(bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6)),
                                color: AppColors.PrimaryColor),
                            child: Center(
                              child: Text(
                                "আজকের হাদিস",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          // Divider(
                          //   color: AppColors.PrimaryColor,
                          //   height: 10,
                          //   thickness: 1,
                          //   // indent: 20,
                          //   // endIndent: 20,
                          // ),
                          isLoadingHadith
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: AppColors.PrimaryColor,
                                ))
                              : ExpandableText(
                                  // todays_hadith.toString(),
                                  ajkerHadith.toString(),
                                  expandText: 'show more',
                                  collapseText: 'show less',
                                  maxLines: 4,
                                  linkColor: Colors.blue,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 10),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            margin: EdgeInsets.only(bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6)),
                                color: AppColors.PrimaryColor),
                            child: Center(
                              child: Text(
                                "আজকের আয়াত",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),

                          isLoadingAyat
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: AppColors.PrimaryColor,
                                ))
                              : ExpandableText(
                                  // todays_ayat.toString(),
                                  ajkerAyat.toString(),
                                  expandText: 'show more',
                                  collapseText: 'show less',
                                  maxLines: 4,
                                  linkColor: Colors.blue,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12),
                                ),

                          // Text(
                          //     "The Messenger of Allah (ﷺ) said: ‘Whoever prays the night prayer in Ramadan out of sincere faith and hoping to attain Allah’s rewards, then all his previous sins will be forgiven.’"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // NightTrackingPage(ramadan_day: widget.ramadan_day),
              widget.ramadan_day > 20
                  ? Tracking(
                      ramadan_day: widget.ramadan_day,
                      type: 'switch',
                      slug: 'qadr_tracking',
                      
                    )
                  : Container(),
              Tracking(
                ramadan_day: widget.ramadan_day,
                type: 'switch',
                slug: 'night_tracking',
          
              ),
              Tracking(
                ramadan_day: widget.ramadan_day,
                type: 'checkbox',
                slug: 'fajr_tracking',
               
              ),
              Tracking(
                ramadan_day: widget.ramadan_day,
                type: 'switch',
                slug: 'zuhr_tracking',
             
              ),
              // InputTracking(
              //   ramadan_day: widget.ramadan_day,
              // ),

              // column for dua of the day
              Column(
                children: [
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 10),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            margin: EdgeInsets.only(bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6)),
                                color: AppColors.PrimaryColor),
                            child: Center(
                              child: Text(
                                "আজকের দু'আ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          isLoadingDua
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: AppColors.PrimaryColor,
                                ))
                              : Text(
                                  // todays_dua['title'].toString(),

                                  ajkerDuaTitle.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          isLoadingDua
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: AppColors.PrimaryColor,
                                ))
                              : ExpandableText(
                                  // todays_dua['subTitle'].toString(),

                                  ajkerDuaArabic,
                                  expandText: 'show more',
                                  collapseText: 'show less',
                                  maxLines: 4,
                                  linkColor: AppColors.PrimaryColor,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          isLoadingDua
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: AppColors.PrimaryColor,
                                ))
                              : ExpandableText(
                                  ajkerDuaBangla,
                                  expandText: 'show more',
                                  collapseText: 'show less',
                                  maxLines: 4,
                                  linkColor: AppColors.PrimaryColor,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12),
                                ),
                          // Text(
                          //     "The Messenger of Allah (ﷺ) said: ‘Whoever prays the night prayer in Ramadan out of sincere faith and hoping to attain Allah’s rewards, then all his previous sins will be forgiven.’"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Tracking(
                ramadan_day: widget.ramadan_day,
                type: 'switch',
                slug: 'general_tracking',
                
              ),
              Good_Afternoon_Todo(ramadan_day: widget.ramadan_day),
              Tracking(
                ramadan_day: widget.ramadan_day,
                type: 'switch',
                slug: 'asr_tracking',
           
              ),
              Tracking(
                ramadan_day: widget.ramadan_day,
                type: 'checkbox',
                slug: 'evening_tracking',
        
              ),

              // General_Todo(ramadan_day: widget.ramadan_day),
              // Good_Afternoon_Todo(ramadan_day: widget.ramadan_day),
              // Evening_Todo(ramadan_day: widget.ramadan_day),
              SizedBox(
                height: 10,
              ),

              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                margin: EdgeInsets.only(bottom: 5),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                    color: AppColors.PrimaryColor),
                child: Center(
                    child: Text("আসমাউল হুসনা:",
                        style: TextStyle(fontSize: 25, color: Colors.white))),
              ),

              // a table widget with the name of Allah and the meaning of the name
              Container(
                margin: EdgeInsets.all(10),
                child: Table(
                  border: TableBorder.all(
                      color: AppColors.PrimaryColor,
                      width: 1,
                      style: BorderStyle
                          .solid, //tablerow margin 10 from top and bottom
                      borderRadius: BorderRadius.circular(5)),

                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  //tablerow margin 10 from top and bottom and 5 from left and

                  children: [
                    for (var name = startName; name < endName; name++) ...[
                      TableRow(children: [
                        Center(
                            child: Text(
                          Asmaul_Husna[name],
                          style: TextStyle(fontSize: 20),
                        ))
                      ]),
                    ],
                  ],
                ),
              ),
              //column for special achievements with textinputfield textarea
              Column(
                children: [
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            margin: EdgeInsets.only(bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6)),
                                color: AppColors.PrimaryColor),
                            child: Center(
                              child: Text(
                                "বিশেষ অর্জন",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                      //       initialValue:
                      //           storage.getItem("special_achievement") == null  || storage.getItem("special_achievement") =="" || storage.getItem("special_achievement") ==" "
                      //               ? " ": storage.getItem("special_achievement")
                      // ,
                            controller: special_achievemnt_controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'আপনার বিশেষ অর্জন টাইপ করুন...',
                            ),
                            maxLines: 5,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppColors.PrimaryColor),
                            ),
                            onPressed: () async {
                              // addInputValueForUser();
                              storage.setItem(
                                  "special_achievement" +
                                      widget.ramadan_day.toString(),
                                  special_achievemnt_controller.text);
                              Fluttertoast.showToast(
                                  msg: "আপনার তথ্য সংরক্ষণ করা হয়েছে",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            },
                            child: Text(
                              'আপনার অর্জন সাবমিট করুন',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Evening_Todo()
              Credit(),
            ],
          ),
        ),
      ),
    );
  }
}
