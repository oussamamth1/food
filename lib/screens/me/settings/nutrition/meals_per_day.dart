import 'dart:async';

import 'package:fitfood/models/profile.dart';
import 'package:fitfood/repo/user_repo.dart';
import 'package:fitfood/services/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MealsPerDay extends StatefulWidget {
  final bool? inSettings;
  final Function(int) callback;
  const MealsPerDay({this.inSettings, required this.callback, Key? key})
      : super(key: key);

  @override
  State<MealsPerDay> createState() => _MealsPerDayState();
}

class _MealsPerDayState extends State<MealsPerDay> {
  int meals = 2;
  Profile profile = Profile();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 10), () async {
      var pr = await preferences.getUser();
      if (pr != null) {
        setState(() {
          profile = pr;
          meals = pr.mealsPerDay!;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context)!.meals_per_day,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: RadioListTile(
                            activeColor: Colors.green,
                            title:
                                Text(AppLocalizations.of(context)!.two_times),
                            subtitle: Text(AppLocalizations.of(context)!
                                .breakfast_dinner_2_snacks),
                            value: 2,
                            groupValue: meals,
                            onChanged: (value) {
                              setState(() {
                                meals = 2;
                                profile.mealsPerDay = 2;
                              });
                            },
                          )),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: RadioListTile(
                            activeColor: Colors.green,
                            title:
                                Text(AppLocalizations.of(context)!.three_times),
                            subtitle: Text(AppLocalizations.of(context)!
                                .breakfast_lunch_dinner),
                            value: 3,
                            groupValue: meals,
                            onChanged: (value) {
                              setState(() {
                                meals = 3;
                                profile.mealsPerDay = 3;
                              });
                            },
                          )),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: RadioListTile(
                            activeColor: Colors.green,
                            title:
                                Text(AppLocalizations.of(context)!.four_times),
                            subtitle: Text(AppLocalizations.of(context)!
                                .breakfast_snack_lunch_dinner),
                            value: 4,
                            groupValue: meals,
                            onChanged: (value) {
                              setState(() {
                                meals = 4;
                                profile.mealsPerDay = 4;
                              });
                            },
                          )),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: RadioListTile(
                            activeColor: Colors.green,
                            title:
                                Text(AppLocalizations.of(context)!.five_times),
                            subtitle: Text(AppLocalizations.of(context)!
                                .breakfast_lunch_dinner_2_snacks),
                            value: 5,
                            groupValue: meals,
                            onChanged: (value) {
                              setState(() {
                                meals = 5;
                                profile.mealsPerDay = 5;
                              });
                            },
                          )),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          color: Colors.white,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green, // background
              onPrimary: Colors.white, // foreground
              onSurface: Colors.green,
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () async {
              // Save locale language
              await preferences.setUser(profile);
              await userRop.updateUserById(profile.uid!, profile);
              widget.callback(meals);
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.save,
              style: const TextStyle(fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}
