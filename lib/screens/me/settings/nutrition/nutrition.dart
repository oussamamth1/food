import 'dart:async';
import 'package:fitfood/models/profile.dart';
import 'package:fitfood/screens/me/settings/nutrition/meals_per_day.dart';
import 'package:fitfood/services/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Nutrition extends StatefulWidget {
  const Nutrition({Key? key}) : super(key: key);

  @override
  State<Nutrition> createState() => _NutritionState();
}

class _NutritionState extends State<Nutrition> {
  Profile profile = Profile();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 10), () async {
      var pr = await preferences.getUser();
      if (pr != null) {
        setState(() {
          profile = pr;
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
            AppLocalizations.of(context)!.nutrition,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowIndicator();
            return true;
          },
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15),
                color: Colors.white,
                child: ListTile(
                    minLeadingWidth: 10,
                    title: Text(AppLocalizations.of(context)!.meals_per_day),
                    leading: const Icon(Icons.set_meal_sharp),
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text("${profile.mealsPerDay} "+AppLocalizations.of(context)!.times,
                            style: TextStyle(color: Colors.grey.shade600)),
                        const Text('  '),
                        const Icon(Icons.arrow_forward_ios, size: 15)
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MealsPerDay(callback: (meals) {
                              setState(() {
                                profile.mealsPerDay = meals;
                              });
                            }),
                          ));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
