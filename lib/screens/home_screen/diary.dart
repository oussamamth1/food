import 'dart:async';

import 'package:fitfood/models/diet.dart';
import 'package:fitfood/models/notifications.dart';
import 'package:fitfood/models/profile.dart';
import 'package:fitfood/models/weight.dart';
import 'package:fitfood/repo/diet_repo.dart';
import 'package:fitfood/repo/notification_repo.dart';
import 'package:fitfood/repo/user_repo.dart';
import 'package:fitfood/repo/weight_repo.dart';
import 'package:fitfood/screens/home_screen/add%20meal/add_meal.dart';
import 'package:fitfood/screens/me/settings/notification/notification_banner.dart';
import 'package:fitfood/services/preferences.dart';
import 'package:fitfood/services/validations.dart';
import 'package:fitfood/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Diary extends StatefulWidget {
  const Diary({Key? key}) : super(key: key);

  @override
  State<Diary> createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  Notifications notification = Notifications(mealTime: MealTime());
  Diet currentDiet = Diet(
      dailyCalory: 0,
      dailyCarbs: 0,
      dailyFat: 0,
      dailyProtein: 0,
      day: "0",
      uid: "0");
  late String uid;
  Profile profile = Profile(water: 2.75);
  DateTime today = validations.convertDateTimeToDate(DateTime.now());
  DateTime todayDate = validations.convertDateTimeToDate(DateTime.now());
  double caloryProccess = 0;
  double proteinProccess = 0;
  double carbsProccess = 0;
  double fatProccess = 0;
  int objectifWeight = 0;
  late TextEditingController controllerCurrentWeight;
  late TextEditingController controllerDate;
  final _formKey = GlobalKey<FormState>();
  List<WaterIntake> waterintake = <WaterIntake>[];
  Weight? recordedWeight;

  @override
  void initState() {
    super.initState();
    controllerCurrentWeight = TextEditingController();
    controllerDate = TextEditingController();
    controllerDate.text = today.toString().split(' ')[0];
    Timer(const Duration(milliseconds: 10), () async {
      uid = (await preferences.getStringValue('uid'))!;
      Notifications? notif = await notificationRepo.getById(uid);
      Profile? pr = await preferences.getUser();
      if (notif != null) {
        setState(() {
          notification = notif;
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const NotificationBanner(),
          ),
        );
      }
      if (pr != null) {
        if (pr.idealCalory == null) {
          Profile? newprofile = await userRop.getIdeals(pr);
          if (newprofile != null) {
            preferences.setUser(newprofile);
            setState(() {
              profile = newprofile;
            });
          }
        } else {
          setState(() {
            profile = pr;
          });
        }
        setState(() {
          currentDiet = Diet(
              dailyCalory: profile.idealCalory,
              dailyCarbs: profile.idealCarbohydrate,
              dailyFat: profile.idealFat,
              dailyProtein: profile.idealProtein,
              day: today.toString().split(' ')[0],
              uid: profile.uid);
          objectifWeight = profile.currentWeight! - profile.startingWeight!;
        });
      }
      Diet? diet = await dietRepo.getByDay(today.toString().split(' ')[0]);
      if (diet != null) {
        setState(() {
          currentDiet = diet;
          refreshProccess(diet);
        });
      }
      int drinked = (currentDiet.water / 0.25).round() - 1;
      List<WaterIntake> waterintakee = List.generate(
          (profile.water! / 0.25).round(),
          (index) => WaterIntake(
              index: index, drinked: index <= drinked ? true : false));
      setState(() {
        waterintake = waterintakee;
      });
      Weight? recordedWeightt = await weightRepo.getWeightByUidDate(
          profile.uid!, today.toString().split(' ')[0]);
      if (recordedWeightt != null) {
        setState(() {
          recordedWeight = recordedWeightt;
          objectifWeight = recordedWeightt.weight! - profile.startingWeight!;
        });
      }
    });
  }

  @override
  void dispose() {
    controllerCurrentWeight.dispose();
    controllerDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          bottom: PreferredSize(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon:
                          const Icon(CupertinoIcons.arrowtriangle_left_circle),
                      onPressed: () async {
                        setState(() {
                          today = today.add(const Duration(days: -1));
                        });
                        Diet? diet = await dietRepo
                            .getByDay(today.toString().split(' ')[0]);
                        setState(() {
                          currentDiet = diet ??
                              Diet(
                                  dailyCalory: profile.idealCalory,
                                  dailyCarbs: profile.idealCarbohydrate,
                                  dailyFat: profile.idealFat,
                                  dailyProtein: profile.idealProtein,
                                  day: today.toString().split(' ')[0],
                                  uid: profile.uid);
                          controllerDate.text = today.toString().split(' ')[0];
                        });
                        int drinked = (currentDiet.water / 0.25).round() - 1;
                        List<WaterIntake> waterintakee = List.generate(
                            (profile.water! / 0.25).round(),
                            (index) => WaterIntake(
                                index: index,
                                drinked: index <= drinked ? true : false));
                        setState(() {
                          waterintake = waterintakee;
                        });
                        refreshProccess(currentDiet);
                      }),
                  InkWell(
                    onTap: () async {
                      DateTime? day = await showDatePicker(
                          errorInvalidText: AppLocalizations.of(context)!.date_out_of_range,
                          context: context,
                          initialDate: today,
                          firstDate: today.add(const Duration(days: -30)),
                          lastDate: today.add(const Duration(days: 30)));
                      if (day != null) {
                        Diet? diet = await dietRepo
                            .getByDay(day.toString().split(' ')[0]);
                        Profile? pr = await preferences.getUser();
                        setState(() {
                          today = day;
                          currentDiet = diet ??
                              Diet(
                                  dailyCalory: profile.idealCalory,
                                  dailyCarbs: profile.idealCarbohydrate,
                                  dailyFat: profile.idealFat,
                                  dailyProtein: profile.idealProtein,
                                  day: today.toString().split(' ')[0],
                                  uid: profile.uid);
                          if (pr != null) {
                            profile = pr;
                          }
                        });
                        int drinked = (currentDiet.water / 0.25).round() - 1;
                        List<WaterIntake> waterintakee = List.generate(
                            (profile.water! / 0.25).round(),
                            (index) => WaterIntake(
                                index: index,
                                drinked: index <= drinked ? true : false));
                        setState(() {
                          waterintake = waterintakee;
                        });
                        Weight? recordedWeightt =
                            await weightRepo.getWeightByUidDate(
                                profile.uid!, today.toString().split(' ')[0]);
                        setState(() {
                          recordedWeight = recordedWeightt;
                          if (recordedWeightt != null) {
                            objectifWeight = recordedWeightt.weight! -
                                profile.startingWeight!;
                          }
                        });
                        refreshProccess(currentDiet);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today, size: 20),
                        Text(today == todayDate
                            ? " " + AppLocalizations.of(context)!.today
                            : today == todayDate.add(const Duration(days: -1))
                                ? " " + AppLocalizations.of(context)!.yesterday
                                : today ==
                                        todayDate.add(const Duration(days: 1))
                                    ? " " +
                                        AppLocalizations.of(context)!.tomorrow
                                    : " ${DateFormat("EEEE").format(today)}, ${DateFormat("d MMMM").format(today)}"),
                      ],
                    ),
                  ),
                  IconButton(
                      icon:
                          const Icon(CupertinoIcons.arrowtriangle_right_circle),
                      onPressed: () async {
                        setState(() {
                          today = today.add(const Duration(days: 1));
                        });
                        Diet? diet = await dietRepo
                            .getByDay(today.toString().split(' ')[0]);
                        setState(() {
                          currentDiet = diet ??
                              Diet(
                                  dailyCalory: profile.idealCalory,
                                  dailyCarbs: profile.idealCarbohydrate,
                                  dailyFat: profile.idealFat,
                                  dailyProtein: profile.idealProtein,
                                  day: today.toString().split(' ')[0],
                                  uid: profile.uid);
                          controllerDate.text = today.toString().split(' ')[0];
                        });
                        int drinked = (currentDiet.water / 0.25).round() - 1;
                        List<WaterIntake> waterintakee = List.generate(
                            (profile.water! / 0.25).round(),
                            (index) => WaterIntake(
                                index: index,
                                drinked: index <= drinked ? true : false));
                        setState(() {
                          waterintake = waterintakee;
                        });
                        Weight? recordedWeightt =
                            await weightRepo.getWeightByUidDate(
                                profile.uid!, today.toString().split(' ')[0]);
                        setState(() {
                          recordedWeight = recordedWeightt;
                          if (recordedWeightt != null) {
                            objectifWeight = recordedWeightt.weight! -
                                profile.startingWeight!;
                          }
                        });
                        refreshProccess(currentDiet);
                      }),
                ],
              ),
              preferredSize: const Size.fromHeight(50)),
          actions: [
            IconButton(
                padding: const EdgeInsets.only(right: 10),
                onPressed: () {},
                icon: const Icon(Icons.chat))
          ],
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.grey.shade200,
          title: Text(AppLocalizations.of(context)!.diary, style: styleTitle17),
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowIndicator();
            return true;
          },
          child: RefreshIndicator(
            color: Colors.green,
            onRefresh: () async {
              Diet? diet =
                  await dietRepo.getByDay(today.toString().split(' ')[0]);
              Profile? pr = await preferences.getUser();
              setState(() {
                currentDiet = diet ??
                    Diet(
                        dailyCalory: profile.idealCalory,
                        dailyCarbs: profile.idealCarbohydrate,
                        dailyFat: profile.idealFat,
                        dailyProtein: profile.idealProtein,
                        day: today.toString().split(' ')[0],
                        uid: profile.uid);
                if (pr != null) {
                  profile = pr;
                }
              });
              int drinked = (currentDiet.water / 0.25).round() - 1;
              List<WaterIntake> waterintakee = List.generate(
                  (profile.water! / 0.25).round(),
                  (index) => WaterIntake(
                      index: index, drinked: index <= drinked ? true : false));
              setState(() {
                waterintake = waterintakee;
              });
              Weight? recordedWeightt = await weightRepo.getWeightByUidDate(
                  profile.uid!, today.toString().split(' ')[0]);
              setState(() {
                recordedWeight = recordedWeightt;
                if (recordedWeightt != null) {
                  objectifWeight =
                      recordedWeightt.weight! - profile.startingWeight!;
                }
              });
              refreshProccess(currentDiet);
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      color: mainColor0,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: [
                          _RadialProgress(
                            width: width * 0.35,
                            height: width * 0.35,
                            progress: caloryProccess,
                            calorie: currentDiet.dailyCalory! -
                                currentDiet.caloryEaten,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                                '${currentDiet.caloryEaten.round()} cal ' +
                                    AppLocalizations.of(context)!.eaten,
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _IngredientProgress(
                            ingredient:
                                "Protein: ${currentDiet.proteinEaten.toInt()}g",
                            progress: proteinProccess,
                            progressColor: Colors.yellow.shade600,
                            leftAmount: currentDiet.dailyProtein! -
                                        currentDiet.proteinEaten <
                                    0
                                ? 0
                                : currentDiet.dailyProtein! -
                                    currentDiet.proteinEaten,
                            width: width * 0.35,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _IngredientProgress(
                            ingredient:
                                "Carbs: ${currentDiet.carbsEaten.toInt()}g",
                            progress: carbsProccess,
                            progressColor: Colors.yellow.shade600,
                            leftAmount: currentDiet.dailyCarbs! -
                                        currentDiet.carbsEaten <
                                    0
                                ? 0
                                : currentDiet.dailyCarbs! -
                                    currentDiet.carbsEaten,
                            width: width * 0.35,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _IngredientProgress(
                            ingredient:
                                "Fats: ${currentDiet.fatEaten.toInt()}g",
                            progress: fatProccess,
                            progressColor: Colors.yellow.shade600,
                            leftAmount:
                                currentDiet.dailyFat! - currentDiet.fatEaten < 0
                                    ? 0
                                    : currentDiet.dailyFat! -
                                        currentDiet.fatEaten,
                            width: width * 0.35,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                if (today.millisecondsSinceEpoch <=
                    todayDate.millisecondsSinceEpoch)
                  const SizedBox(height: 30),
                if (today.millisecondsSinceEpoch <=
                    todayDate.millisecondsSinceEpoch)
                  Text(AppLocalizations.of(context)!.weight,
                      style: styleTitle177),
                if (today.millisecondsSinceEpoch <=
                    todayDate.millisecondsSinceEpoch)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey.shade400,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        ListTile(
                          minLeadingWidth: 5,
                          title: Text(
                              AppLocalizations.of(context)!.log_your_weight,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          leading: const Icon(Icons.monitor_weight_outlined),
                          trailing: recordedWeight != null
                              ? const Icon(
                                  Icons.check_circle_outline,
                                  size: 20,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.add_circle_outline,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                          iconColor: mainColor0,
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => Material(
                                        child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .log_your_weight,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                              ),
                                              const SizedBox(height: 40),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                color: Colors.grey.shade200,
                                                child: TextFormField(
                                                  controller:
                                                      controllerCurrentWeight,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    suffixText: profile.units ==
                                                            "Metric"
                                                        ? " kg"
                                                        : " lb",
                                                    labelText:
                                                        AppLocalizations.of(
                                                                context)!
                                                            .current_weight,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 3),
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return AppLocalizations
                                                              .of(context)!
                                                          .current_weight_required;
                                                    } else {
                                                      bool numberValid =
                                                          RegExp(r'^[0-9]+$')
                                                              .hasMatch(
                                                                  value.trim());
                                                      if (!numberValid) {
                                                        return AppLocalizations
                                                                .of(context)!
                                                            .only_numeric_characters;
                                                      }
                                                    }
                                                    profile.units == "Metric"
                                                        ? profile
                                                                .currentWeight =
                                                            int.parse(value)
                                                        : profile
                                                                .currentWeight =
                                                            (double.parse(
                                                                        value) /
                                                                    2.205)
                                                                .round();
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                color: Colors.grey.shade200,
                                                child: TextFormField(
                                                  readOnly: true,
                                                  onTap: () async {
                                                    DateTime? day =
                                                        await showDatePicker(
                                                            errorInvalidText:
                                                                AppLocalizations.of(context)!.date_out_of_range,
                                                            context: context,
                                                            initialDate: today,
                                                            firstDate: today.add(
                                                                const Duration(
                                                                    days: -10)),
                                                            lastDate:
                                                                todayDate);
                                                    if (day != null) {
                                                      controllerDate.text = day
                                                          .toString()
                                                          .split(' ')[0];
                                                    }
                                                  },
                                                  controller: controllerDate,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: "Date",
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 3),
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return AppLocalizations.of(context)!.date_required;
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors
                                                      .green, // background
                                                  onPrimary: Colors
                                                      .white, // foreground
                                                  onSurface: Colors.green,
                                                  minimumSize:
                                                      const Size.fromHeight(50),
                                                ),
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    await weightRepo
                                                        .createWeight(Weight(
                                                            day: controllerDate
                                                                .text,
                                                            uid: profile.uid,
                                                            weight: int.parse(
                                                                controllerCurrentWeight
                                                                    .text),
                                                            units:
                                                                profile.units));
                                                    if (validations
                                                            .convertDateTimeToDate(
                                                                DateTime.now())
                                                            .toString()
                                                            .split(' ')[0] ==
                                                        controllerDate.text) {
                                                      preferences
                                                          .setUser(profile);
                                                      await userRop
                                                          .updateUserById(
                                                              profile.uid!,
                                                              profile);
                                                    }
                                                    Weight? recordedWeightt =
                                                        await weightRepo
                                                            .getWeightByUidDate(
                                                                profile.uid!,
                                                                today
                                                                    .toString()
                                                                    .split(
                                                                        ' ')[0]);
                                                    setState(() {
                                                      recordedWeight =
                                                          recordedWeightt;
                                                      if (recordedWeightt !=
                                                          null) {
                                                        objectifWeight =
                                                            recordedWeightt
                                                                    .weight! -
                                                                profile
                                                                    .startingWeight!;
                                                      }
                                                    });
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .save,
                                                  style: const TextStyle(
                                                      fontSize: 25),
                                                ),
                                              )
                                            ]),
                                      ),
                                    ))).then((value) {
                              setState(() {
                                if (validations
                                        .convertDateTimeToDate(DateTime.now())
                                        .toString()
                                        .split(' ')[0] ==
                                    controllerDate.text) {
                                  objectifWeight = profile.currentWeight! -
                                      profile.startingWeight!;
                                }
                                controllerCurrentWeight.text = "";
                                controllerDate.text =
                                    today.toString().split(' ')[0];
                              });
                            });
                          },
                        ),
                        if (recordedWeight != null)
                          Container(
                            color: Colors.grey.shade200,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            height: 2,
                          ),
                        if (recordedWeight != null)
                          ListTile(
                            minLeadingWidth: 5,
                            title: Text(
                                AppLocalizations.of(context)!.current_weight,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(profile.units == "Metric"
                                ? "+$objectifWeight kg"
                                : "+${objectifWeight * 2.205.round()} lb"),
                            leading: const Icon(Icons.grade_outlined),
                            iconColor: mainColor0,
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 30),
                Text(AppLocalizations.of(context)!.nutrition,
                    style: styleTitle177),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade400,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      ListTile(
                          minLeadingWidth: 5,
                          title: Text(AppLocalizations.of(context)!.breakfast,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: currentDiet.customBreakfast == null
                              ? null
                              : Text(currentDiet.customBreakfast!.join(', ')),
                          leading: const Icon(Icons.free_breakfast_outlined),
                          trailing: currentDiet.customBreakfast == null
                              ? const Icon(
                                  Icons.add_circle_outline,
                                  size: 20,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  Icons.check_circle_outline,
                                  size: 20,
                                  color: Colors.green,
                                ),
                          iconColor: mainColor0,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => AddMeal(
                                      title: AppLocalizations.of(context)!
                                          .breakfast,
                                      meal: "customBreakfast",
                                      currentDiet: currentDiet,
                                      callback: () async {
                                        Diet? diet = await dietRepo.getByDay(
                                            today.toString().split(' ')[0]);
                                        if (diet != null) {
                                          setState(() {
                                            currentDiet = diet;
                                            refreshProccess(diet);
                                          });
                                        }
                                      }),
                                ));
                          }),
                      Container(
                        color: Colors.grey.shade200,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        height: 2,
                      ),
                      if (profile.mealsPerDay != 3)
                        ListTile(
                            minLeadingWidth: 5,
                            title: Text(AppLocalizations.of(context)!.snack1,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: currentDiet.customSnack1 == null
                                ? null
                                : Text(currentDiet.customSnack1!.join(', ')),
                            leading:
                                const Icon(Icons.breakfast_dining_outlined),
                            trailing: currentDiet.customSnack1 == null
                                ? const Icon(
                                    Icons.add_circle_outline,
                                    size: 20,
                                    color: Colors.grey,
                                  )
                                : const Icon(
                                    Icons.check_circle_outline,
                                    size: 20,
                                    color: Colors.green,
                                  ),
                            iconColor: mainColor0,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) => AddMeal(
                                        title: AppLocalizations.of(context)!
                                            .snack1,
                                        meal: "customSnack1",
                                        currentDiet: currentDiet,
                                        callback: () async {
                                          Diet? diet = await dietRepo.getByDay(
                                              today.toString().split(' ')[0]);
                                          if (diet != null) {
                                            setState(() {
                                              currentDiet = diet;
                                              refreshProccess(diet);
                                            });
                                          }
                                        }),
                                  ));
                            }),
                      if (profile.mealsPerDay != 3)
                        Container(
                          color: Colors.grey.shade200,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 2,
                        ),
                      if (profile.mealsPerDay != 2)
                        ListTile(
                            minLeadingWidth: 5,
                            title: Text(AppLocalizations.of(context)!.lunch,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: currentDiet.customLunch == null
                                ? null
                                : Text(currentDiet.customLunch!.join(', ')),
                            leading: const Icon(Icons.lunch_dining_outlined),
                            trailing: currentDiet.customLunch == null
                                ? const Icon(
                                    Icons.add_circle_outline,
                                    size: 20,
                                    color: Colors.grey,
                                  )
                                : const Icon(
                                    Icons.check_circle_outline,
                                    size: 20,
                                    color: Colors.green,
                                  ),
                            iconColor: mainColor0,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) => AddMeal(
                                        title:
                                            AppLocalizations.of(context)!.lunch,
                                        meal: "customLunch",
                                        currentDiet: currentDiet,
                                        callback: () async {
                                          Diet? diet = await dietRepo.getByDay(
                                              today.toString().split(' ')[0]);
                                          if (diet != null) {
                                            setState(() {
                                              currentDiet = diet;
                                              refreshProccess(diet);
                                            });
                                          }
                                        }),
                                  ));
                            }),
                      if (profile.mealsPerDay != 2)
                        Container(
                          color: Colors.grey.shade200,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 2,
                        ),
                      if (profile.mealsPerDay != 3 && profile.mealsPerDay != 4)
                        ListTile(
                            minLeadingWidth: 5,
                            title: Text(AppLocalizations.of(context)!.snack2,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: currentDiet.customSnack2 == null
                                ? null
                                : Text(currentDiet.customSnack2!.join(', ')),
                            leading:
                                const Icon(Icons.breakfast_dining_outlined),
                            trailing: currentDiet.customSnack2 == null
                                ? const Icon(
                                    Icons.add_circle_outline,
                                    size: 20,
                                    color: Colors.grey,
                                  )
                                : const Icon(
                                    Icons.check_circle_outline,
                                    size: 20,
                                    color: Colors.green,
                                  ),
                            iconColor: mainColor0,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) => AddMeal(
                                        title: AppLocalizations.of(context)!
                                            .snack2,
                                        meal: "customSnack2",
                                        currentDiet: currentDiet,
                                        callback: () async {
                                          Diet? diet = await dietRepo.getByDay(
                                              today.toString().split(' ')[0]);
                                          if (diet != null) {
                                            setState(() {
                                              currentDiet = diet;
                                              refreshProccess(diet);
                                            });
                                          }
                                        }),
                                  ));
                            }),
                      if (profile.mealsPerDay != 3 && profile.mealsPerDay != 4)
                        Container(
                          color: Colors.grey.shade200,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 2,
                        ),
                      ListTile(
                          minLeadingWidth: 5,
                          title: Text(AppLocalizations.of(context)!.dinner,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: currentDiet.customDinner == null
                              ? null
                              : Text(currentDiet.customDinner!.join(', ')),
                          leading: const Icon(Icons.dinner_dining_outlined),
                          trailing: currentDiet.customDinner == null
                              ? const Icon(
                                  Icons.add_circle_outline,
                                  size: 20,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  Icons.check_circle_outline,
                                  size: 20,
                                  color: Colors.green,
                                ),
                          iconColor: mainColor0,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => AddMeal(
                                      title:
                                          AppLocalizations.of(context)!.dinner,
                                      meal: "customDinner",
                                      currentDiet: currentDiet,
                                      callback: () async {
                                        Diet? diet = await dietRepo.getByDay(
                                            today.toString().split(' ')[0]);
                                        if (diet != null) {
                                          setState(() {
                                            currentDiet = diet;
                                            refreshProccess(diet);
                                          });
                                        }
                                      }),
                                ));
                          }),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(AppLocalizations.of(context)!.water_balance,
                    style: styleTitle177),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade400,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      ListTile(
                        minLeadingWidth: 5,
                        title: Text(
                            AppLocalizations.of(context)!.water_intake +
                                ": ${currentDiet.water} L",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(AppLocalizations.of(context)!.goal +
                            ": ${profile.water ?? "2.25"} L"),
                        leading: const Icon(Icons.water),
                        trailing: currentDiet.water >= profile.water!
                            ? const Icon(
                                Icons.check_circle_outline,
                                size: 20,
                                color: Colors.green,
                              )
                            : null,
                        iconColor: mainColor0,
                      ),
                      Container(
                        color: Colors.grey.shade200,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Wrap(
                          runSpacing: 20,
                          children: [
                            ...waterintake.map((item) => Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (item.drinked) {
                                          setState(() {
                                            item.drinked = false;
                                            waterintake
                                                .where((element) =>
                                                    element.index > item.index)
                                                .forEach((element) {
                                              element.drinked = false;
                                            });
                                            currentDiet.water = waterintake
                                                    .where((element) =>
                                                        element.drinked)
                                                    .length *
                                                0.25;
                                            dietRepo.updateDietWater(
                                                today.toString().split(' ')[0],
                                                currentDiet.water,
                                                profile);
                                          });
                                        }
                                      },
                                      child: Image(
                                        width: 50,
                                        height: 50,
                                        image: AssetImage(item.drinked
                                            ? 'assets/icons/glass-of-water-full.png'
                                            : 'assets/icons/glass-of-water-empty.png'),
                                      ),
                                    ),
                                    item.index < 1 && !item.drinked
                                        ? IconButton(
                                            onPressed: () {
                                              setState(() {
                                                item.drinked = !item.drinked;
                                                currentDiet.water =
                                                    currentDiet.water + 0.25;
                                              });
                                              dietRepo.updateDietWater(
                                                  today
                                                      .toString()
                                                      .split(' ')[0],
                                                  currentDiet.water,
                                                  profile);
                                            },
                                            icon: Icon(
                                              Icons.add_circle,
                                              size: 20,
                                              color: Colors.blue.shade800,
                                            ))
                                        : waterintake
                                                        .lastWhere(
                                                            (element) =>
                                                                element
                                                                    .drinked ==
                                                                true,
                                                            orElse: () =>
                                                                waterintake[0])
                                                        .index ==
                                                    item.index - 1 &&
                                                waterintake[0].drinked
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    item.drinked =
                                                        !item.drinked;
                                                    currentDiet.water =
                                                        currentDiet.water +
                                                            0.25;
                                                  });
                                                  dietRepo.updateDietWater(
                                                      today
                                                          .toString()
                                                          .split(' ')[0],
                                                      currentDiet.water,
                                                      profile);
                                                },
                                                icon: Icon(
                                                  Icons.add_circle,
                                                  size: 20,
                                                  color: Colors.blue.shade800,
                                                ))
                                            : const SizedBox()
                                  ],
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void refreshProccess(diet) {
    setState(() {
      caloryProccess = diet.caloryEaten > diet.dailyCalory!
          ? 1
          : ((diet.caloryEaten * 100) / diet.dailyCalory!) / 100;
      proteinProccess = diet.proteinEaten > diet.dailyProtein!
          ? 1
          : ((diet.proteinEaten * 100) / diet.dailyProtein!) / 100;
      carbsProccess = diet.carbsEaten > diet.dailyCarbs!
          ? 1
          : ((diet.carbsEaten * 100) / diet.dailyCarbs!) / 100;
      fatProccess = diet.fatEaten > diet.dailyFat!
          ? 1
          : ((diet.fatEaten * 100) / diet.dailyFat!) / 100;
    });
  }
}

