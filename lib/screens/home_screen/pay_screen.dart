import 'dart:async';

import 'package:fitfood/models/profile.dart';
import 'package:fitfood/services/preferences.dart';
import 'package:fitfood/style.dart';
import 'package:flutter/material.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({Key? key}) : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  Profile profile = Profile();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 10), () async {
      Profile? pr = await preferences.getUser();
      if (pr != null) {
        setState(() {
          profile = pr;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    var objective = profile.objective == 0
        ? "loss"
        : profile.objective == 1
            ? "gain"
            : "maintain";
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey.shade200,
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowIndicator();
            return true;
          },
          child: ListView(
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            children: [
              Container(
                width: width - 40,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  image: const DecorationImage(
                      image: AssetImage('assets/images/pay.jpg'),
                      fit: BoxFit.cover),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
              Text("Personalized meal plan",
                  style: styleTitle17, textAlign: TextAlign.center),
              Text("Based on your parameters",
                  style: styleTitle16, textAlign: TextAlign.center),
              const SizedBox(height: 30),
              Text("Get you personalized weight $objective kit",
                  style: styleTitle176, textAlign: TextAlign.center),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background
                    onPrimary: Colors.white, // foreground
                    onSurface: Colors.green,
                    minimumSize: const Size.fromHeight(60),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              Text("Get a Meal Plan for \$7 per month",
                  style: styleNormal, textAlign: TextAlign.center),
              Text("Cancel any time",
                  style: styleButton4, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
