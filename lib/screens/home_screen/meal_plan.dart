import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fitfood/api/api_key.dart';
import 'package:fitfood/models/diet.dart';
import 'package:fitfood/models/ingredient.dart';
import 'package:fitfood/models/nutrients.dart';
import 'package:fitfood/models/profile.dart';
import 'package:fitfood/models/racipe.dart';
import 'package:fitfood/repo/diet_repo.dart';
import 'package:fitfood/screens/recipe_info/bloc/recipe_info_bloc.dart';
import 'package:fitfood/screens/recipe_info/recipe_info_screen.dart';
import 'package:fitfood/services/preferences.dart';
import 'package:fitfood/services/validations.dart';
import 'package:fitfood/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MealPlan extends StatefulWidget {
  const MealPlan({Key? key}) : super(key: key);

  @override
  State<MealPlan> createState() => _MealPlanState();
}

class _MealPlanState extends State<MealPlan> {
  Profile profile = Profile();
  DateTime today = validations.convertDateTimeToDate(DateTime.now());
  DateTime todayDate = validations.convertDateTimeToDate(DateTime.now());
  Diet currentDiet = Diet();
  bool recipes = false;
  bool ingredients = true;
  int countDiets = 1;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 10), () async {
      Profile? pr = await preferences.getUser();
      if (pr != null) {
        int count = await dietRepo.getCountById(pr.uid!);
        setState(() {
          profile = pr;
          countDiets = count;
        });
      }
      Diet? diet = await dietRepo.getByDay(today.toString().split(' ')[0]);
      if (diet != null) {
        setState(() {
          currentDiet = diet;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (countDiets == 0 && mounted) {
      Timer.periodic(const Duration(seconds: 30), (Timer tt) async {
        if (countDiets == 0) {
          if (mounted) {
            setState(() {
              tt.cancel();
            });
          }
        }
        Diet? diet = await dietRepo.getByDay(today.toString().split(' ')[0]);
        if (mounted) {
          setState(() {
            currentDiet = diet ?? Diet();
            if (diet != null) {
              countDiets = 1;
            }
          });
        }
      });
    }
    final double width = MediaQuery.of(context).size.width;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          bottom: PreferredSize(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: const Icon(
                              CupertinoIcons.arrowtriangle_left_circle),
                          onPressed: () async {
                            setState(() {
                              today = today.add(const Duration(days: -1));
                            });
                            Diet? diet = await dietRepo
                                .getByDay(today.toString().split(' ')[0]);
                            setState(() {
                              currentDiet = diet ?? Diet();
                              if (diet != null) {
                                countDiets = 1;
                              }
                            });
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
                            setState(() {
                              today = day;
                              currentDiet = diet ?? Diet();
                              if (diet != null) {
                                countDiets = 1;
                              }
                            });
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today, size: 20),
                            Text(today == todayDate
                                ? " " + AppLocalizations.of(context)!.today
                                : today ==
                                        todayDate.add(const Duration(days: -1))
                                    ? " " +
                                        AppLocalizations.of(context)!.yesterday
                                    : today ==
                                            todayDate
                                                .add(const Duration(days: 1))
                                        ? " " +
                                            AppLocalizations.of(context)!
                                                .tomorrow
                                        : " ${DateFormat("EEEE").format(today)}, ${DateFormat("d MMMM").format(today)}"),
                          ],
                        ),
                      ),
                      IconButton(
                          icon: const Icon(
                              CupertinoIcons.arrowtriangle_right_circle),
                          onPressed: () async {
                            setState(() {
                              today = today.add(const Duration(days: 1));
                            });
                            Diet? diet = await dietRepo
                                .getByDay(today.toString().split(' ')[0]);
                            setState(() {
                              currentDiet = diet ?? Diet();
                              if (diet != null) {
                                countDiets = 1;
                              }
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: width / 2 - 20,
                        decoration: BoxDecoration(
                            color:
                                !recipes ? Colors.grey.shade200 : Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(10))),
                        child: ListTile(
                          dense: true,
                          selectedColor: Colors.green,
                          title: Text(AppLocalizations.of(context)!.ingredients,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20)),
                          selected: !recipes,
                          onTap: () {
                            setState(() {
                              recipes = false;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: width / 2 - 20,
                        decoration: BoxDecoration(
                            color:
                                recipes ? Colors.grey.shade200 : Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(10))),
                        child: ListTile(
                          dense: true,
                          selectedColor: Colors.green,
                          title: Text(AppLocalizations.of(context)!.recipes,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20)),
                          selected: recipes,
                          onTap: () {
                            setState(() {
                              recipes = true;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
              preferredSize: const Size.fromHeight(100)),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.grey.shade200,
          title: Text(AppLocalizations.of(context)!.meal_Plan,
              style: styleTitle17),
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
              if (pr != null) {
                int count = await dietRepo.getCountById(pr.uid!);
                setState(() {
                  profile = pr;
                  countDiets = count;
                });
              }
              setState(() {
                if (diet != null) {
                  setState(() {
                    currentDiet = diet;
                  });
                }
              });
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (countDiets == 0)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.meal_preparing,
                            style: styleTitle15, textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorRed,
                        )
                      ],
                    ),
                  )
                else if (currentDiet.breakfast == null &&
                    currentDiet.lunch == null &&
                    currentDiet.dinner == null &&
                    currentDiet.snack1 == null &&
                    currentDiet.snack2 == null)
                  Center(
                      child: Text(
                          AppLocalizations.of(context)!.no_meal_plan_for +
                              " ${DateFormat("d MMMM").format(today)}",
                          style: styleTitle15))
                else if (recipes)
                  Center(
                      child: Text(
                          AppLocalizations.of(context)!
                              .remember_to_use_the_same_ingredient_portions,
                          style: styleTitle15)),
                const SizedBox(height: 10),
                if (currentDiet.breakfast != null &&
                    currentDiet.breakfast!.isNotEmpty)
                  getIngredientsRecipes(
                      width,
                      AppLocalizations.of(context)!.breakfast,
                      currentDiet.breakfast!,
                      currentDiet.breakfastRecipe!,
                      "breakfast"),
                if (currentDiet.snack1 != null &&
                    currentDiet.snack1!.isNotEmpty)
                  getIngredientsRecipes(
                      width,
                      AppLocalizations.of(context)!.snack1,
                      currentDiet.snack1!,
                      currentDiet.snack1Recipe!,
                      "snack1"),
                if (currentDiet.lunch != null && currentDiet.lunch!.isNotEmpty)
                  getIngredientsRecipes(
                      width,
                      AppLocalizations.of(context)!.lunch,
                      currentDiet.lunch!,
                      currentDiet.lunchRecipe!,
                      "lunch"),
                if (currentDiet.snack2 != null &&
                    currentDiet.snack2!.isNotEmpty)
                  getIngredientsRecipes(
                      width,
                      AppLocalizations.of(context)!.snack2,
                      currentDiet.snack2!,
                      currentDiet.snack2Recipe!,
                      "snack2"),
                if (currentDiet.dinner != null &&
                    currentDiet.dinner!.isNotEmpty)
                  getIngredientsRecipes(
                      width,
                      AppLocalizations.of(context)!.dinner,
                      currentDiet.dinner!,
                      currentDiet.dinnerRecipe!,
                      "dinner"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getIngredientsRecipes(double width, String text,
      List<Ingredient> ingList, Recipe recipeList, String fieldname) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: styleTitle177),
        SizedBox(
          height: recipes ? 250 : 210,
          child: recipes
              ? Container(
                  width: width - 40,
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => RecipeInfoBloc(),
                                child: RecipeInfo(
                                  id: "${recipeList.id}",
                                ),
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.bottomStart,
                          children: [
                            Container(
                                height: 175,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(10)),
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            recipeList.image!),
                                        fit: BoxFit.cover))),
                            Container(
                                padding: const EdgeInsets.all(10),
                                width: width - 40,
                                color: Colors.black38,
                                child: Text(recipeList.title!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: styleTitle14)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (!recipeList.eaten!)
                              InkWell(
                                onTap: () async {
                                  String ingredientsName = "";
                                  ingList
                                      .map((e) => {
                                            ingredientsName = ingredientsName +
                                                "," +
                                                e.name.toString().substring(
                                                    0,
                                                    e.name
                                                        .toString()
                                                        .indexOf(','))
                                          })
                                      .toString();
                                  Map data = {
                                    "meal": fieldname + "Recipe",
                                    "data": ingredientsName.substring(1),
                                    "index": 0,
                                    "type": "recipe"
                                  };
                                  Map reponse = await updateDiet(
                                      currentDiet.day! + "_" + currentDiet.uid!,
                                      data);
                                  showSnackBar(reponse['status'], context,
                                      reponse['message']);
                                  if (reponse['status'] == "ok") {
                                    Timer(const Duration(seconds: 1), () async {
                                      Diet? diet = await dietRepo.getByDay(
                                          today.toString().split(' ')[0]);
                                      if (diet != null) {
                                        setState(() {
                                          currentDiet = diet;
                                        });
                                      }
                                    });
                                  }
                                },
                                child: Column(
                                  children: [
                                    const Icon(Icons.swap_horiz_outlined),
                                    Text(AppLocalizations.of(context)!.swap)
                                  ],
                                ),
                              ),
                            InkWell(
                              onTap: () async {
                                const bASEURL =
                                    'https://api.spoonacular.com/recipes/';
                                const nUTRITIONPATH = '/nutritionWidget.json?';
                                var key = await ApiKey()
                                    .getSettingskeys('spooncularkeys');
                                var nutritionUrl = bASEURL +
                                    recipeList.id.toString() +
                                    nUTRITIONPATH +
                                    '&apiKey=' +
                                    key;
                                var dio = Dio();
                                final response = await dio.get(nutritionUrl);
                                Nutrient nutrients =
                                    Nutrient.fromJson(response.data);
                                Map data = {
                                  "meal": fieldname + "Recipe",
                                  //"data": !recipeList.eaten!,
                                  "data": {
                                    "eaten": !recipeList.eaten!,
                                    "fat": nutrients.fat
                                        .substring(0, nutrients.fat.length - 1),
                                    "protein": nutrients.protein.substring(
                                        0, nutrients.protein.length - 1),
                                    "calorie": nutrients.calories.substring(
                                        0, nutrients.calories.length - 1),
                                    "carbohydrate": nutrients.carbs.substring(
                                        0, nutrients.carbs.length - 1),
                                  },
                                  "index": 0,
                                  "type": "recipe"
                                };
                                Map reponse = await updateDietEaten(
                                    currentDiet.day! + "_" + currentDiet.uid!,
                                    data);
                                showSnackBar(reponse['status'], context,
                                    reponse['message']);
                                if (reponse['status'] == "ok") {
                                  Timer(const Duration(seconds: 1), () async {
                                    Diet? diet = await dietRepo.getByDay(
                                        today.toString().split(' ')[0]);
                                    if (diet != null) {
                                      setState(() {
                                        currentDiet = diet;
                                      });
                                    }
                                  });
                                }
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.add_task_rounded,
                                    color: recipeList.eaten!
                                        ? Colors.green
                                        : Colors.black87,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.track,
                                    style: TextStyle(
                                        color: recipeList.eaten!
                                            ? Colors.green
                                            : Colors.black87),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  // store this controller in a State to save the carousel scroll position
                  children: [
                    ...ingList.map((item) {
                      return Container(
                        width: 170,
                        margin: const EdgeInsets.only(top: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade400,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(item.name.toString(),
                                          style: styleStylo,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center)),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        item.category.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                      )),
                                ],
                              ),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => Material(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 20),
                                          Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Text(
                                              item.name.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child:
                                                  Text("(${item.category})")),
                                          const SizedBox(height: 40),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                        .calories +
                                                    ": ${item.calorie!.toStringAsFixed(1)}k",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                        .protein +
                                                    ": ${item.protein!.toStringAsFixed(1)}g",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                        .fat +
                                                    ": ${item.fat!.toStringAsFixed(1)}g",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                        .carbohydrates +
                                                    ": ${item.carbohydrate!.toStringAsFixed(1)}g",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                        .calcium +
                                                    ": ${item.calcium!.toStringAsFixed(1)}k",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                        .dietary_Fiber +
                                                    ": ${item.dietaryFiber!.toStringAsFixed(1)}g",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                        .iron +
                                                    ": ${item.iron!.toStringAsFixed(1)}k",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                        .sodium +
                                                    ": ${item.sodium!.toStringAsFixed(1)}g",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                        .vitamin_A +
                                                    ": ${item.vitaminA!.toStringAsFixed(1)}k",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                        .vitamin_C +
                                                    ": ${item.vitaminC!.toStringAsFixed(1)}g",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                        .vitamin_B1 +
                                                    ": ${item.vitaminB1!.toStringAsFixed(1)}k",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                        .vitamin_B2 +
                                                    ": ${item.vitaminB2!.toStringAsFixed(1)}g",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  if (!item.eaten!)
                                    InkWell(
                                      onTap: () async {
                                        final index = ingList.indexWhere(
                                            (element) =>
                                                element.name == item.name);
                                        Map data = {
                                          "meal": fieldname,
                                          "data": json.encode(item).replaceAll(
                                              RegExp(r'null'), '"null"'),
                                          "index": index,
                                          "type": "ingredient"
                                        };
                                        Map reponse = await updateDiet(
                                            currentDiet.day! +
                                                "_" +
                                                currentDiet.uid!,
                                            data);
                                        showSnackBar(reponse['status'], context,
                                            reponse['message']);
                                        if (reponse['status'] == "ok") {
                                          Timer(const Duration(seconds: 1),
                                              () async {
                                            Diet? diet =
                                                await dietRepo.getByDay(today
                                                    .toString()
                                                    .split(' ')[0]);
                                            if (diet != null) {
                                              setState(() {
                                                currentDiet = diet;
                                              });
                                            }
                                          });
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          const Icon(Icons.swap_horiz_outlined),
                                          Text(AppLocalizations.of(context)!
                                              .swap)
                                        ],
                                      ),
                                    ),
                                  InkWell(
                                    onTap: () async {
                                      final index = ingList.indexWhere(
                                          (element) =>
                                              element.name == item.name);
                                      Map data = {
                                        "meal": fieldname,
                                        "data": !item.eaten!,
                                        "index": index,
                                        "type": "ingredient"
                                      };
                                      Map reponse = await updateDietEaten(
                                          currentDiet.day! +
                                              "_" +
                                              currentDiet.uid!,
                                          data);
                                      showSnackBar(reponse['status'], context,
                                          reponse['message']);
                                      if (reponse['status'] == "ok") {
                                        Timer(const Duration(seconds: 1),
                                            () async {
                                          Diet? diet = await dietRepo.getByDay(
                                              today.toString().split(' ')[0]);
                                          if (diet != null) {
                                            setState(() {
                                              currentDiet = diet;
                                            });
                                          }
                                        });
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.add_task_rounded,
                                          color: item.eaten!
                                              ? Colors.green
                                              : Colors.black87,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!.track,
                                          style: TextStyle(
                                              color: item.eaten!
                                                  ? Colors.green
                                                  : Colors.black87),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    })
                  ],
                ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Future<Map> updateDiet(dietId, data) async {
    var pythonServer = await ApiKey().getSettingskeys('pythonServer');
    var pythonServerAuthKey =
        await ApiKey().getSettingskeys('pythonServerAuthKey');
    var url = '${pythonServer}api/diets/$dietId';
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

  Future<Map> updateDietEaten(dietId, data) async {
    var pythonServer = await ApiKey().getSettingskeys('pythonServer');
    var pythonServerAuthKey =
        await ApiKey().getSettingskeys('pythonServerAuthKey');
    var url = '${pythonServer}api/diets/eaten/$dietId';
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
