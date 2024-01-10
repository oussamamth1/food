import 'dart:convert';

import 'package:fitfood/models/ingredient.dart';
import 'package:fitfood/models/racipe.dart';

class Diet {
  String? uid;
  String? day;
  List<Ingredient>? breakfast;
  Recipe? breakfastRecipe;
  List<Ingredient>? customBreakfast;
  List<Ingredient>? dinner;
  Recipe? dinnerRecipe;
  List<Ingredient>? customDinner;
  List<Ingredient>? lunch;
  Recipe? lunchRecipe;
  List<Ingredient>? customLunch;
  List<Ingredient>? snack1;
  Recipe? snack1Recipe;
  List<Ingredient>? customSnack1;
  List<Ingredient>? snack2;
  Recipe? snack2Recipe;
  List<Ingredient>? customSnack2;
  double? dailyCalory;
  double? dailyCarbs;
  double? dailyFat;
  double? dailyProtein;
  double fatEaten;
  double proteinEaten;
  double caloryEaten;
  double carbsEaten;
  double water;
  int? createdAt;
  int? updatedAt;

  Diet(
      {this.uid,
      this.day,
      this.breakfast,
      this.breakfastRecipe,
      this.customBreakfast,
      this.dinner,
      this.dinnerRecipe,
      this.customDinner,
      this.lunch,
      this.lunchRecipe,
      this.customLunch,
      this.snack1,
      this.snack1Recipe,
      this.customSnack1,
      this.snack2,
      this.snack2Recipe,
      this.customSnack2,
      this.dailyCalory,
      this.dailyCarbs,
      this.dailyFat,
      this.dailyProtein,
      this.fatEaten = 0.0,
      this.proteinEaten = 0.0,
      this.caloryEaten = 0.0,
      this.carbsEaten = 0.0,
      this.water = 0.0,
      this.createdAt,
      this.updatedAt});

  Diet fromJson(jsons) {
    return Diet(
      uid: jsons['uid'],
      day: jsons['day'],
      breakfast: listIngredient(
          json.decode(jsons['breakfast'].toString().replaceAll("None", "0.0"))),
      breakfastRecipe: jsons['breakfastRecipe'].length > 10
          ? Recipe.fromJson(json.decode(
              jsons['breakfastRecipe'].toString().replaceAll("None", "0.0")))
          : null,
      customBreakfast: listIngredient(json.decode(
              jsons['customBreakfast'].toString().replaceAll("None", "0.0"))),
      dinner: listIngredient(
          json.decode(jsons['dinner'].toString().replaceAll("None", "0.0"))),
      dinnerRecipe: jsons['dinnerRecipe'].length > 10
          ? Recipe.fromJson(json.decode(
              jsons['dinnerRecipe'].toString().replaceAll("None", "0.0")))
          : null,
      customDinner: listIngredient(json
          .decode(jsons['customDinner'].toString().replaceAll("None", "0.0"))),
      lunch: listIngredient(
          json.decode(jsons['lunch'].toString().replaceAll("None", "0.0"))),
      lunchRecipe: jsons['lunchRecipe'].length > 10
          ? Recipe.fromJson(json.decode(
              jsons['lunchRecipe'].toString().replaceAll("None", "0.0")))
          : null,
      customLunch: listIngredient(json
          .decode(jsons['customLunch'].toString().replaceAll("None", "0.0"))),
      snack1: listIngredient(
          json.decode(jsons['snack1'].toString().replaceAll("None", "0.0"))),
      snack1Recipe: jsons['snack1Recipe'].length > 10
          ? Recipe.fromJson(json.decode(
              jsons['snack1Recipe'].toString().replaceAll("None", "0.0")))
          : null,
      customSnack1: listIngredient(json
          .decode(jsons['customSnack1'].toString().replaceAll("None", "0.0"))),
      snack2: listIngredient(
          json.decode(jsons['snack2'].toString().replaceAll("None", "0.0"))),
      snack2Recipe: jsons['snack2Recipe'].length > 10
          ? Recipe.fromJson(json.decode(
              jsons['snack2Recipe'].toString().replaceAll("None", "0.0")))
          : null,
      customSnack2: listIngredient(json
          .decode(jsons['customSnack2'].toString().replaceAll("None", "0.0"))),
      dailyCalory: double.parse(jsons['dailyCalory'].toString()),
      dailyCarbs: double.parse(jsons['dailyCarbs'].toString()),
      dailyFat: double.parse(jsons['dailyFat'].toString()),
      dailyProtein: double.parse(jsons['dailyProtein'].toString()),
      fatEaten: double.parse(jsons['fatEaten'].toString()),
      proteinEaten: double.parse(jsons['proteinEaten'].toString()),
      caloryEaten: double.parse(jsons['caloryEaten'].toString()),
      carbsEaten: double.parse(jsons['carbsEaten'].toString()),
      water: double.parse(jsons['water'].toString()),
      createdAt: int.parse(jsons['createdAt'].toString()),
      updatedAt: int.parse(jsons['updatedAt'].toString()),
    );
  }

  toJson() => {
        'uid': uid,
        'day': day,
        'breakfast': json.encode(breakfast),
        'breakfastRecipe': json.encode(breakfastRecipe),
        'customBreakfast': json.encode(customBreakfast),
        'dinner': json.encode(dinner),
        'dinnerRecipe': json.encode(dinnerRecipe),
        'customDinner': json.encode(customDinner),
        'lunch': json.encode(lunch),
        'lunchRecipe': json.encode(lunchRecipe),
        'customLunch': json.encode(customLunch),
        'snack1': json.encode(snack1),
        'snack1Recipe': json.encode(snack1Recipe),
        'customSnack1': json.encode(customSnack1),
        'snack2': json.encode(snack2),
        'snack2Recipe': json.encode(snack2Recipe),
        'customSnack2': json.encode(customSnack2),
        'dailyCalory': dailyCalory,
        'dailyCarbs': dailyCarbs,
        'dailyFat': dailyFat,
        'dailyProtein': dailyProtein,
        'fatEaten': fatEaten,
        'proteinEaten': proteinEaten,
        'caloryEaten': caloryEaten,
        'carbsEaten': carbsEaten,
        'water': water,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  @override
  String toString() {
    return "uid: $uid day: $day dailyCalory: $dailyCalory caloryEaten: $caloryEaten  breakfast: $breakfast snack1 $snack1 lunch $lunch dinner $dinner|";
  }

  List<Ingredient>? listIngredient(jsons) {
    List<Ingredient> ling = [];
    for (var item in jsons) {
      ling.add(Ingredient.fromJson(item));
    }
    return ling.isNotEmpty ? ling : null;
  }
}
