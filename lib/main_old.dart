import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ramadan_tracker/login.dart';
import 'package:ramadan_tracker/register.dart';
import 'Credit.dart';
import 'Data/data.dart';
import 'PlannerController.dart';
import 'colors.dart';
import 'page_1.dart';
import 'page_2.dart';
import 'planner.dart';
import 'package:expandable_text/expandable_text.dart';
import 'splash.dart';
import 'package:intl/intl.dart';

import 'initData.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Dashboard(),
      initialRoute: '/splash',
      routes: {
        // '/splash': (context) => SplashScreenPage(),
        '/splash': (context) => SplashScreen(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/initData': (context) => InitData(),
        '/dashboard': (context) => Dashboard(),
        '/koroniyo': (context) => Koroniyo(),
        '/borjoniyo': (context) => Borjoniyo(),
      },
      //  RamadanPlanner(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<int> ramadanList = List.generate(30, (index) => index + 1);
  var current_month = HijriCalendar.now().getLongMonthName();
  var current_date = HijriCalendar.now().hDay;
  final _random = new Random();
  var todays_ayat;
  var todays_hadith;
  var todays_salaf_qoute;
  var total_points = 0;
  String ajkerHadith = "";
  String ajkerDuaTitle = "";
  String ajkerDuaBangla = "";
  String ajkerDuaArabic = "";
  String ajkerAyat = "";
  String ajkerSalafQuote = "";
  bool isLoadingHadith = true;
  bool isLoadingDua = true;
  bool isLoadingAyat = true;
  bool isLoadingSalafQuote = true;
  List<dynamic> users = [];
  bool isLoadingUsers = true;

  int _visibleItemCount = 25;
  bool _showAll = false;

  LocalStorage storage = LocalStorage('ramadan_tracker');
  late String userName;
  final PlannerController plannerController = Get.put(PlannerController());
  //end debug
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

  Future<void> fetchAjkerSalafQuote() async {
    final response = await http.get(Uri.parse(
        'https://ramadan-tracker-server.vercel.app/api/v1/salafquotes'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["success"]) {
        setState(() {
          ajkerSalafQuote = data["data"][0]["text"];
          isLoadingSalafQuote = false;
        });
      }
    }
  }

  fetchUsers() async {
    final response = await http.get(
        Uri.parse('https://ramadan-tracker-server.vercel.app/api/v1/users'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> fetchedUsers = data["data"];
      // Sort users by totalPoints in descending order
      fetchedUsers.sort((a, b) => b["totalPoints"].compareTo(a["totalPoints"]));
      setState(() {
        users =
            fetchedUsers; // Keep the entire user structure, including totalPoints
        isLoadingUsers = false;
      });
    } else {
      // Handle error or set a state indicating the fetch failed
    }
  }

  @override
  void initState() {
    todays_ayat = AjkerAyat[_random.nextInt(AjkerAyat.length)];
    todays_hadith = AjkerHadith[_random.nextInt(AjkerHadith.length)];
    todays_salaf_qoute = SalafQoutes[_random.nextInt(SalafQoutes.length)];
    userName = storage.getItem('userName');
    fetchAjkerHadith();
    fetchAjkerDua();
    fetchAjkerAyat();
    fetchAjkerSalafQuote();
    fetchUsers();
    plannerController.fetchCurrentUserPoints();
    total_points = plannerController.totalPoints.value;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      AppBar(
        title: Obx(() => plannerController.isLoadingUsers.value
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                "রমাদ্বন ট্রাকার [${plannerController.totalPoints.value} pts]",
                style: TextStyle(fontSize: 16, color: Colors.white))),
        backgroundColor: AppColors.PrimaryColor, // Change to your primary color
        centerTitle: true,
        leadingWidth: 105,
        leading: Center(
          child: Container(
              padding: EdgeInsets.only(left: 0),
              // width: 800,
              child: Text(
                "Rank:${plannerController.userRank.value}",
                style: TextStyle(fontSize: 16, color: Colors.white),
              )),
        ),
        actions: <Widget>[
          PopupMenuButton(
            color: Colors.white,
            icon: Icon(
              Icons.more_vert,
              color: Colors
                  .white, // Change the color of the vertical three dots here
            ),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: InkWell(
                    onTap: () async {
// Ensure the LocalStorage is ready before setting items
                      await storage.ready;

                      storage.setItem('_id', null);
                      storage.setItem('userName', null);
                      storage.setItem('fullName', null);

                      // Redirect to login page
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                    },
                    child: Column(
                      children: [
                        Text(storage.getItem('userName')),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(children: [
//asset image  full width of the screen
            // Container(
            //   width: MediaQuery.of(context).size.width * .93,
            //   height: 250,
            //   child: Image.asset(
            //     'images/ramadan.jpg',
            //     fit: BoxFit.contain,
            //   ),
            // ),

            Container(
              // width: MediaQuery.of(context).size.width * .53,
              // height: 250, width: 150,
              child: Column(
                children: [
                  //Leader board
                  SingleChildScrollView(
                    child: ExpansionTile(
                      collapsedBackgroundColor: Colors.transparent,
                      collapsedIconColor: Colors.white,
                      // backgroundColor: AppColors.PrimaryColor,
                      iconColor: Colors.white,
                      title: Container(
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
                            "লিডারবোর্ড:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      subtitle: Center(
                          child: Text(
                        "কোনো আমাল এই পয়েন্ট দিয়ে সাব্যস্ত করার অধিকার কারোর-ই নেই।জাস্ট নিজের আমাল জাজ করার জন্যই এটি দেওয়া। নিয়ত করবেন সওয়াবের, আল্লাহ্‌ প্রতিদান দিবেন ইনশাআল্লাহ্‌!(লিডারবোর্ড দেখতে ডানপাশের অ্যারো বাটনে ক্লিক করুন)",
                        style: TextStyle(color: AppColors.PrimaryColor),
                      )),
                      trailing: Icon(Icons.arrow_drop_down_circle,
                          color: AppColors.PrimaryColor, size: 30),

                      children: [
                        isLoadingUsers
                            ? SizedBox(
                                height: 40,
                                child: Center(child: SingleChildScrollView()))
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    border: TableBorder.all(
                                        color:
                                            AppColors.PrimaryColor.withOpacity(
                                                .7)),
                                    headingRowColor:
                                        MaterialStateProperty.all<Color>(
                                            Color.fromARGB(255, 34, 124, 112)),
                                    columns: const <DataColumn>[
                                      DataColumn(
                                          label: Text('Rank',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                      DataColumn(
                                          label: Text('Username',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                      DataColumn(
                                          label: Text('Name',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                      DataColumn(
                                          label: Text('Total Points',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                    ],
                                    rows: List<DataRow>.generate(
                                      // users.length,
                                      _showAll
                                          ? users.length
                                          : (_visibleItemCount < users.length
                                              ? _visibleItemCount
                                              : users.length),
                                      (index) {
                                        final user = users[index][
                                            'user']; // Adjust according to your actual structure
                                        bool isCurrentUser = user['userName'] ==
                                            userName; // Determine if this row represents the current user
                                        return DataRow(
                                          cells: [
                                            DataCell(Text('${index + 1}',
                                                style: isCurrentUser
                                                    ? TextStyle(
                                                        color: AppColors.PrimaryColor,
                                                        fontWeight:
                                                            FontWeight.bold)
                                                    : null)),
                                            DataCell(Text(
                                                user['userName'] ?? 'N/A',
                                                style: isCurrentUser
                                                    ? TextStyle(
                                                        color: AppColors.PrimaryColor,
                                                        fontWeight:
                                                            FontWeight.bold)
                                                    : null)),
                                            DataCell(Text(
                                                user['fullName'] ?? 'N/A',
                                                style: isCurrentUser
                                                    ? TextStyle(
                                                        color: AppColors.PrimaryColor,
                                                        fontWeight:
                                                            FontWeight.bold)
                                                    : null)),
                                            DataCell(Text(
                                                '${users[index]['totalPoints']}',
                                                style: isCurrentUser
                                                    ? TextStyle(
                                                        color: AppColors.PrimaryColor,
                                                        fontWeight:
                                                            FontWeight.bold)
                                                    : null)),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                        if (users.length > _visibleItemCount || _showAll)
                          Center(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _showAll = !_showAll;
                                });
                              },
                              child: Text(
                                _showAll ? "Show Less" : "Show More",
                                style: TextStyle(color: AppColors.PrimaryColor),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    // width: 160,
                    child: Card(
                      elevation: 5.2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
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
                                  "নির্বাচিত আয়াত",
                                  style: TextStyle(
                                      // fontStyle: FontStyle.italic,
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            // Divider(
                            //   color: AppColors.PrimaryColor,
                            //   thickness: 1.0,
                            // ),
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
                                    linkColor: AppColors.PrimaryColor,
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // width: 180,
                    child: Card(
                      elevation: 5.2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
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
                                  "নির্বাচিত হাদিস",
                                  style: TextStyle(
                                      // fontStyle: FontStyle.italic,
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            // Divider(
                            //   color: AppColors.PrimaryColor,
                            //   thickness: 1.0,
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
                                    linkColor: AppColors.PrimaryColor,
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // width: 180,
                    child: Card(
                      elevation: 5.2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
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
                                  "সালাফদের বক্তব্য",
                                  style: TextStyle(
                                      // fontStyle: FontStyle.italic,
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            // Divider(
                            //   color: AppColors.PrimaryColor,
                            //   thickness: 1.0,
                            // ),
                            isLoadingSalafQuote
                                ? Center(
                                    child: CircularProgressIndicator(
                                    color: AppColors.PrimaryColor,
                                  ))
                                : ExpandableText(
                                    // todays_szalaf_qoute.toString(),
                                    ajkerSalafQuote.toString(),
                                    expandText: 'show more',
                                    collapseText: 'show less',
                                    maxLines: 4,
                                    linkColor: AppColors.PrimaryColor,
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),

            // Text('Dashboard'),
            // Listtile with Card elevation 5.2 and border radius 10.0
            for (var i = 0; i < ramadanList.length; i++) ...[
              Card(
                elevation: 7.2,
                shape: RoundedRectangleBorder(
                  side: i + 1 <= calculate2023RamdanDate() &&
                          current_month == "Ramadan"
                      ? BorderSide(color: AppColors.PrimaryColor, width: 1)
                      : BorderSide(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  // border radius with cliprrect  and color with ternary operator
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  tileColor: i + 1 > 20 ? Colors.grey[250] : Colors.white,
                  title: i + 1 == calculate2023RamdanDate() &&
                          current_month == "Ramadan"
                      ? Text('রমাদ্বন - ${ramadanList[i]} (আজ) ')
                      : i + 1 > 20
                          ? Text(
                              'রমাদ্বন - ${ramadanList[i]} ',
                              style: TextStyle(
                                  color: AppColors.PrimaryColor,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text('রমাদ্বন - ${ramadanList[i]} '),
                  subtitle: i + 1 > 20
                      ? Text(
                          'রমাদ্বন প্লান করুন',
                          style: TextStyle(
                              color: AppColors.PrimaryColor,
                              fontWeight: FontWeight.bold),
                        )
                      : Text('রমাদ্বন প্লান করুন'),
                  trailing: i + 1 > 20
                      ? i + 1 == 21 ||
                              i + 1 == 23 ||
                              i + 1 == 25 ||
                              i + 1 == 27 ||
                              i + 1 == 29
                          ? Icon(
                              Icons.diamond_rounded,
                              color: AppColors.PrimaryColor,
                            )
                          : Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.PrimaryColor,
                            )
                      : Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RamadanPlanner(ramadan_day: i + 1)),
                    );
                  },
                ),
              ),
            ],
            Credit(),
          ]),
        ),
      ),
    );
  }
}
