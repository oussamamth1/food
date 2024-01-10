import 'dart:convert';

import 'package:elastic_client/elastic_client.dart';
import 'package:fitfood/api/api_key.dart';
import 'package:fitfood/models/diet.dart';
import 'package:fitfood/models/profile.dart';
import 'package:fitfood/services/preferences.dart';
import 'package:flutter/foundation.dart';

class DietRepo {
  var elasticSearchUrl = "";
  var elasticSearchPassword = "";
  var elasticSearchUsername = "";

  initt() async {
    elasticSearchUrl = await ApiKey().getSettingskeys('elasticSearchUrl');
    elasticSearchPassword =
        await ApiKey().getSettingskeys('elasticSearchPassword');
    elasticSearchUsername =
        await ApiKey().getSettingskeys('elasticSearchUsername');
  }

  Future<List<Diet>> getAllById(String uid) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final searchResult = await _client.search(
          index: 'diets',
          query: {
            "term": {
              "uid": {"value": uid}
            }
          },
          source: true);
      List<Diet> dietList = [];
      Diet diet = Diet();
      if (kDebugMode) {
        print(
            "----------- getAllById Found ${searchResult.totalCount} Diet ----------");
      }

      // return searchResult.toMap();
      for (final iter in searchResult.hits) {
        Map<dynamic, dynamic> currDoc = iter.doc;
        dietList.add(diet.fromJson(currDoc));
      }

      await _transport.close();

      if (searchResult.totalCount <= 0) {
        return [];
      } else {
        return dietList;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<int> getCountById(String uid) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final searchResult = await _client.count(index: 'diets', query: {
        "term": {
          "uid": {"value": uid}
        }
      });

      if (kDebugMode) {
        print("----------- getCountById Found $searchResult Diet ----------");
      }

      await _transport.close();

      return searchResult;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return 0;
    }
  }

  Future<Diet?> getByDay(String day) async {
    try {
      await initt();
      String uid = (await preferences.getStringValue('uid'))!;
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final searchResult = await _client.search(
          index: 'diets',
          query: {
            "bool": {
              "must": [
                {
                  "term": {
                    "day": {"value": day}
                  }
                },
                {
                  "term": {
                    "uid": {"value": uid}
                  }
                }
              ]
            }
          },
          source: true);
      Diet diet = Diet();
      if (kDebugMode) {
        print(
            "----------- getByDay Found ${searchResult.totalCount} Diet ----------");
      }

      for (final iter in searchResult.hits) {
        Map<dynamic, dynamic> currDoc = iter.doc;
        diet = diet.fromJson(currDoc);
      }

      await _transport.close();

      if (searchResult.totalCount <= 0) {
        return null;
      } else {
        return diet;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<bool> updateDietById(String id, Diet diet) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final updateResult =
          await _client.updateDoc(index: 'diets', type: '_doc', id: id, doc: {
        'uid': diet.uid,
        'day': diet.day,
        'breakfast': json.encode(diet.breakfast),
        'dinner': json.encode(diet.dinner),
        'lunch': json.encode(diet.lunch),
        'snack1': json.encode(diet.snack1),
        'snack2': json.encode(diet.snack2),
        'dailyCalory': diet.dailyCalory,
        'dailyCarbs': diet.dailyCarbs,
        'dailyFat': diet.dailyFat,
        'dailyProtein': diet.dailyProtein,
        'fatEaten': diet.fatEaten,
        'proteinEaten': diet.proteinEaten,
        'caloryEaten': diet.caloryEaten,
        'carbsEaten': diet.carbsEaten,
        'water': diet.water,
        'createdAt': diet.createdAt,
        'updatedAt': diet.updatedAt,
      });

      await _transport.close();

      if (!updateResult) {
        if (kDebugMode) {
          print('-- DIET NOT UPDATED --');
        }
        return false;
      } else {
        if (kDebugMode) {
          print('-- DIET UPDATED --');
        }
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> createDiet(Diet diet) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final updateResult = await _client.updateDoc(
        index: 'diets',
        type: '_doc',
        id: diet.day! + "_" + diet.uid!, // Ex: 2022-05-04_Ffrgspfn5sZaa54dz6z
        doc: {
          'uid': diet.uid,
          'day': diet.day,
          'breakfast': json.encode(diet.breakfast),
          'dinner': json.encode(diet.dinner),
          'lunch': json.encode(diet.lunch),
          'snack1': json.encode(diet.snack1),
          'snack2': json.encode(diet.snack2),
          'dailyCalory': diet.dailyCalory,
          'dailyCarbs': diet.dailyCarbs,
          'dailyFat': diet.dailyFat,
          'dailyProtein': diet.dailyProtein,
          'fatEaten': diet.fatEaten,
          'proteinEaten': diet.proteinEaten,
          'caloryEaten': diet.caloryEaten,
          'carbsEaten': diet.carbsEaten,
          'water': diet.water,
          'createdAt': diet.createdAt,
          'updatedAt': diet.updatedAt,
        },
      );

      await _transport.close();

      if (!updateResult) {
        if (kDebugMode) {
          print('-- DIET NOT CREATED --');
        }
        return false;
      } else {
        if (kDebugMode) {
          print('-- DIET CREATED --');
        }
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> updateDietWater(
      String day, double water, Profile profile) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);

      final searchResult = await _client.search(
          index: 'diets',
          query: {
            "bool": {
              "must": [
                {
                  "term": {
                    "day": {"value": day}
                  }
                },
                {
                  "term": {
                    "uid": {"value": profile.uid}
                  }
                }
              ]
            }
          },
          source: true);
      if (kDebugMode) {
        print(
            "----------- DIET WATER Found ${searchResult.totalCount} ----------");
      }

      Map<String, dynamic> diet = {
        "uid": profile.uid,
        "day": day,
        "breakfast": "[]",
        "breakfastRecipe": "{}",
        "customBreakfast": "[]",
        "dinner": "[]",
        "dinnerRecipe": "{}",
        "customDinner": "[]",
        "lunch": "[]",
        "lunchRecipe": "{}",
        "customLunch": "[]",
        "snack1": "[]",
        "snack1Recipe": "{}",
        "customSnack1": "[]",
        "snack2": "[]",
        "snack2Recipe": "{}",
        "customSnack2": "[]",
        "dailyCalory": profile.idealCalory,
        "dailyCarbs": profile.idealCarbohydrate,
        "dailyFat": profile.idealFat,
        "dailyProtein": profile.idealProtein,
        "fatEaten": 0.0,
        "proteinEaten": 0.0,
        "caloryEaten": 0.0,
        "carbsEaten": 0.0,
        "water": water,
        "createdAt": DateTime.now().millisecondsSinceEpoch,
        "updatedAt": DateTime.now().millisecondsSinceEpoch
      };
      if (searchResult.totalCount > 0) {
        diet = searchResult.hits[0].toMap()['doc'];
        diet['water'] = water;
      }

      final updateResult = await _client.updateDoc(
          index: 'diets',
          type: '_doc',
          id: day + "_" + profile.uid!, // Ex: 2022-05-04_Ffrgspfn5sZaa54dz6z
          doc: diet);

      await _transport.close();

      if (!updateResult) {
        if (kDebugMode) {
          print('-- DIET WATER NOT UPDATED --');
        }
        return false;
      } else {
        if (kDebugMode) {
          print('-- DIET WATER UPDATED --');
        }
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}

DietRepo dietRepo = DietRepo();
