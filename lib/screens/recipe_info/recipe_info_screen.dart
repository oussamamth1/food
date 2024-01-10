import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fitfood/api/api_key.dart';
import 'package:fitfood/models/diet.dart';
import 'package:fitfood/models/ingredient.dart';
import 'package:fitfood/models/nutrients.dart';
import 'package:fitfood/models/racipe.dart';
import 'package:fitfood/repo/diet_repo.dart';
import 'package:fitfood/services/validations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitfood/widgets/loading_widget.dart';
import '../random_recipe/widgets/recipe_info_success_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'bloc/recipe_info_bloc.dart';

class RecipeInfo extends StatefulWidget {
  final String id;
  const RecipeInfo({Key? key, required this.id}) : super(key: key);

  @override
  State<RecipeInfo> createState() => _RecipeInfoState();
}

class _RecipeInfoState extends State<RecipeInfo> {
  late final RecipeInfoBloc bloc;
  bool showFloadtinActionbutton = false;
  DateTime today = validations.convertDateTimeToDate(DateTime.now());
  Nutrient nutrient = Nutrient(
      bad: [], calories: '', carbs: '', fat: '', good: [], protein: '');
  Recipe? recette;
  Diet? currentDiet;
  bool tracked = false;
  bool showtracked = false;

  @override
  void initState() {
    bloc = BlocProvider.of<RecipeInfoBloc>(context);
    bloc.add(LoadRecipeInfo(widget.id));
    Timer(const Duration(seconds: 5), () async {
      Diet? currentDiett =
          await dietRepo.getByDay(today.toString().split(' ')[0]);
      if (currentDiett != null) {
        currentDiet = currentDiett;
      }
      if (currentDiet!.customBreakfast
              ?.where((element) => element.name == recette?.title)
              .isEmpty ==
          false) {
        tracked = true;
      }
      setState(() {
        showtracked = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        floatingActionButton: Visibility(
          visible: showtracked,
          child: FloatingActionButton.extended(
            heroTag: "Track",
            onPressed: !tracked
                ? () async {
                    double fateaten = currentDiet!.fatEaten +
                        double.parse(
                            nutrient.fat.substring(0, nutrient.fat.length - 1));
                    double proteineaten = currentDiet!.proteinEaten +
                        double.parse(nutrient.protein
                            .substring(0, nutrient.protein.length - 1));
                    double caloryaten = currentDiet!.caloryEaten +
                        double.parse(nutrient.calories
                            .substring(0, nutrient.calories.length - 1));
                    double carbseaten = currentDiet!.carbsEaten +
                        double.parse(nutrient.carbs
                            .substring(0, nutrient.carbs.length - 1));
                    Map data = {
                      "meal": "customBreakfast",
                      "data": Ingredient(
                          name: recette?.title,
                          fat: double.parse(nutrient.fat
                              .substring(0, nutrient.fat.length - 1)),
                          protein: double.parse(nutrient.protein
                              .substring(0, nutrient.protein.length - 1)),
                          calorie: double.parse(nutrient.calories
                              .substring(0, nutrient.calories.length - 1)),
                          carbohydrate: double.parse(nutrient.carbs
                              .substring(0, nutrient.carbs.length - 1)),
                          eaten: true,
                          servings: recette?.servings,
                          servingSize: "1 recipe",
                          type: "recipe"),
                      "day": currentDiet?.day,
                      "uid": currentDiet?.uid,
                      "idealCalory": currentDiet?.dailyCalory,
                      "idealCarbohydrate": currentDiet?.dailyCarbs,
                      "idealFat": currentDiet?.dailyFat,
                      "idealProtein": currentDiet?.dailyProtein,
                      "fatEaten": fateaten,
                      "proteinEaten": proteineaten,
                      "caloryEaten": caloryaten,
                      "carbsEaten": carbseaten,
                    };
                    var reponse = await updateDietCustom(
                        currentDiet!.day! + "_" + currentDiet!.uid!, data);
                    showSnackBar(
                        reponse['status'], context, reponse['message']);
                    Diet? currentDiettt =
                        await dietRepo.getByDay(today.toString().split(' ')[0]);
                    setState(() {
                      tracked = true;
                      if (currentDiettt != null) {
                        currentDiet = currentDiettt;
                      }
                    });
                  }
                : null,
            label: tracked
                ? Text(AppLocalizations.of(context)!.tracked)
                : Text(AppLocalizations.of(context)!.track),
            icon: const Icon(Icons.add_task_rounded),
            backgroundColor: tracked ? Colors.grey : Colors.green,
            //child: const Icon(Icons.add),
          ),
        ),
        backgroundColor: Colors.grey.shade200,
        body: BlocBuilder<RecipeInfoBloc, RecipeInfoState>(
          builder: (context, state) {
            if (state is RecipeInfoLoadState) {
              return const Center(child: LoadingWidget());
            } else if (state is RecipeInfoSuccesState) {
              nutrient = state.nutrient;
              recette = state.recipe;
              return RacipeInfoWidget(
                equipment: state.equipment,
                info: state.recipe,
                nutrient: state.nutrient,
                similarlist: state.similar,
              );
            } else if (state is RecipeInfoErrorState) {
              return Center(
                child: Text(AppLocalizations.of(context)!.error),
              );
            } else {
              return Center(
                child: Text(AppLocalizations.of(context)!.noting_happingng),
              );
            }
          },
        ),
      ),
    );
  }

  Future<Map> updateDietCustom(dietId, data) async {
    var pythonServer = await ApiKey().getSettingskeys('pythonServer');
    var pythonServerAuthKey =
        await ApiKey().getSettingskeys('pythonServerAuthKey');
    var url = '${pythonServer}api/diets/custom/$dietId';
    var dio = Dio();
    dio.options.baseUrl = url;
    dio.options.connectTimeout = 50000; //50s
    dio.options.receiveTimeout = 5000;
    try {
      var response = await dio.put(
        url,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Basic $pythonServerAuthKey',
          },
        ),
      );
      return {
        "status": response.data['status'],
        "message": response.data['message']
      };
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {
        "status": "error",
        "message": AppLocalizations.of(context)!.error
      };
    }
  }

  showSnackBar(String status, BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor:
          status == "ok" ? Colors.green.shade100 : Colors.red.shade100,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(status == "ok" ? Icons.check : Icons.warning_amber_rounded,
                color: status == "ok" ? Colors.green : Colors.red, size: 30),
            const SizedBox(width: 20),
            Expanded(
              child: Text(text, style: const TextStyle(color: Colors.black)),
            )
          ],
        ),
      ),
    ));
  }
}