class _IngredientProgress extends StatelessWidget {
  final String ingredient;
  final double leftAmount;
  final double progress, width;
  final Color progressColor;

  const _IngredientProgress(
      {Key? key,
      required this.ingredient,
      required this.leftAmount,
      required this.progress,
      required this.progressColor,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          ingredient,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 5,
                  width: width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.black12,
                  ),
                ),
                Container(
                  height: 5,
                  width: width * progress,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: progressColor,
                  ),
                )
              ],
            ),
          ],
        ),
        Text("${leftAmount.round()}g " + AppLocalizations.of(context)!.left,
            style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

class _RadialProgress extends StatelessWidget {
  final double height, width, progress;
  final double calorie;

  const _RadialProgress(
      {Key? key,
      required this.height,
      required this.width,
      required this.progress,
      required this.calorie})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _RadialPainter(
        progress: progress,
      ),
      painter: _RadialPainter2(progress: 1),
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${calorie.round()}",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const TextSpan(text: "\n"),
                TextSpan(
                  text: "kcal " + AppLocalizations.of(context)!.left,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final double progress;

  _RadialPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..color = Colors.yellow.shade600
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double relativeProgress = 360 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90),
      math.radians(-relativeProgress),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _RadialPainter2 extends CustomPainter {
  final double progress;

  _RadialPainter2({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double relativeProgress = 360 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90),
      math.radians(-relativeProgress),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class WaterIntake {
  int index;
  bool drinked;
  WaterIntake({required this.index, this.drinked = false});
}
