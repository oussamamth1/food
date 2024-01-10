import 'package:elastic_client/elastic_client.dart';
import 'package:fitfood/api/api_key.dart';
import 'package:fitfood/models/ingredient.dart';
import 'package:flutter/foundation.dart';

class IngredientRepo {
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

  Future<List<Ingredient>?> getAllIngredients(String index) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);

      List<Ingredient> ingredients = [];

      final searchResult = await _client.search(
          index: index, query: Query.matchAll(), size: 100, source: true);
      if (kDebugMode) {
        print("----------- Found ${searchResult.totalCount} ----------");
      }
      // return searchResult.toMap();
      for (final iter in searchResult.hits) {
        Map<dynamic, dynamic> currDoc = iter.doc;
        ingredients.add(Ingredient.fromJson(currDoc));
        // ingredients.add(Ingredient(
        //     name: currDoc['name'].toString(),
        //     calcium: int.parse(currDoc['calcium'].toString()),
        //     calorie: int.parse(currDoc['calorie'].toString()),
        //     carbohydrate: double.parse(currDoc['carbohydrate'].toString()),
        //     category: currDoc['category'].toString(),
        //     dietaryFiber: double.parse(currDoc['dietary fiber'].toString()),
        //     fat: double.parse(currDoc['fat'].toString()),
        //     code: int.parse(currDoc['code'].toString()),
        //     iron: double.parse(currDoc['iron'].toString()),
        //     mainCategory: currDoc['main category'].toString(),
        //     protein: double.parse(currDoc['protein'].toString()),
        //     sodium: int.parse(currDoc['sodium'].toString()),
        //     vitaminA: int.parse(currDoc['vitamin A'].toString()),
        //     vitaminB1: double.parse(currDoc['vitamin B1 (thiamin)'].toString()),
        //     vitaminB2:
        //         double.parse(currDoc['vitamin B2 (riboflavin)'].toString()),
        //     vitaminC: double.parse(currDoc['vitamin C'].toString()),
        //     water: double.parse(currDoc['water'].toString())));
      }

      await _transport.close();

      if (searchResult.totalCount <= 0) {
        return null;
      } else {
        return ingredients;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<List<Ingredient>?> getIngredientsByName(
      String index, String fieldName) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);

      List<Ingredient> ingredients = [];

      final searchResult = await _client.search(
          index: index,
          query: {
            "multi_match": {
              "query": fieldName,
              "fields": ["name", "category"],
              "fuzziness": 1
            }
          },
          source: true);
      if (kDebugMode) {
        print(
            "----------- getIngredientsByName Found ${searchResult.totalCount} by $fieldName ----------");
      }
      for (final iter in searchResult.hits) {
        Map<dynamic, dynamic> currDoc = iter.doc;
        ingredients.add(Ingredient.fromJson(currDoc));
        // ingredients.add(Ingredient(
        //     name: currDoc['name'].toString(),
        //     calcium: int.parse(currDoc['calcium'].toString()),
        //     calorie: int.parse(currDoc['calorie'].toString()),
        //     carbohydrate: double.parse(currDoc['carbohydrate'].toString()),
        //     category: currDoc['category'].toString(),
        //     dietaryFiber: double.parse(currDoc['dietary fiber'].toString()),
        //     fat: double.parse(currDoc['fat'].toString()),
        //     code: int.parse(currDoc['code'].toString()),
        //     iron: double.parse(currDoc['iron'].toString()),
        //     mainCategory: currDoc['main category'].toString(),
        //     protein: double.parse(currDoc['protein'].toString()),
        //     sodium: int.parse(currDoc['sodium'].toString()),
        //     vitaminA: int.parse(currDoc['vitamin A'].toString()),
        //     vitaminB1: double.parse(currDoc['vitamin B1 (thiamin)'].toString()),
        //     vitaminB2:
        //         double.parse(currDoc['vitamin B2 (riboflavin)'].toString()),
        //     vitaminC: double.parse(currDoc['vitamin C'].toString()),
        //     water: double.parse(currDoc['water'].toString())));
      }

      await _transport.close();

      if (searchResult.totalCount <= 0) {
        return null;
      } else {
        return ingredients;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}

IngredientRepo ingredientRepo = IngredientRepo();
