import 'dart:async';

import 'package:fitfood/models/profile.dart';
import 'package:fitfood/repo/user_repo.dart';
import 'package:fitfood/services/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Units extends StatefulWidget {
  final bool? inSettings;
  final Function(String) callback;
  const Units({this.inSettings, required this.callback, Key? key})
      : super(key: key);

  @override
  State<Units> createState() => _UnitsState();
}

class _UnitsState extends State<Units> {
  String units = "Metric";
  Profile profile = Profile();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 10), () async {
      var pr = await preferences.getUser();
      if (pr != null) {
        setState(() {
          profile = pr;
          units = pr.units!;
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
            AppLocalizations.of(context)!.units,
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
                            title: Text(AppLocalizations.of(context)!.metric),
                            value: 'Metric',
                            groupValue: units,
                            onChanged: (value) {
                              setState(() {
                                units = "Metric";
                                profile.units = "Metric";
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
                            title: Text(AppLocalizations.of(context)!.imperial),
                            value: 'Imperial',
                            groupValue: units,
                            onChanged: (value) {
                              setState(() {
                                units = "Imperial";
                                profile.units = "Imperial";
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
              widget.callback(units);
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
