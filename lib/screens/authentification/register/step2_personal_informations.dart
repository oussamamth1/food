import 'dart:async';

import 'package:fitfood/models/ingredient.dart';
import 'package:fitfood/models/kitchen.dart';
import 'package:fitfood/models/profile.dart';
import 'package:fitfood/screens/authentification/register/step3_enter_email.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Step2Gender extends StatefulWidget {
  final Profile profile;
  final List<Ingredient> sampleIngredients;
  final List<Kitchen> kitchens;
  const Step2Gender(
      {Key? key,
      required this.profile,
      required this.sampleIngredients,
      required this.kitchens})
      : super(key: key);

  @override
  State<Step2Gender> createState() => _Step2GenderState();
}

class _Step2GenderState extends State<Step2Gender> {
  final ScrollController _scrollController = ScrollController();
  int currentStep = 2;
  bool isButtonActive = false;
  bool genderMan = false;
  bool genderWoman = false;
  bool genderPregnancy = false;
  bool genderLactation = false;
  bool metric = true;
  bool pearShaped = false;
  bool squareShaped = false;
  bool hourGlassShaped = false;
  bool appleShaped = false;
  bool endomorphShaped = false;
  bool mesomorphShaped = false;
  bool ectomorphShaped = false;
  bool officetypicalDay = false;
  bool walkstypicalDay = false;
  bool physicaltypicalDay = false;
  bool hometypicalDay = false;
  bool twoTimes = false;
  bool threeTimes = false;
  bool fourTimes = false;
  bool fiveTimes = false;
  bool noWorkout = false;
  bool lightWorkout = false;
  bool moderateWorkout = false;
  bool hardWorkout = false;
  bool extraHardWorkout = false;
  bool extraHard2Workout = false;
  bool lactoseAllergie = false;
  bool gluttenAllergie = false;
  bool vegetarianAllergie = false;
  bool veganAllergie = false;

  late List<bool> noVegetables;
  late List<Ingredient> vegetablesList;
  late List<bool> noFruits;
  late List<Ingredient> fruitsList;
  late List<bool> noCereals;
  late List<Ingredient> cerealsList;
  late List<bool> noDairys;
  late List<Ingredient> dairysList;
  late List<bool> noMeats;
  late List<Ingredient> meatsList;

  late TextEditingController controllerCurrentWeight;
  late TextEditingController controllerDesiredWeight;
  late TextEditingController controllerAge;
  late TextEditingController controllerHeight;
  late TextEditingController controllerHeightFT;
  late TextEditingController controllerHeightInch;

  final List<GlobalKey<FormState>> _formKeySteps =
      List.generate(16, (index) => GlobalKey<FormState>());

  int _start = 1;

  @override
  void initState() {
    super.initState();
    widget.profile.gender = "male";
    widget.profile.kitchen = "";
    widget.profile.units = "Metric";
    widget.profile.allergies = [];
    widget.profile.noVegetables = [];
    widget.profile.noFruits = [];
    widget.profile.noCereals = [];
    widget.profile.noDairys = [];
    widget.profile.noMeats = [];
    controllerCurrentWeight = TextEditingController();
    controllerDesiredWeight = TextEditingController();
    controllerAge = TextEditingController();
    controllerHeight = TextEditingController();
    controllerHeightFT = TextEditingController();
    controllerHeightInch = TextEditingController();
    controllerDesiredWeight.addListener(() {
      final isButtonActive = controllerDesiredWeight.text.isNotEmpty;
      setState(() => this.isButtonActive = isButtonActive);
    });
    vegetablesList = widget.sampleIngredients
        .where((ing) => ing.mainCategory == "vegetables_and_legumes")
        .toList();
    noVegetables = List.generate(vegetablesList.length, (index) => false);
    fruitsList = widget.sampleIngredients
        .where((ing) => ing.mainCategory == "Snacks")
        .toList();
    noFruits = List.generate(fruitsList.length, (index) => false);
    cerealsList = widget.sampleIngredients
        .where((ing) => ing.mainCategory == "cereal")
        .toList();
    noCereals = List.generate(cerealsList.length, (index) => false);
    dairysList = widget.sampleIngredients
        .where((ing) => ing.mainCategory == "dairy")
        .toList();
    noDairys = List.generate(dairysList.length, (index) => false);
    meatsList = widget.sampleIngredients
        .where((ing) => ing.mainCategory == "meat_and_poultry")
        .toList();
    noMeats = List.generate(meatsList.length, (index) => false);
  }

