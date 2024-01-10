import 'dart:async';
import 'package:fitfood/models/profile.dart';
import 'package:fitfood/services/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({Key? key}) : super(key: key);

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
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
            AppLocalizations.of(context)!.personal_details,
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
                  title: Text(AppLocalizations.of(context)!.age),
                  trailing: Text("${profile.age}",
                      style: TextStyle(color: Colors.grey.shade600)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                color: Colors.white,
                child: ListTile(
                  title: Text(AppLocalizations.of(context)!.starting_weight),
                  trailing: Text("${profile.startingWeight} kg",
                      style: TextStyle(color: Colors.grey.shade600)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                color: Colors.white,
                child: ListTile(
                  title: Text(AppLocalizations.of(context)!.target_weight),
                  trailing: Text("${profile.desiredWeight} kg",
                      style: TextStyle(color: Colors.grey.shade600)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                color: Colors.white,
                child: ListTile(
                  title: Text(AppLocalizations.of(context)!.current_weight),
                  trailing: Text("${profile.currentWeight} kg",
                      style: TextStyle(color: Colors.grey.shade600)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                color: Colors.white,
                child: ListTile(
                  title: Text(AppLocalizations.of(context)!.height),
                  trailing: Text("${profile.height} cm",
                      style: TextStyle(color: Colors.grey.shade600)),
                ),
              ),
              if (profile.allergies != null && profile.allergies!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.restrictions+":"),
                      ),
                      ...profile.allergies!.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 16.0, left: 16, bottom: 5),
                          child: Text("$item",
                              style: TextStyle(color: Colors.grey.shade600)),
                        );
                      }),
                    ],
                  ),
                ),
              if (profile.noMeats != null && profile.noMeats!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.no_meats_products+":"),
                      ),
                      ...profile.noMeats!.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 16.0, left: 16, bottom: 5),
                          child: Text("$item",
                              style: TextStyle(color: Colors.grey.shade600)),
                        );
                      }),
                    ],
                  ),
                ),
              if (profile.noDairys != null && profile.noDairys!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.no_dairys_products+":"),
                      ),
                      ...profile.noDairys!.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 16.0, left: 16, bottom: 5),
                          child: Text("$item",
                              style: TextStyle(color: Colors.grey.shade600)),
                        );
                      }),
                    ],
                  ),
                ),
              if (profile.noCereals != null && profile.noCereals!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.no_cereals_products+":"),
                      ),
                      ...profile.noCereals!.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 16.0, left: 16, bottom: 5),
                          child: Text("$item",
                              style: TextStyle(color: Colors.grey.shade600)),
                        );
                      }),
                    ],
                  ),
                ),
              if (profile.noFruits != null && profile.noFruits!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.no_fruits_products+":"),
                      ),
                      ...profile.noFruits!.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 16.0, left: 16, bottom: 5),
                          child: Text("$item",
                              style: TextStyle(color: Colors.grey.shade600)),
                        );
                      }),
                    ],
                  ),
                ),
              if (profile.noVegetables != null &&
                  profile.noVegetables!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.no_vegetables_products+":"),
                      ),
                      ...profile.noVegetables!.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 16.0, left: 16, bottom: 5),
                          child: Text("$item",
                              style: TextStyle(color: Colors.grey.shade600)),
                        );
                      }),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
