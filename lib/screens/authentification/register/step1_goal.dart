import 'dart:async';

import 'package:fitfood/models/ingredient.dart';
import 'package:fitfood/models/kitchen.dart';
import 'package:fitfood/models/profile.dart';
import 'package:fitfood/repo/ingredient_repo.dart';
import 'package:fitfood/repo/kitchen_repo.dart';
import 'package:fitfood/screens/authentification/register/step2_personal_informations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Step1Goal extends StatefulWidget {
  const Step1Goal({Key? key}) : super(key: key);

  @override
  State<Step1Goal> createState() => _Step1GoalState();
}

class _Step1GoalState extends State<Step1Goal> {
  final ScrollController _scrollController = ScrollController();
  bool isChecked1 = false;
  bool isChecked2 = false;
  Profile profile = Profile();
  List<Ingredient> sampleIngredients = [];
  List<Kitchen> kitchens = [];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 10), () async {
      List<Ingredient>? sampleIngredientsl =
          await ingredientRepo.getAllIngredients('sample_ingredients');
      List<Kitchen>? kitchensl = await kitchenRepo.getAllKitchens();
      if (sampleIngredientsl != null && kitchensl != null) {
        setState(() {
          sampleIngredients = sampleIngredientsl;
          kitchens = kitchensl;
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
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: const BackButton(color: Colors.black),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.register,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    child: Text(
                      AppLocalizations.of(context)!.what_is_your_Goal,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    color: Colors.red.shade50,
                    width: double.infinity,
                    child: Stack(children: <Widget>[
                      const Image(
                        width: 200,
                        image: AssetImage('assets/images/gain_weight.png'),
                      ),
                      Container(
                        height: 200,
                        padding: const EdgeInsets.only(right: 10),
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red, // background
                              onPrimary: Colors.white, // foreground
                              onSurface: Colors.red,
                            ),
                            onPressed: () async {
                              if (isChecked1) {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                setState(() {
                                  profile.objective = 1;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        Step2Gender(
                                            profile: profile,
                                            sampleIngredients:
                                                sampleIngredients,
                                            kitchens: kitchens),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.red.shade100,
                                  content: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.warning_amber_rounded,
                                            color: Colors.red, size: 30),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .to_continue_please_accept_our_terms,
                                              style: const TextStyle(
                                                  color: Colors.black)),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn,
                                );
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.gain_Weight,
                              style: const TextStyle(fontSize: 20),
                            )),
                      )
                    ]),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  Container(
                    color: Colors.green.shade50,
                    width: double.infinity,
                    child: Stack(children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        child: const Image(
                          width: 200,
                          image: AssetImage('assets/images/lose_weight.png'),
                        ),
                      ),
                      Container(
                        height: 200,
                        padding: const EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green, // background
                              onPrimary: Colors.white, // foreground
                              onSurface: Colors.green,
                            ),
                            onPressed: () async {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              if (isChecked1) {
                                setState(() {
                                  profile.objective = 0;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        Step2Gender(
                                            profile: profile,
                                            sampleIngredients:
                                                sampleIngredients,
                                            kitchens: kitchens),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.red.shade100,
                                  content: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.warning_amber_rounded,
                                            color: Colors.red, size: 30),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .to_continue_please_accept_our_terms,
                                              style: const TextStyle(
                                                  color: Colors.black)),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 750),
                                  curve: Curves.fastOutSlowIn,
                                );
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.lose_Weight,
                              style: const TextStyle(fontSize: 20),
                            )),
                      )
                    ]),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  Container(
                    color: Colors.blue.shade50,
                    width: double.infinity,
                    child: Stack(children: <Widget>[
                      const Image(
                        width: 200,
                        image: AssetImage('assets/images/maintain_weight.png'),
                      ),
                      Container(
                        height: 200,
                        padding: const EdgeInsets.only(right: 10),
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // background
                              onPrimary: Colors.white, // foreground
                              onSurface: Colors.blue,
                            ),
                            onPressed: () async {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              if (isChecked1) {
                                setState(() {
                                  profile.objective = 2;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        Step2Gender(
                                            profile: profile,
                                            sampleIngredients:
                                                sampleIngredients,
                                            kitchens: kitchens),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.red.shade100,
                                  content: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.warning_amber_rounded,
                                            color: Colors.red, size: 30),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .to_continue_please_accept_our_terms,
                                              style: const TextStyle(
                                                  color: Colors.black)),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn,
                                );
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.maintain_Weight,
                              style: const TextStyle(fontSize: 20),
                            )),
                      )
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: CheckboxListTile(
                      value: isChecked1,
                      onChanged: (value) {
                        setState(() {
                          isChecked1 = value!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                          AppLocalizations.of(context)!.by_continuing_I_agree),
                    ),
                  ),
                  CheckboxListTile(
                    value: isChecked2,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked2 = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(AppLocalizations.of(context)!
                        .i_would_like_to_receive_updates),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 20),
                      child: Text(AppLocalizations.of(context)!
                          .we_recommend_to_consult_your_physician))
                ],
              ),
            ),
          )),
    );
  }
}