  @override
  void dispose() {
    controllerCurrentWeight.dispose();
    controllerDesiredWeight.dispose();
    controllerAge.dispose();
    controllerHeight.dispose();
    controllerHeightFT.dispose();
    controllerHeightInch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.white,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Image(
                    width: 40,
                    image: AssetImage('assets/images/logo.png'),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                  ),
                  Text("Fit'Food",
                      style: Theme.of(context).textTheme.headline5),
                ],
              ),
            ),
            body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowIndicator();
                return true;
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (currentStep <= 15)
                        Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: Row(
                                  children: [
                                    const Icon(Icons.arrow_back_ios, size: 15),
                                    Text(AppLocalizations.of(context)!.previous_Step)
                                  ],
                                ),
                                onTap: () {
                                  currentStep > 2
                                      ? setState(() {
                                          isButtonActive = true;
                                          currentStep--;
                                        })
                                      : Navigator.pop(context);
                                },
                              ),
                              Text("$currentStep/15")
                            ],
                          ),
                        ),
                      if (currentStep <= 15)
                        StepProgressIndicator(
                          totalSteps: 15,
                          currentStep: currentStep,
                          selectedColor: Colors.green,
                          unselectedColor: Colors.red,
                        ),
                      steps(currentStep),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: currentStep <= 15
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // background
                      onPrimary: Colors.white, // foreground
                      onSurface: Colors.green,
                      minimumSize: const Size.fromHeight(60),
                    ),
                    onPressed: isButtonActive
                        ? () {
                            if (_formKeySteps[currentStep]
                                .currentState!
                                .validate()) {
                              setState(() {
                                currentStep++;
                              });
                              scrollToTop();
                            }
                          }
                        : null,
                    child: Text(
                      AppLocalizations.of(context)!.continuee,
                      style: const TextStyle(fontSize: 25),
                    ),
                  )
                : null),
      ),
    );
  }

  Widget steps(currentstep) {
    switch (currentstep) {
      case 2:
        return Form(
          key: _formKeySteps[currentstep],
          child: Column(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)!.select_your_gender,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  selectedColor: Colors.green,
                  title: Text(AppLocalizations.of(context)!.man),
                  trailing: const Icon(Icons.male),
                  selected: genderMan,
                  onTap: () {
                    setState(() {
                      genderMan = true;
                      genderWoman = false;
                      genderLactation = false;
                      genderPregnancy = false;
                      isButtonActive = true;
                      widget.profile.gender = "male";
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  selectedColor: Colors.green,
                  title: Text(AppLocalizations.of(context)!.woman),
                  trailing: const Icon(Icons.female),
                  selected: genderWoman,
                  onTap: () {
                    setState(() {
                      genderWoman = true;
                      genderMan = false;
                      genderLactation = false;
                      genderPregnancy = false;
                      isButtonActive = true;
                      widget.profile.gender = "female";
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
              ),
              Visibility(
                visible: widget.profile.gender != "male",
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: ListTile(
                    selectedColor: Colors.green,
                    title: Text(AppLocalizations.of(context)!.pregnancy),
                    trailing: const Icon(Icons.pregnant_woman),
                    selected: genderPregnancy,
                    onTap: () {
                      setState(() {
                        genderPregnancy = true;
                        genderLactation = false;
                        genderWoman = false;
                        genderMan = false;
                        isButtonActive = true;
                        widget.profile.gender = "pregnacy";
                      });
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
              ),
              Visibility(
                visible: widget.profile.gender != "male",
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: ListTile(
                    selectedColor: Colors.green,
                    title: Text(AppLocalizations.of(context)!.lactation),
                    trailing: const Icon(Icons.baby_changing_station),
                    selected: genderLactation,
                    onTap: () {
                      setState(() {
                        genderLactation = true;
                        genderPregnancy = false;
                        genderWoman = false;
                        genderMan = false;
                        isButtonActive = true;
                        widget.profile.gender = "lactation";
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      case 3:
        if (widget.profile.kitchen == "") {
          setState(() {
            isButtonActive = false;
          });
        }
        return Form(
          key: _formKeySteps[currentstep],
          child: Column(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)!.select_your_kitchen,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: widget.kitchens.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: RadioListTile<String>(
                          activeColor: Colors.green,
                          title: Text(widget.kitchens[index].name.toString()),
                          value: widget.kitchens[index].name.toString(),
                          groupValue: widget.profile.kitchen,
                          onChanged: (value) {
                            setState(() {
                              isButtonActive = true;
                              widget.profile.kitchen =
                                  widget.kitchens[index].name;
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                      ),
                    ],
                  );
                },
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
              ),
            ],
          ),
        );
      case 4:
        return Form(
          key: _formKeySteps[currentstep],
          child: Column(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)!.what_is_your_desired_weight,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    decoration: BoxDecoration(
                        color: metric ? Colors.grey.shade200 : Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(10))),
                    child: ListTile(
                      selectedColor: Colors.green,
                      title: Text(AppLocalizations.of(context)!.metric,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 25)),
                      selected: metric,
                      onTap: () {
                        setState(() {
                          metric = true;
                          widget.profile.units = "Metric";
                        });
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    decoration: BoxDecoration(
                        color: !metric ? Colors.grey.shade200 : Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(10))),
                    child: ListTile(
                      selectedColor: Colors.green,
                      title: Text(AppLocalizations.of(context)!.imperial,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 25)),
                      selected: !metric,
                      onTap: () {
                        setState(() {
                          metric = false;
                          widget.profile.units = "Imperial";
                        });
                      },
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText:
                      metric ? AppLocalizations.of(context)!.desired_weight+' (kg)' : AppLocalizations.of(context)!.desired_weight+' (lb)',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                controller: controllerDesiredWeight,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.desired_Weight_required;
                  } else {
                    bool numberValid = RegExp(r'^[0-9]+$').hasMatch(value.trim());
                    if (!numberValid) {
                      return AppLocalizations.of(context)!.only_numeric_characters;
                    }
                  }
                  metric
                      ? widget.profile.desiredWeight = int.parse(value)
                      : widget.profile.desiredWeight =
                          (double.parse(value) / 2.205).round();
                  return null;
                },
              ),
            ],
          ),
        );
      case 5:
        return Form(
          key: _formKeySteps[currentstep],
          child: Column(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)!.check_you_body_measures,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    decoration: BoxDecoration(
                        color: metric ? Colors.grey.shade200 : Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(10))),
                    child: ListTile(
                      selectedColor: Colors.green,
                      title: Text(AppLocalizations.of(context)!.metric,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 25)),
                      selected: metric,
                      onTap: () {
                        setState(() {
                          metric = true;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    decoration: BoxDecoration(
                        color: !metric ? Colors.grey.shade200 : Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(10))),
                    child: ListTile(
                      selectedColor: Colors.green,
                      title: Text(AppLocalizations.of(context)!.imperial,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 25)),
                      selected: !metric,
                      onTap: () {
                        setState(() {
                          metric = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.age_years,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                controller: controllerAge,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.age_required;
                  } else {
                    bool numberValid = RegExp(r'^[0-9]+$').hasMatch(value.trim());
                    if (!numberValid) {
                      return AppLocalizations.of(context)!.only_numeric_characters;
                    }
                  }
                  widget.profile.age = int.parse(value);
                  if (widget.profile.age! < 9) {
                    widget.profile.gender = "children";
                  }
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              metric
                  ? TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: AppLocalizations.of(context)!.height_unit('cm'),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      controller: controllerHeight,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.height_unit_required('cm');
                        } else {
                          bool numberValid = RegExp(r'^[0-9]+$').hasMatch(value.trim());
                          if (!numberValid) {
                            return AppLocalizations.of(context)!.only_numeric_characters;
                          }
                        }
                        widget.profile.height = double.parse(value);
                        return null;
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 20,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration:InputDecoration(
                              border: const UnderlineInputBorder(),
                              labelText: AppLocalizations.of(context)!.height_unit('ft'),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            controller: controllerHeightFT,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.height_unit_required('ft');
                              } else {
                                bool numberValid = RegExp(r'^[0-9]+$').hasMatch(value.trim());
                                if (!numberValid) {
                                  return AppLocalizations.of(context)!.only_numeric_characters;
                                }
                              }
                              widget.profile.height =
                                  double.parse(value) * 30.48;
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 20,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: const UnderlineInputBorder(),
                              labelText: AppLocalizations.of(context)!.height_unit('inch'),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            controller: controllerHeightInch,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.height_unit_required('inch');
                              } else {
                                bool numberValid = RegExp(r'^[0-9]+$').hasMatch(value.trim());
                                if (!numberValid) {
                                  return AppLocalizations.of(context)!.only_numeric_characters;
                                }
                              }
                              widget.profile.height =
                                  double.parse(controllerHeightFT.text) +
                                      double.parse(value) * 2.54;
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText:
                      metric ? AppLocalizations.of(context)!.current_weight+' (kg)' : AppLocalizations.of(context)!.current_weight+' (lb)',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                controller: controllerCurrentWeight,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.current_weight_required;
                  } else {
                    bool numberValid = RegExp(r'^[0-9]+$').hasMatch(value.trim());
                    if (!numberValid) {
                      return AppLocalizations.of(context)!.only_numeric_characters;
                    }
                  }
                  metric
                      ? widget.profile.currentWeight = int.parse(value)
                      : widget.profile.currentWeight =
                          (double.parse(value) / 2.205).round();
                  return null;
                },
              ),
            ],
          ),
        );
      case 6:
        if (widget.profile.gender != "male" &&
            !appleShaped &&
            !pearShaped &&
            !squareShaped &&
            !hourGlassShaped) {
          setState(() {
            isButtonActive = false;
          });
        } else if (widget.profile.gender == "male" &&
            !endomorphShaped &&
            !mesomorphShaped &&
            !ectomorphShaped) {
          setState(() {
            isButtonActive = false;
          });
        }
        return Form(
          key: _formKeySteps[currentstep],
          child: Column(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    AppLocalizations.of(context)!.body_type,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  child: Text(
                    AppLocalizations.of(context)!.each_body_type_specific_metabolic_structure,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Visibility(
                visible: widget.profile.gender != "male",
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: ListTile(
                    selectedColor: Colors.green,
                    selected: pearShaped,
                    title: Text(AppLocalizations.of(context)!.pear_shaped),
                    subtitle: Text(
                        AppLocalizations.of(context)!.naturally_slimmer_shoulders),
                    trailing: const Image(
                      image: AssetImage('assets/images/Pear-shaped.png'),
                    ),
                    onTap: () {
                      setState(() {
                        pearShaped = true;
                        squareShaped = false;
                        hourGlassShaped = false;
                        appleShaped = false;
                        endomorphShaped = false;
                        mesomorphShaped = false;
                        ectomorphShaped = false;
                        isButtonActive = true;
                        widget.profile.bodyType = 0;
                      });
                    },
                  ),
                ),
              ),
              Visibility(
                visible: widget.profile.gender == "male",
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: ListTile(
                    selectedColor: Colors.green,
                    selected: ectomorphShaped,
                    title: Text(AppLocalizations.of(context)!.ectomorph),
                    subtitle: Text(AppLocalizations.of(context)!.lean_long_fast_metabolism),
                    trailing: const Image(
                        image: AssetImage('assets/images/Ectomorph.png')),
                    onTap: () {
                      setState(() {
                        endomorphShaped = false;
                        mesomorphShaped = false;
                        ectomorphShaped = true;
                        pearShaped = false;
                        squareShaped = false;
                        hourGlassShaped = false;
                        appleShaped = false;
                        isButtonActive = true;
                        widget.profile.bodyType = 4;
                      });
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Visibility(
                visible: widget.profile.gender != "male",
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: ListTile(
                    selectedColor: Colors.green,
                    selected: squareShaped,
                    title: Text(AppLocalizations.of(context)!.square_shaped),
                    subtitle: Text(AppLocalizations.of(context)!.naturally_wide_shoulders_thighs),
                    trailing: const Image(
                      image: AssetImage('assets/images/Square-shaped.png'),
                    ),
                    onTap: () {
                      setState(() {
                        pearShaped = false;
                        squareShaped = true;
                        hourGlassShaped = false;
                        appleShaped = false;
                        endomorphShaped = false;
                        mesomorphShaped = false;
                        ectomorphShaped = false;
                        isButtonActive = true;
                        widget.profile.bodyType = 1;
                      });
                    },
                  ),
                ),
              ),
              Visibility(
                visible: widget.profile.gender == "male",
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: ListTile(
                    selectedColor: Colors.green,
                    selected: mesomorphShaped,
                    title: Text(AppLocalizations.of(context)!.mesomorph),
                    subtitle: Text(
                        AppLocalizations.of(context)!.muscular_average_metabolism),
                    trailing: const Image(
                        image: AssetImage('assets/images/Mesomorph.png')),
                    onTap: () {
                      setState(() {
                        endomorphShaped = false;
                        mesomorphShaped = true;
                        ectomorphShaped = false;
                        pearShaped = false;
                        squareShaped = false;
                        hourGlassShaped = false;
                        appleShaped = false;
                        isButtonActive = true;
                        widget.profile.bodyType = 5;
                      });
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Visibility(
                visible: widget.profile.gender != "male",
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: ListTile(
                    selectedColor: Colors.green,
                    selected: hourGlassShaped,
                    title: Text(AppLocalizations.of(context)!.hourglass),
                    subtitle: Text(AppLocalizations.of(context)!.wide_bust_hips),
                    trailing: const Image(
                      image: AssetImage('assets/images/Hourglass.png'),
                    ),
                    onTap: () {
                      setState(() {
                        pearShaped = false;
                        squareShaped = false;
                        hourGlassShaped = true;
                        appleShaped = false;
                        endomorphShaped = false;
                        mesomorphShaped = false;
                        ectomorphShaped = false;
                        isButtonActive = true;
                        widget.profile.bodyType = 2;
                      });
                    },
                  ),
                ),
              ),
              Visibility(
                visible: widget.profile.gender == "male",
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: ListTile(
                    selectedColor: Colors.green,
                    selected: endomorphShaped,
                    title: Text(AppLocalizations.of(context)!.endomorph),
                    subtitle: Text(AppLocalizations.of(context)!.soft_round_slow_metabolism),
                    trailing: const Image(
                        image: AssetImage('assets/images/Endomorph.png')),
                    onTap: () {
                      setState(() {
                        endomorphShaped = true;
                        mesomorphShaped = false;
                        ectomorphShaped = false;
                        pearShaped = false;
                        squareShaped = false;
                        hourGlassShaped = false;
                        appleShaped = false;
                        isButtonActive = true;
                        widget.profile.bodyType = 6;
                      });
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Visibility(
                visible: widget.profile.gender != "male",
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: ListTile(
                    selectedColor: Colors.green,
                    selected: appleShaped,
                    title: Text(AppLocalizations.of(context)!.apple_shaped),
                    subtitle:
                        Text(AppLocalizations.of(context)!.naturally_wide_torso_broad_shoulders),
                    trailing: const Image(
                      image: AssetImage('assets/images/Apple-shaped.png'),
                    ),
                    onTap: () {
                      setState(() {
                        pearShaped = false;
                        squareShaped = false;
                        hourGlassShaped = false;
                        appleShaped = true;
                        endomorphShaped = false;
                        mesomorphShaped = false;
                        ectomorphShaped = false;
                        isButtonActive = true;
                        widget.profile.bodyType = 3;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      case 7:
        if (!officetypicalDay &&
            !walkstypicalDay &&
            !physicaltypicalDay &&
            !hometypicalDay) {
          setState(() {
            isButtonActive = false;
          });
        }
        var gender = widget.profile.gender == "male" ? AppLocalizations.of(context)!.men : AppLocalizations.of(context)!.women;
        var objective = widget.profile.objective == 0
            ? AppLocalizations.of(context)!.lose_Weight
            : widget.profile.objective == 1
                ? AppLocalizations.of(context)!.gain_Weight
                : AppLocalizations.of(context)!.maintain_Weight;
        return Form(
          key: _formKeySteps[currentstep],
          child: Column(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    AppLocalizations.of(context)!.describe_your_typical_day,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  child: Text(AppLocalizations.of(context)!.who_want_to_require(gender,objective),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  selectedColor: Colors.green,
                  selected: officetypicalDay,
                  title: Text(AppLocalizations.of(context)!.at_the_office),
                  trailing: const Image(
                    image: AssetImage('assets/images/office.png'),
                  ),
                  onTap: () {
                    setState(() {
                      officetypicalDay = true;
                      walkstypicalDay = false;
                      physicaltypicalDay = false;
                      hometypicalDay = false;
                      isButtonActive = true;
                      widget.profile.typicalDay = 0;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  selectedColor: Colors.green,
                  selected: walkstypicalDay,
                  title: Text(AppLocalizations.of(context)!.daily_long_walks),
                  trailing: const Image(
                    image: AssetImage('assets/images/walks.png'),
                  ),
                  onTap: () {
                    setState(() {
                      officetypicalDay = false;
                      walkstypicalDay = true;
                      physicaltypicalDay = false;
                      hometypicalDay = false;
                      isButtonActive = true;
                      widget.profile.typicalDay = 1;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  selectedColor: Colors.green,
                  selected: physicaltypicalDay,
                  title: Text(AppLocalizations.of(context)!.physical_work),
                  trailing: const Image(
                    image: AssetImage('assets/images/physical.png'),
                  ),
                  onTap: () {
                    setState(() {
                      officetypicalDay = false;
                      walkstypicalDay = false;
                      physicaltypicalDay = true;
                      hometypicalDay = false;
                      isButtonActive = true;
                      widget.profile.typicalDay = 2;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  selectedColor: Colors.green,
                  selected: hometypicalDay,
                  title: Text(AppLocalizations.of(context)!.mostly_at_home),
                  trailing: const Image(
                    image: AssetImage('assets/images/home.png'),
                  ),
                  onTap: () {
                    setState(() {
                      officetypicalDay = false;
                      walkstypicalDay = false;
                      physicaltypicalDay = false;
                      hometypicalDay = true;
                      isButtonActive = true;
                      widget.profile.typicalDay = 3;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      case 8:
        if (!twoTimes && !threeTimes && !fourTimes && !fiveTimes) {
          setState(() {
            isButtonActive = false;
          });
        }
        return Form(
          key: _formKeySteps[currentstep],
          child: Column(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    AppLocalizations.of(context)!.how_many_times_you_want_to_eat,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  child: Text(
                    AppLocalizations.of(context)!.will_plan_your_meals_according_preferences,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  selectedColor: Colors.green,
                  selected: twoTimes,
                  title:
                      Text(AppLocalizations.of(context)!.two_times+" ("+AppLocalizations.of(context)!.breakfast_dinner_2_snacks+")"),
                  onTap: () {
                    setState(() {
                      twoTimes = true;
                      threeTimes = false;
                      fourTimes = false;
                      fiveTimes = false;
                      isButtonActive = true;
                      widget.profile.mealsPerDay = 2;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  selectedColor: Colors.green,
                  selected: threeTimes,
                  title:
                      Text(AppLocalizations.of(context)!.three_times+" ("+AppLocalizations.of(context)!.breakfast_lunch_dinner+")"),
                  onTap: () {
                    setState(() {
                      twoTimes = false;
                      threeTimes = true;
                      fourTimes = false;
                      fiveTimes = false;
                      isButtonActive = true;
                      widget.profile.mealsPerDay = 3;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  selectedColor: Colors.green,
                  selected: fourTimes,
                  title: Text(
                      AppLocalizations.of(context)!.four_times+" ("+AppLocalizations.of(context)!.breakfast_snack_lunch_dinner+")"),
                  onTap: () {
                    setState(() {
                      twoTimes = false;
                      threeTimes = false;
                      fourTimes = true;
                      fiveTimes = false;
                      isButtonActive = true;
                      widget.profile.mealsPerDay = 4;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  selectedColor: Colors.green,
                  selected: fiveTimes,
                  title: Text(
                      AppLocalizations.of(context)!.five_times+" ("+AppLocalizations.of(context)!.breakfast_lunch_dinner_2_snacks+")"),
                  onTap: () {
                    setState(() {
                      twoTimes = false;
                      threeTimes = false;
                      fourTimes = false;
                      fiveTimes = true;
                      isButtonActive = true;
                      widget.profile.mealsPerDay = 5;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      case 9:
        if (!noWorkout &&
            !lightWorkout &&
            !moderateWorkout &&
            !hardWorkout &&
            !extraHardWorkout &&
            !extraHard2Workout) {
          setState(() {
            isButtonActive = false;
          });
        }
        var gender = widget.profile.gender == "male" ? AppLocalizations.of(context)!.men : AppLocalizations.of(context)!.women;
        var objective = widget.profile.objective == 0
            ? AppLocalizations.of(context)!.lose_Weight
            : widget.profile.objective == 1
                ? AppLocalizations.of(context)!.gain_Weight
                : AppLocalizations.of(context)!.maintain_Weight;
        var typicalDay = widget.profile.typicalDay == 0
            ? AppLocalizations.of(context)!.works_at_the_office
            : widget.profile.typicalDay == 1
                ? AppLocalizations.of(context)!.walks_regularly
                : widget.profile.typicalDay == 2
                    ? AppLocalizations.of(context)!.works_physically
                    : AppLocalizations.of(context)!.is_mostly_at_home;
        return Form(
          key: _formKeySteps[currentstep],
          child: Column(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    AppLocalizations.of(context)!.do_you_workout,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  child: Text(AppLocalizations.of(context)!.it_is_important_to_take_into(gender,objective,typicalDay),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  selectedColor: Colors.green,
                  selected: noWorkout,
                  title: Text(AppLocalizations.of(context)!.almost_nothing),
                  onTap: () {
                    setState(() {
                      noWorkout = true;
                      lightWorkout = false;
                      moderateWorkout = false;
                      hardWorkout = false;
                      extraHardWorkout = false;
                      extraHard2Workout = false;
                      isButtonActive = true;
                      widget.profile.workout = 0;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  selectedColor: Colors.green,
                  selected: lightWorkout,
                  title: Text(
                      AppLocalizations.of(context)!.lightly_active),
                  onTap: () {
                    setState(() {
                      noWorkout = false;
                      lightWorkout = true;
                      moderateWorkout = false;
                      hardWorkout = false;
                      extraHardWorkout = false;
                      extraHard2Workout = false;
                      isButtonActive = true;
                      widget.profile.workout = 1;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  selectedColor: Colors.green,
                  selected: moderateWorkout,
                  title: Text(
                      AppLocalizations.of(context)!.moderately_active),
                  onTap: () {
                    setState(() {
                      noWorkout = false;
                      lightWorkout = false;
                      moderateWorkout = true;
                      hardWorkout = false;
                      extraHardWorkout = false;
                      extraHard2Workout = false;
                      isButtonActive = true;
                      widget.profile.workout = 2;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  selectedColor: Colors.green,
                  selected: hardWorkout,
                  title: Text(
                      AppLocalizations.of(context)!.very_active),
                  onTap: () {
                    setState(() {
                      noWorkout = false;
                      lightWorkout = false;
                      moderateWorkout = false;
                      hardWorkout = true;
                      extraHardWorkout = false;
                      extraHard2Workout = false;
                      isButtonActive = true;
                      widget.profile.workout = 3;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  selectedColor: Colors.green,
                  selected: extraHardWorkout,
                  title: Text(
                      AppLocalizations.of(context)!.extra_active),
                  onTap: () {
                    setState(() {
                      noWorkout = false;
                      lightWorkout = false;
                      moderateWorkout = false;
                      hardWorkout = false;
                      extraHardWorkout = true;
                      extraHard2Workout = false;
                      isButtonActive = true;
                      widget.profile.workout = 4;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  selectedColor: Colors.green,
                  selected: extraHard2Workout,
                  title: Text(
                      AppLocalizations.of(context)!.super_active),
                  onTap: () {
                    setState(() {
                      noWorkout = false;
                      lightWorkout = false;
                      moderateWorkout = false;
                      hardWorkout = false;
                      extraHardWorkout = false;
                      extraHard2Workout = true;
                      isButtonActive = true;
                      widget.profile.workout = 5;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      case 10:
        return Form(
          key: _formKeySteps[currentstep],
          child: Column(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)!.you_have_dietary_restrictions,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: CheckboxListTile(
                  value: lactoseAllergie,
                  activeColor: Colors.green,
                  selected: lactoseAllergie,
                  title: Text(AppLocalizations.of(context)!.im_lactose_intolerant),
                  onChanged: (value) {
                    setState(() {
                      lactoseAllergie = !lactoseAllergie;
                      if (lactoseAllergie) {
                        widget.profile.allergies!.add("lactose");
                      } else {
                        widget.profile.allergies!.remove("lactose");
                      }
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: CheckboxListTile(
                  value: gluttenAllergie,
                  activeColor: Colors.green,
                  selected: gluttenAllergie,
                  title: Text(AppLocalizations.of(context)!.im_dont_eat_gluten),
                  onChanged: (value) {
                    setState(() {
                      gluttenAllergie = !gluttenAllergie;
                      if (gluttenAllergie) {
                        widget.profile.allergies!.add("gluten");
                      } else {
                        widget.profile.allergies!.remove("gluten");
                      }
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: CheckboxListTile(
                  value: vegetarianAllergie,
                  activeColor: Colors.green,
                  selected: vegetarianAllergie,
                  title: Text(AppLocalizations.of(context)!.im_vegetarian),
                  onChanged: (value) {
                    setState(() {
                      vegetarianAllergie = !vegetarianAllergie;
                      if (vegetarianAllergie) {
                        widget.profile.allergies!.add("vegetarian");
                      } else {
                        widget.profile.allergies!.remove("vegetarian");
                      }
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: CheckboxListTile(
                  value: veganAllergie,
                  activeColor: Colors.green,
                  selected: veganAllergie,
                  title: Text(AppLocalizations.of(context)!.im_vegan),
                  onChanged: (value) {
                    setState(() {
                      veganAllergie = !veganAllergie;
                      if (veganAllergie) {
                        widget.profile.allergies!.add("vegan");
                      } else {
                        widget.profile.allergies!.remove("vegan");
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        );
      case 11:
        return Form(
          key: _formKeySteps[currentstep],
          child: Column(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)!.mark_the_vegetables,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: vegetablesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: CheckboxListTile(
                          value: noVegetables[index],
                          activeColor: Colors.green,
                          selected: noVegetables[index],
                          title: Text(vegetablesList[index].name.toString()),
                          onChanged: (value) {
                            setState(() {
                              noVegetables[index] = !noVegetables[index];
                              if (noVegetables[index]) {
                                widget.profile.noVegetables!
                                    .add(vegetablesList[index].name.toString());
                              } else {
                                widget.profile.noVegetables!.remove(
                                    vegetablesList[index].name.toString());
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ],
                  );
                },
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
              ),
            ],
          ),
        );
      case 12:
        return Form(
          key: _formKeySteps[currentstep],
          child: Column(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)!.mark_the_fruits,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: fruitsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: CheckboxListTile(
                          value: noFruits[index],
                          activeColor: Colors.green,
                          selected: noFruits[index],
                          title: Text(fruitsList[index].name.toString()),
                          onChanged: (value) {
                            setState(() {
                              noFruits[index] = !noFruits[index];
                              if (noFruits[index]) {
                                widget.profile.noFruits!
                                    .add(fruitsList[index].name.toString());
                              } else {
                                widget.profile.noFruits!
                                    .remove(fruitsList[index].name.toString());
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ],
                  );
                },
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
              ),
            ],
          ),
        );
      case 13:
        return Form(
          key: _formKeySteps[currentstep],
          child: Column(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)!.mark_the_cereals,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: cerealsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: CheckboxListTile(
                          value: noCereals[index],
                          activeColor: Colors.green,
                          selected: noCereals[index],
                          title: Text(cerealsList[index].name.toString()),
                          onChanged: (value) {
                            setState(() {
                              noCereals[index] = !noCereals[index];
                              if (noCereals[index]) {
                                widget.profile.noCereals!
                                    .add(cerealsList[index].name.toString());
                              } else {
                                widget.profile.noCereals!
                                    .remove(cerealsList[index].name.toString());
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ],
                  );
                },
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
              ),
            ],
          ),
        );
      case 14:
        return Form(
          key: _formKeySteps[currentstep],
          child: Column(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)!.mark_the_dairy,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: dairysList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: CheckboxListTile(
                          value: noDairys[index],
                          activeColor: Colors.green,
                          selected: noDairys[index],
                          title: Text(dairysList[index].name.toString()),
                          onChanged: (value) {
                            setState(() {
                              noDairys[index] = !noDairys[index];
                              if (noDairys[index]) {
                                widget.profile.noDairys!
                                    .add(dairysList[index].name.toString());
                              } else {
                                widget.profile.noDairys!
                                    .remove(dairysList[index].name.toString());
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ],
                  );
                },
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
              ),
            ],
          ),
        );
      case 15:
        return Form(
          key: _formKeySteps[currentstep],
          child: Column(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)!.mark_the_meats,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: meatsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: CheckboxListTile(
                          value: noMeats[index],
                          activeColor: Colors.green,
                          selected: noMeats[index],
                          title: Text(meatsList[index].name.toString()),
                          onChanged: (value) {
                            setState(() {
                              noMeats[index] = !noMeats[index];
                              if (noMeats[index]) {
                                widget.profile.noMeats!
                                    .add(meatsList[index].name.toString());
                              } else {
                                widget.profile.noMeats!
                                    .remove(meatsList[index].name.toString());
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ],
                  );
                },
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
              ),
            ],
          ),
        );
      case 16:
        var oneSec = const Duration(milliseconds: 1500);
        Timer.periodic(
          oneSec,
          (Timer timer) {
            if (_start >= 100) {
              if (mounted) {
                setState(() {
                  timer.cancel();
                });
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          Step3EnterEmail(profile: widget.profile),
                    ));
              }
            } else {
              if (mounted) {
                setState(() {
                  _start++;
                });
              }
            }
          },
        );
        return Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  AppLocalizations.of(context)!.data_processing,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.only(bottom: 40, top: 20),
                child: Text(
                  AppLocalizations.of(context)!.your_meal_plan_begin_calculated,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            CircularStepProgressIndicator(
              totalSteps: 100,
              currentStep: _start,
              stepSize: 1,
              selectedColor: Colors.green,
              unselectedColor: Colors.white,
              padding: 0,
              width: 150,
              height: 150,
              selectedStepSize: 10,
              roundedCap: (_, __) => true,
              child: Center(
                  child: Text("$_start%",
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ))),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  AppLocalizations.of(context)!.analyzing_the_data,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  void scrollToTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }
}
