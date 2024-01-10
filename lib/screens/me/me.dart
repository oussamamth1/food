import 'dart:async';
import 'package:fitfood/models/profile.dart';
import 'package:fitfood/models/weight.dart';
import 'package:fitfood/repo/user_repo.dart';
import 'package:fitfood/repo/weight_repo.dart';
import 'package:fitfood/screens/me/settings/settings.dart';
import 'package:fitfood/services/preferences.dart';
import 'package:fitfood/services/validations.dart';
import 'package:fitfood/style.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import  'package:charts_flutter_new/flutter.dart' as charts;

class Me extends StatefulWidget {
  const Me({Key? key}) : super(key: key);

  @override
  State<Me> createState() => _MeState();
}

class _MeState extends State<Me> {
  Profile profile = Profile();
  String bmiT = "";
  int objectifWeight = 0;
  DateTime today = validations.convertDateTimeToDate(DateTime.now());
  late TextEditingController controllerCurrentWeight;
  late TextEditingController controllerDate;
  final _formKey = GlobalKey<FormState>();
  List<Weight>? recordedWeights;
  // final List<charts.Series<dynamic, num>> seriesList = [];

  @override
  void initState() {
    super.initState();
    controllerCurrentWeight = TextEditingController();
    controllerDate = TextEditingController();
    controllerDate.text = today.toString().split(' ')[0];
    Timer(const Duration(milliseconds: 10), () async {
      Profile? pr = await preferences.getUser();
      if (pr != null) {
        String bmiO = pr.bmi! < 16
            ? AppLocalizations.of(context)!.severe_Thinness
            : pr.bmi! >= 16 && pr.bmi! < 17
                ? AppLocalizations.of(context)!.moderate_Thinness
                : pr.bmi! >= 17 && pr.bmi! < 18.5
                    ? AppLocalizations.of(context)!.mild_Thinness
                    : pr.bmi! >= 18.5 && pr.bmi! < 25
                        ? AppLocalizations.of(context)!.normal
                        : pr.bmi! >= 25 && pr.bmi! < 30
                            ? AppLocalizations.of(context)!.overweight
                            : pr.bmi! >= 30 && pr.bmi! < 35
                                ? AppLocalizations.of(context)!.obese_Class_I
                                : pr.bmi! >= 35 && pr.bmi! < 40
                                    ? AppLocalizations.of(context)!
                                        .obese_Class_II
                                    : AppLocalizations.of(context)!
                                        .obese_Class_III;
        setState(() {
          profile = pr;
          bmiT = bmiO;
          objectifWeight = pr.currentWeight! - pr.startingWeight!;
        });
        List<Weight>? recordedWeightt =
            await weightRepo.getWeightsByUid(profile.uid!);
        if (recordedWeightt != null) {
          setState(() {
            recordedWeights = recordedWeightt;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    controllerCurrentWeight.dispose();
    controllerDate.dispose();
    super.dispose();
  }

  // List<charts.Series<Weight, int>> _createSampleData() {
  //   return [
  //     charts.Series<Weight, int>(
  //       id: 'Sales',
  //       colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
  //       domainFn: (Weight weight, _) =>
  //           int.parse(weight.day.toString().substring(8)),
  //       measureFn: (Weight weight, _) => weight.weight,
  //       data: recordedWeights ?? [],
  //     )
  //   ];
  // }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          actions: [
            IconButton(
                padding: const EdgeInsets.only(right: 10),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Settings(),
                      ));
                },
                icon: const Icon(Icons.settings))
          ],
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.grey.shade200,
          title: Text(AppLocalizations.of(context)!.me, style: styleTitle17),
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowIndicator();
            return true;
          },
          child: RefreshIndicator(
            color: Colors.green,
            onRefresh: () async {
              Profile? pr = await preferences.getUser();
              if (pr != null) {
                String bmiO = pr.bmi! < 16
                    ? AppLocalizations.of(context)!.severe_Thinness
                    : pr.bmi! >= 16 && pr.bmi! < 17
                        ? AppLocalizations.of(context)!.moderate_Thinness
                        : pr.bmi! >= 17 && pr.bmi! < 18.5
                            ? AppLocalizations.of(context)!.mild_Thinness
                            : pr.bmi! >= 18.5 && pr.bmi! < 25
                                ? AppLocalizations.of(context)!.normal
                                : pr.bmi! >= 25 && pr.bmi! < 30
                                    ? AppLocalizations.of(context)!.overweight
                                    : pr.bmi! >= 30 && pr.bmi! < 35
                                        ? AppLocalizations.of(context)!
                                            .obese_Class_I
                                        : pr.bmi! >= 35 && pr.bmi! < 40
                                            ? AppLocalizations.of(context)!
                                                .obese_Class_II
                                            : AppLocalizations.of(context)!
                                                .obese_Class_III;
                setState(() {
                  profile = pr;
                  bmiT = bmiO;
                  objectifWeight = pr.currentWeight! - pr.startingWeight!;
                });
                List<Weight>? recordedWeightt =
                    await weightRepo.getWeightsByUid(profile.uid!);
                if (recordedWeightt != null) {
                  setState(() {
                    recordedWeights = recordedWeightt;
                  });
                }
              }
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15),
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
                        title: Text(AppLocalizations.of(context)!.goal,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        leading: const Icon(Icons.account_tree_rounded,
                            color: mainColor0),
                        iconColor: Colors.grey.shade300,
                      ),
                      Container(
                        color: Colors.grey.shade200,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        height: 2,
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 230, 248, 231),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: ListTile(
                            title: Text(
                                AppLocalizations.of(context)!.current_Goal +
                                    ":"),
                            subtitle: Text(
                                profile.units == "Metric"
                                    ? "+$objectifWeight kg"
                                    : "+${objectifWeight * 2.205.round()} lb",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30)),
                            textColor: Colors.black,
                            trailing: const Icon(Icons.badge, size: 50)),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green, // background
                              onPrimary: Colors.white, // foreground
                              onSurface: Colors.green,
                            ),
                            onPressed: () {
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
                                                    AppLocalizations.of(
                                                            context)!
                                                        .log_your_weight,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                                const SizedBox(height: 40),
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    border:
                                                        const UnderlineInputBorder(),
                                                    labelText: profile
                                                                .units ==
                                                            "Metric"
                                                        ? AppLocalizations.of(
                                                                    context)!
                                                                .current_weight +
                                                            ' (kg)'
                                                        : AppLocalizations.of(
                                                                    context)!
                                                                .current_weight +
                                                            ' (lb)',
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 10),
                                                  ),
                                                  controller:
                                                      controllerCurrentWeight,
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
                                                const SizedBox(height: 20),
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  color: Colors.grey.shade200,
                                                  child: TextFormField(
                                                    readOnly: true,
                                                    onTap: () async {
                                                      DateTime? day = await showDatePicker(
                                                          errorInvalidText:
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .date_out_of_range,
                                                          context: context,
                                                          initialDate: today,
                                                          firstDate: today.add(
                                                              const Duration(
                                                                  days: -10)),
                                                          lastDate: today);
                                                      if (day != null) {
                                                        controllerDate.text =
                                                            day
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
                                                        return AppLocalizations
                                                                .of(context)!
                                                            .date_required;
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors
                                                        .green, // background
                                                    onPrimary: Colors
                                                        .white, // foreground
                                                    onSurface: Colors.green,
                                                    minimumSize:
                                                        const Size.fromHeight(
                                                            50),
                                                  ),
                                                  onPressed: () async {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      await weightRepo
                                                          .createWeight(Weight(
                                                              day:
                                                                  controllerDate
                                                                      .text,
                                                              uid: profile.uid,
                                                              weight: int.parse(
                                                                  controllerCurrentWeight
                                                                      .text),
                                                              units: profile
                                                                  .units));
                                                      if (validations
                                                              .convertDateTimeToDate(
                                                                  DateTime
                                                                      .now())
                                                              .toString()
                                                              .split(' ')[0] ==
                                                          controllerDate.text
                                                              .toString()
                                                              .split(' ')[0]) {
                                                        preferences
                                                            .setUser(profile);
                                                        await userRop
                                                            .updateUserById(
                                                                profile.uid!,
                                                                profile);
                                                      }
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
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
                            child: Text(
                                AppLocalizations.of(context)!.log_your_weight,
                                style: const TextStyle(fontSize: 18))),
                      )
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 15),
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
                            title: Text(AppLocalizations.of(context)!.progress,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            leading:
                                const Icon(Icons.pie_chart, color: mainColor0)),
                        Container(
                          color: Colors.grey.shade200,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 2,
                        ),
                        // Container(
                        //   padding: const EdgeInsets.all(20),
                        //   width: MediaQuery.of(context).size.width,
                        //   height: 200,
                        //   child: 
                        //   charts.LineChart(_createSampleData(),
                        //       animate: true,
                        //       defaultRenderer: charts.LineRendererConfig(
                        //           includePoints: true)),
                        // ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(96, 165, 165, 165),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.of(context)!.start),
                                  Text("${profile.startingWeight} kg",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  Icons.arrow_forward_outlined,
                                  size: 20,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.of(context)!.current),
                                  Text("${profile.currentWeight} kg",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  Icons.arrow_forward_outlined,
                                  size: 20,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.of(context)!.goal),
                                  Text(
                                    "${profile.desiredWeight} kg",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                        // SfCartesianChart(
                        //     primaryXAxis: CategoryAxis(),
                        //     // Chart title
                        //     title:
                        //         ChartTitle(text: 'Half yearly sales analysis'),
                        //     // Enable legend
                        //     legend: Legend(isVisible: true),
                        //     // Enable tooltip
                        //     //tooltipBehavior: _tooltipBehavior,
                        //     series: <LineSeries<Weight, String>>[
                        //       LineSeries<Weight, String>(
                        //           dataSource: recordedWeights ?? [],
                        //           xValueMapper: (Weight weight, _) =>
                        //               weight.day,
                        //           yValueMapper: (Weight weight, _) =>
                        //               weight.weight,
                        //           // Enable data label
                        //           dataLabelSettings:
                        //               DataLabelSettings(isVisible: true))
                        //     ]),
                      ],
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 15),
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
                          title: Text(AppLocalizations.of(context)!.current_BMI,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          leading: const Icon(
                              Icons.align_vertical_bottom_outlined,
                              color: mainColor0)),
                      Container(
                        color: Colors.grey.shade200,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        height: 2,
                      ),
                      ListTile(
                          minVerticalPadding: 20,
                          title: Text(profile.bmi?.toStringAsFixed(1) ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25)),
                          subtitle: Text(
                              AppLocalizations.of(context)!.your_weight_is +
                                  ": $bmiT"),
                          textColor: Colors.black),
                      // Slider(
                      //     value: profile.bmi ?? 23,
                      //     min: 10,
                      //     max: 46,
                      //     activeColor: Colors.green,
                      //     divisions: 8,
                      //     inactiveColor: Colors.red,
                      //     thumbColor: Colors.amber,
                      //     onChanged: null),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [Text("<16"), Text(">40")],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: StepProgressIndicator(
                          totalSteps: 46,
                          currentStep: profile.bmi?.round() ?? 23,
                          size: 8,
                          padding: 0,
                          selectedColor: Colors.greenAccent,
                          unselectedColor: Colors.redAccent,
                          roundedEdges: const Radius.circular(10),
                          selectedGradientColor: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.orangeAccent, Colors.greenAccent],
                          ),
                          unselectedGradientColor: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.green, Colors.redAccent],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.only(bottom: 20),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.underweight),
                            Text(AppLocalizations.of(context)!.normal),
                            Text(AppLocalizations.of(context)!.obese),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
