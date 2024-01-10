import 'dart:async';

import 'package:fitfood/models/notifications.dart';
import 'package:fitfood/models/profile.dart';
import 'package:fitfood/repo/notification_repo.dart';
import 'package:fitfood/services/notification.dart';
import 'package:fitfood/services/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SetUpNotification extends StatefulWidget {
  const SetUpNotification({Key? key}) : super(key: key);

  @override
  State<SetUpNotification> createState() => _SetUpNotificationState();
}

class _SetUpNotificationState extends State<SetUpNotification> {
  bool _breakfast = false;
  bool _firstSnack = false;
  bool _lunch = false;
  bool _dinner = false;
  bool _secondSnack = false;
  bool _water = false;
  TimeOfDay _breakfastTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _firstSnackTime = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay _lunchTime = const TimeOfDay(hour: 12, minute: 30);
  TimeOfDay _dinnerTime = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay _secondSnackTime = const TimeOfDay(hour: 14, minute: 0);
  Notifications notification = Notifications(mealTime: MealTime());
  late String uid;
  Profile profile = Profile();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 10), () async {
      uid = (await preferences.getStringValue('uid'))!;
      Profile? pr = await preferences.getUser();
      if (pr != null) {
        setState(() {
          profile = pr;
        });
      }
      Notifications? notif = await notificationRepo.getById(uid);
      if (notif != null) {
        setState(() {
          notification = notif;
          if (notif.mealTime?.breakfast == true) _breakfast = true;
          if (notif.mealTime?.dinner == true) _dinner = true;
          if (notif.mealTime?.lunch == true) _lunch = true;
          if (notif.mealTime?.firstSnack == true) _firstSnack = true;
          if (notif.mealTime?.secondSnack == true) _secondSnack = true;
          if (notif.water == true) _water = true;
          if (notif.mealTime?.breakfastTime != null) {
            List<String>? time = notif.mealTime?.breakfastTime!.split(':');
            _breakfastTime = TimeOfDay(
                hour: int.parse(time![0]), minute: int.parse(time[1]));
          }
          if (notif.mealTime?.lunchTime != null) {
            List<String>? time = notif.mealTime?.lunchTime!.split(':');
            _lunchTime = TimeOfDay(
                hour: int.parse(time![0]), minute: int.parse(time[1]));
          }
          if (notif.mealTime?.dinnerTime != null) {
            List<String>? time = notif.mealTime?.dinnerTime!.split(':');
            _dinnerTime = TimeOfDay(
                hour: int.parse(time![0]), minute: int.parse(time[1]));
          }
          if (notif.mealTime?.firstSnackTime != null) {
            List<String>? time = notif.mealTime?.firstSnackTime!.split(':');
            _firstSnackTime = TimeOfDay(
                hour: int.parse(time![0]), minute: int.parse(time[1]));
          }
          if (notif.mealTime?.secondSnackTime != null) {
            List<String>? time = notif.mealTime?.secondSnackTime!.split(':');
            _secondSnackTime = TimeOfDay(
                hour: int.parse(time![0]), minute: int.parse(time[1]));
          }
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
    return WillPopScope(
      onWillPop: () async {
        //notification.uid = uid;
        //await notificationRepo.createNotification(notification);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context)!.meals,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowIndicator();
            return true;
          },
          child: ListView(children: [
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  border: Border.all(
                    color: Colors.green.shade100,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                title: Text(AppLocalizations.of(context)!.recommended_mealtime),
                leading: const Icon(
                  CupertinoIcons.info,
                  size: 40,
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: SwitchListTile(
                activeColor: Colors.green,
                title: Text(AppLocalizations.of(context)!.breakfast),
                secondary: const Icon(Icons.free_breakfast_rounded),
                value: _breakfast,
                onChanged: (bool value) {
                  setState(() {
                    _breakfast = value;
                    notification.mealTime!.breakfast = value;
                  });
                },
              ),
            ),
            Visibility(
              visible: _breakfast,
              child: Container(
                margin: const EdgeInsets.only(top: 3),
                color: Colors.white,
                child: ListTile(
                  title: Text(AppLocalizations.of(context)!.time),
                  leading: const Icon(Icons.alarm),
                  trailing: TextButton(
                    onPressed: () {
                      _selectTime(context, _breakfastTime, "_breakfastTime");
                    },
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text("${_breakfastTime.hour}:${_breakfastTime.minute}",
                            style: const TextStyle(color: Colors.green)),
                        const Text(' '),
                        const Icon(Icons.arrow_forward_ios,
                            size: 13, color: Colors.green)
                      ],
                    ),
                  ),
                  onTap: () {
                    _selectTime(context, _breakfastTime, "_breakfastTime");
                  },
                ),
              ),
            ),
            if (profile.mealsPerDay != 3)
              Container(
                margin: const EdgeInsets.only(top: 15),
                color: Colors.white,
                child: SwitchListTile(
                  activeColor: Colors.green,
                  title: Text(AppLocalizations.of(context)!.first_snack),
                  secondary: const Icon(Icons.breakfast_dining),
                  value: _firstSnack,
                  onChanged: (bool value) {
                    setState(() {
                      _firstSnack = value;
                      notification.mealTime!.firstSnack = value;
                    });
                  },
                ),
              ),
            if (profile.mealsPerDay != 3)
              Visibility(
                visible: _firstSnack,
                child: Container(
                  margin: const EdgeInsets.only(top: 3),
                  color: Colors.white,
                  child: ListTile(
                    title: Text(AppLocalizations.of(context)!.time),
                    leading: const Icon(Icons.alarm),
                    trailing: TextButton(
                      onPressed: () {
                        _selectTime(
                            context, _firstSnackTime, "_firstSnackTime");
                      },
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                              "${_firstSnackTime.hour}:${_firstSnackTime.minute}",
                              style: const TextStyle(color: Colors.green)),
                          const Text(' '),
                          const Icon(Icons.arrow_forward_ios,
                              size: 13, color: Colors.green)
                        ],
                      ),
                    ),
                    onTap: () {
                      _selectTime(context, _firstSnackTime, "_firstSnackTime");
                    },
                  ),
                ),
              ),
            if (profile.mealsPerDay != 2)
              Container(
                margin: const EdgeInsets.only(top: 15),
                color: Colors.white,
                child: SwitchListTile(
                  activeColor: Colors.green,
                  title: Text(AppLocalizations.of(context)!.lunch),
                  secondary: const Icon(Icons.lunch_dining),
                  value: _lunch,
                  onChanged: (bool value) {
                    setState(() {
                      _lunch = value;
                      notification.mealTime!.lunch = value;
                    });
                  },
                ),
              ),
            if (profile.mealsPerDay != 2)
              Visibility(
                visible: _lunch,
                child: Container(
                  margin: const EdgeInsets.only(top: 3),
                  color: Colors.white,
                  child: ListTile(
                    title: Text(AppLocalizations.of(context)!.time),
                    leading: const Icon(Icons.alarm),
                    trailing: TextButton(
                      onPressed: () {
                        _selectTime(context, _lunchTime, "_lunchTime");
                      },
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text("${_lunchTime.hour}:${_lunchTime.minute}",
                              style: const TextStyle(color: Colors.green)),
                          const Text(' '),
                          const Icon(Icons.arrow_forward_ios,
                              size: 13, color: Colors.green)
                        ],
                      ),
                    ),
                    onTap: () {
                      _selectTime(context, _lunchTime, "_lunchTime");
                    },
                  ),
                ),
              ),
            if (profile.mealsPerDay != 3 && profile.mealsPerDay != 4)
              Container(
                margin: const EdgeInsets.only(top: 15),
                color: Colors.white,
                child: SwitchListTile(
                  activeColor: Colors.green,
                  title: Text(AppLocalizations.of(context)!.second_snack),
                  secondary: const Icon(Icons.coffee),
                  value: _secondSnack,
                  onChanged: (bool value) {
                    setState(() {
                      _secondSnack = value;
                      notification.mealTime!.secondSnack = value;
                    });
                  },
                ),
              ),
            if (profile.mealsPerDay != 3 && profile.mealsPerDay != 4)
              Visibility(
                visible: _secondSnack,
                child: Container(
                  margin: const EdgeInsets.only(top: 3),
                  color: Colors.white,
                  child: ListTile(
                    title: Text(AppLocalizations.of(context)!.time),
                    leading: const Icon(Icons.alarm),
                    trailing: TextButton(
                      onPressed: () {
                        _selectTime(
                            context, _secondSnackTime, "_secondSnackTime");
                      },
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                              "${_secondSnackTime.hour}:${_secondSnackTime.minute}",
                              style: const TextStyle(color: Colors.green)),
                          const Text(' '),
                          const Icon(Icons.arrow_forward_ios,
                              size: 13, color: Colors.green)
                        ],
                      ),
                    ),
                    onTap: () {
                      _selectTime(
                          context, _secondSnackTime, "_secondSnackTime");
                    },
                  ),
                ),
              ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              color: Colors.white,
              child: SwitchListTile(
                activeColor: Colors.green,
                title: Text(AppLocalizations.of(context)!.dinner),
                secondary: const Icon(Icons.dinner_dining_rounded),
                value: _dinner,
                onChanged: (bool value) {
                  setState(() {
                    _dinner = value;
                    notification.mealTime!.dinner = value;
                  });
                },
              ),
            ),
            Visibility(
              visible: _dinner,
              child: Container(
                margin: const EdgeInsets.only(top: 3),
                color: Colors.white,
                child: ListTile(
                  title: Text(AppLocalizations.of(context)!.time),
                  leading: const Icon(Icons.alarm),
                  trailing: TextButton(
                    onPressed: () {
                      _selectTime(context, _dinnerTime, "_dinnerTime");
                    },
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text("${_dinnerTime.hour}:${_dinnerTime.minute}",
                            style: const TextStyle(color: Colors.green)),
                        const Text(' '),
                        const Icon(Icons.arrow_forward_ios,
                            size: 13, color: Colors.green)
                      ],
                    ),
                  ),
                  onTap: () {
                    _selectTime(context, _dinnerTime, "_dinnerTime");
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              color: Colors.white,
              child: SwitchListTile(
                activeColor: Colors.green,
                title: Text(AppLocalizations.of(context)!.water),
                secondary: const Icon(Icons.water),
                value: _water,
                onChanged: (bool value) {
                  setState(() {
                    _water = value;
                    notification.water = value;
                  });
                },
              ),
            ),
          ]),
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
              notification.uid = uid;
              notificationRepo.createNotification(notification);
              await flutterLocalNotificationsPlugin.cancelAll();
              //int munitesoffset = DateTime.now().timeZoneOffset.inMinutes;
              if (notification.mealTime!.breakfast == true) {
                int munites = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        int.parse(notification.mealTime!.breakfastTime!
                            .split(':')[0]),
                        int.parse(notification.mealTime!.breakfastTime!
                            .split(':')[1]))
                    .difference(DateTime.now())
                    .inMinutes;
                if (munites < 0) {
                  munites = munites + 1440;
                }
                sendNotification(
                    id: 0,
                    title: AppLocalizations.of(context)!.enjoy_your_breakfast,
                    body:
                        AppLocalizations.of(context)!.click_here_and_see,
                    duration: Duration(minutes: munites+1));
              }
              if (notification.mealTime!.lunch == true) {
                int munites = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        int.parse(
                            notification.mealTime!.lunchTime!.split(':')[0]),
                        int.parse(
                            notification.mealTime!.lunchTime!.split(':')[1]))
                    .difference(DateTime.now())
                    .inMinutes;
                if (munites < 0) {
                  munites = munites + 1440;
                }
                sendNotification(
                    id: 1,
                    title: AppLocalizations.of(context)!.enjoy_your_lunch,
                    body:
                        AppLocalizations.of(context)!.click_here_and_see,
                    duration: Duration(minutes: munites+1));
              }
              if (notification.mealTime!.dinner == true) {
                int munites = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        int.parse(
                            notification.mealTime!.dinnerTime!.split(':')[0]),
                        int.parse(
                            notification.mealTime!.dinnerTime!.split(':')[1]))
                    .difference(DateTime.now())
                    .inMinutes;
                if (munites < 0) {
                  munites = munites + 1440;
                }
                sendNotification(
                    id: 2,
                    title: AppLocalizations.of(context)!.enjoy_your_dinner,
                    body:
                        AppLocalizations.of(context)!.click_here_and_see,
                    duration: Duration(minutes: munites+1));
              }
              if (notification.mealTime!.firstSnack == true) {
                int munites = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        int.parse(notification.mealTime!.firstSnackTime!
                            .split(':')[0]),
                        int.parse(notification.mealTime!.firstSnackTime!
                            .split(':')[1]))
                    .difference(DateTime.now())
                    .inMinutes;
                if (munites < 0) {
                  munites = munites + 1440;
                }
                sendNotification(
                    id: 3,
                    title: AppLocalizations.of(context)!.first_snack_time,
                    body:
                        AppLocalizations.of(context)!.time_to_open_your_meal_plan,
                    duration: Duration(minutes: munites+1));
              }
              if (notification.mealTime!.secondSnack == true) {
                int munites = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        int.parse(notification.mealTime!.secondSnackTime!
                            .split(':')[0]),
                        int.parse(notification.mealTime!.secondSnackTime!
                            .split(':')[1]))
                    .difference(DateTime.now())
                    .inMinutes;
                if (munites < 0) {
                  munites = munites + 1440;
                }
                sendNotification(
                    id: 4,
                    title: AppLocalizations.of(context)!.second_snack_time,
                    body:
                        AppLocalizations.of(context)!.time_to_open_your_meal_plan,
                    duration: Duration(minutes: munites+1));
              }
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

  _selectTime(
      BuildContext context, TimeOfDay selectedTime, String timeType) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        switch (timeType) {
          case "_breakfastTime":
            _breakfastTime = timeOfDay;
            notification.mealTime!.breakfastTime =
                timeOfDay.toString().substring(10, 15);
            break;
          case "_firstSnackTime":
            _firstSnackTime = timeOfDay;
            notification.mealTime!.firstSnackTime =
                timeOfDay.toString().substring(10, 15);
            break;
          case "_lunchTime":
            _lunchTime = timeOfDay;
            notification.mealTime!.lunchTime =
                timeOfDay.toString().substring(10, 15);
            break;
          case "_dinnerTime":
            _dinnerTime = timeOfDay;
            notification.mealTime!.dinnerTime =
                timeOfDay.toString().substring(10, 15);
            break;
          case "_secondSnackTime":
            _secondSnackTime = timeOfDay;
            notification.mealTime!.secondSnackTime =
                timeOfDay.toString().substring(10, 15);
            break;
        }
      });
    }
  }
}
