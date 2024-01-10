import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitfood/services/preferences.dart';
import 'package:fitfood/services/authentication.dart';
//import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  SplashScreenstate createState() => SplashScreenstate();
}

class SplashScreenstate extends State<SplashScreen> {
  //StreamSubscription? internetconnection;
  //bool isoffline = true;
  GlobalKey<ScaffoldState> scaffoldKeyMain = GlobalKey();
  late Duration twenty;
  late Timer t2;
  FirebaseAuths userAuth = FirebaseAuths();
  List<Color> splashscreenColors = [
    const Color(0xFF97bfbf),
    const Color(0xFF97bfbf),
    const Color(0xFF97bfbf),
    const Color(0xFFda574a),
    const Color(0xFFfaaf40),
    const Color.fromARGB(255, 170, 241, 232)
  ];
  List<String> splashscreenImages = [
    'avocat.gif',
    'banana.gif',
    'broccoli.gif',
    'dairy.gif',
    'meals.gif',
    'plat.gif'
  ];

  @override
  void initState() {
    super.initState();
    // internetconnection = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) {
    //   // whenevery connection status is changed.
    //   if (result == ConnectivityResult.none) {
    //     //there is no any connection
    //     setState(() {
    //       isoffline = true;
    //     });
    //   } else if (result == ConnectivityResult.mobile) {
    //     //connection is mobile data network
    //     setState(() {
    //       isoffline = false;
    //     });
    //   } else if (result == ConnectivityResult.wifi) {
    //     //connection is from wifi
    //     setState(() {
    //       isoffline = false;
    //     });
    //   } else if (result == ConnectivityResult.ethernet) {
    //     //connection is from wifi
    //     setState(() {
    //       isoffline = false;
    //     });
    //   }
    // });
    twenty = const Duration(seconds: 5);
    preferences.setBoolValue("refresh-home", true);
    preferences.setStringValue('token', '');
    t2 = Timer(twenty, () async {
      var user = await userAuth.currentUserObject();
      bool keeplogin = await preferences.getBoolValue('keeplogin');
      var uid = await preferences.getStringValue('uid');
      bool language = await preferences.ifExist('language');
      if (!language) {
        if (kDebugMode) {
          print("0");
        }
        Navigator.pushReplacementNamed(context, '/language');
      } else if (user == null && uid == null) {
        //Pas de user existant
        if (kDebugMode) {
          print("1");
        }
        Navigator.pushReplacementNamed(context, '/login');
      } else if (user == null) {
        //Pas de user existant
        if (kDebugMode) {
          print("2");
        }
        Navigator.pushReplacementNamed(context, '/login');
      } else if (keeplogin == true && uid != null) {
        //User
        var userElastic = await userAuth.getCurrentUser();
        if (userElastic == null) {
          if (kDebugMode) {
            print("3");
          }
          Navigator.pushReplacementNamed(context, '/login');
          /*} else if (userElastic.pay == false &&
            DateTime.now().millisecondsSinceEpoch >
                userElastic.dateEnd!.toInt()) {
          if (kDebugMode) {
            print("4");
          }
          await preferences.setUser(userElastic);
          Navigator.pushReplacementNamed(context, '/pay');*/
        } else {
          if (kDebugMode) {
            print("5");
          }
          await preferences.setUser(userElastic);
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        if (kDebugMode) {
          print("6");
          print(user);
          print(keeplogin);
          print(uid);
        }
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    //internetconnection!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    int index = Random().nextInt(6);
    return Scaffold(
      key: scaffoldKeyMain,
      body: Container(
        color: splashscreenColors[index],
        child: Align(
            alignment: Alignment.center,
            child: Image(
                width: 150,
                fit: BoxFit.scaleDown,
                image: AssetImage(
                    'assets/images/splashscreen/${splashscreenImages[index]}'))),
      ),
    );
  }
}
