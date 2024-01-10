import 'package:elastic_client/elastic_client.dart';
import 'package:fitfood/api/api_key.dart';
import 'package:fitfood/models/profile.dart';
import 'package:fitfood/services/preferences.dart';
import 'package:flutter/foundation.dart';

class UserRepo {
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

  Future<Profile?> getUserById(String uid) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final searchResult = await _client.search(
          index: 'plans',
          query: {
            "term": {
              "uid": {
                "value": uid
              }
            }
          },
          source: true);
      final searchResultUser = await _client.search(
          index: 'users',
          query: {
            "term": {
              "uid": {
                "value": uid
              }
            }
          },
          source: true);
      if (kDebugMode) {
        print(
            "----------- getUserById Found ${searchResult.totalCount} ----------");
      }

      await _transport.close();

      if (searchResult.totalCount <= 0) {
        if (kDebugMode) {
          print('-- USER NOT FOUND BY ID --');
        }
        return null;
      } else {
        Profile profile = Profile.fromJson(searchResult.hits[0].doc);
        profile.name = searchResultUser.hits[0].doc['name'];
        profile.gender = searchResultUser.hits[0].doc['gender'];
        return profile;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<Profile?> getUserByEmail(String email) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final searchResult = await _client.search(
          index: 'plans',
          query: {
            "match": {"email": email}
          },
          source: true);
      final searchResultUser = await _client.search(
          index: 'users',
          query: {
            "match": {"email": email}
          },
          source: true);
      if (kDebugMode) {
        print(
            "----------- getUserByEmail Found ${searchResult.totalCount} ----------");
      }

      await _transport.close();

      if (searchResult.totalCount <= 0) {
        if (kDebugMode) {
          print('-- USER NOT FOUND BY EMAIL --');
        }
        return null;
      } else {
        Profile profile = Profile.fromJson(searchResult.hits[0].doc);
        profile.name = searchResultUser.hits[0].doc['name'];
        profile.gender = searchResultUser.hits[0].doc['gender'];
        return profile;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<bool> updateUserById(String uid, Profile profile) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final updateResult =
          await _client.updateDoc(index: 'plans', type: '_doc', id: uid, doc: {
        'bodyType': profile.bodyType,
        'allergies': profile.allergies,
        'startingWeight': profile.startingWeight,
        'noVegetables': profile.noVegetables,
        'noMeats': profile.noMeats,
        'noFruits': profile.noFruits,
        'noDairys': profile.noDairys,
        'idealProtein': profile.idealProtein,
        'dateEnd': profile.dateEnd,
        'units': profile.units,
        'objective': profile.objective,
        'dateBegin': profile.dateBegin,
        'uid': profile.uid,
        'createdAt': profile.createdAt,
        'idealCalory': profile.idealCalory,
        'mealsPerDay': profile.mealsPerDay,
        'kitchen': profile.kitchen,
        'email': profile.email,
        'height': profile.height,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
        'currentWeight': profile.currentWeight,
        'typicalDay': profile.typicalDay,
        'desiredWeight': profile.desiredWeight,
        'noCereals': profile.noCereals,
        'idealFat': profile.idealFat,
        'pay': profile.pay,
        'workout': profile.workout,
        'idealCarbohydrate': profile.idealCarbohydrate,
        'age': profile.age,
        'bmi': profile.bmi,
        'water': profile.water,
      });

      await _transport.close();

      if (!updateResult) {
        if (kDebugMode) {
          print('-- USER NOT UPDATED --');
        }
        return false;
      } else {
        if (kDebugMode) {
          print('-- USER UPDATED --');
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

  Future<bool> createUser(Profile profile) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final updateResult = await _client.updateDoc(
        index: 'users',
        type: '_doc',
        id: profile.uid,
        doc: {
          'uid': profile.uid,
          'createdAt': profile.createdAt,
          'gender': profile.gender,
          'name': profile.name,
          'email': profile.email,
          'updatedAt': profile.updatedAt
        },
      );

      await _transport.close();

      if (!updateResult) {
        if (kDebugMode) {
          print('-- USER NOT CREATED --');
        }
        return false;
      } else {
        if (kDebugMode) {
          print('-- USER CREATED --');
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

  Future<bool> createPlan(Profile profile) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final searchResult = await _client.search(
          index: 'criterias',
          query: {
            "bool": {
              "must": [
                {
                  "terms": {
                    "nutrient": ["calorie", "protein", "fat", "carbohydrate", "water"]
                  }
                },
                {
                  "match": {"gender": profile.gender}
                },
                {
                  "range": {
                    "agemin": {"lte": profile.age}
                  }
                },
                {
                  "range": {
                    "agemax": {"gte": profile.age}
                  }
                }
              ]
            }
          },
          source: true);
      for (final iter in searchResult.hits) {
        Map<dynamic, dynamic> currDoc = iter.doc;
        if (currDoc['nutrient'] == "protein") {
          profile.idealProtein = profile.objective == 1
              ? currDoc['valuemax']
              : currDoc['valuemin'];
        } else if (currDoc['nutrient'] == "calorie") {
          profile.idealCalory = profile.objective == 1
              ? currDoc['valuemax']
              : currDoc['valuemin'];
        } else if (currDoc['nutrient'] == "fat") {
          profile.idealFat = profile.objective == 1
              ? currDoc['valuemax']
              : currDoc['valuemin'];
        } else if (currDoc['nutrient'] == "carbohydrate") {
          profile.idealCarbohydrate = profile.objective == 1
              ? currDoc['valuemax']
              : currDoc['valuemin'];
        } else if (currDoc['nutrient'] == "water") {
          profile.water = profile.objective == 1
              ? currDoc['valuemax']
              : currDoc['valuemin'];
        }
      }
      await preferences.setUser(profile);
      final updateResult = await _client.updateDoc(
        index: 'plans',
        type: '_doc',
        id: profile.uid,
        doc: {
          'bodyType': profile.bodyType,
          'allergies': profile.allergies,
          'startingWeight': profile.startingWeight,
          'noVegetables': profile.noVegetables,
          'noMeats': profile.noMeats,
          'noFruits': profile.noFruits,
          'noDairys': profile.noDairys,
          'idealProtein': profile.idealProtein,
          'dateEnd': profile.dateEnd,
          'units': profile.units,
          'objective': profile.objective,
          'dateBegin': profile.dateBegin,
          'uid': profile.uid,
          'createdAt': profile.createdAt,
          'idealCalory': profile.idealCalory,
          'mealsPerDay': profile.mealsPerDay,
          'kitchen': profile.kitchen,
          'email': profile.email,
          'height': profile.height,
          'updatedAt': profile.updatedAt,
          'currentWeight': profile.currentWeight,
          'typicalDay': profile.typicalDay,
          'desiredWeight': profile.desiredWeight,
          'noCereals': profile.noCereals,
          'idealFat': profile.idealFat,
          'pay': profile.pay,
          'workout': profile.workout,
          'idealCarbohydrate': profile.idealCarbohydrate,
          'age': profile.age,
          'bmi': profile.bmi,
          'water': profile.water,
        },
      );

      await _transport.close();

      if (!updateResult) {
        if (kDebugMode) {
          print('-- PLAN NOT CREATED --');
        }
        return false;
      } else {
        if (kDebugMode) {
          print('-- PLAN CREATED --');
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

  Future<Profile?> getIdeals(Profile profile) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final searchResult = await _client.search(
          index: 'criterias',
          query: {
            "bool": {
              "must": [
                {
                  "terms": {
                    "nutrient": ["calorie", "protein", "fat", "carbohydrate"]
                  }
                },
                {
                  "match": {"gender": profile.gender}
                },
                {
                  "range": {
                    "agemin": {"lte": profile.age}
                  }
                },
                {
                  "range": {
                    "agemax": {"gte": profile.age}
                  }
                }
              ]
            }
          },
          source: true);
      if (kDebugMode) {
        print(
            "----------- getIdeals Found ${searchResult.totalCount} ----------");
      }

      for (final iter in searchResult.hits) {
        Map<dynamic, dynamic> currDoc = iter.doc;
        if (currDoc['nutrient'] == "protein") {
          profile.idealProtein = profile.objective == 1
              ? currDoc['valuemax']
              : currDoc['valuemin'];
        } else if (currDoc['nutrient'] == "calorie") {
          profile.idealCalory = profile.objective == 1
              ? currDoc['valuemax']
              : currDoc['valuemin'];
        } else if (currDoc['nutrient'] == "fat") {
          profile.idealFat = profile.objective == 1
              ? currDoc['valuemax']
              : currDoc['valuemin'];
        } else if (currDoc['nutrient'] == "carbohydrate") {
          profile.idealCarbohydrate = profile.objective == 1
              ? currDoc['valuemax']
              : currDoc['valuemin'];
        }
      }

      await _transport.close();

      if (searchResult.totalCount <= 0) {
        return null;
      } else {
        return profile;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}

UserRepo userRop = UserRepo();
