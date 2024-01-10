import 'package:dio/dio.dart';
import 'package:fitfood/api/api_key.dart';
import 'package:fitfood/models/faliure.dart';
import 'package:fitfood/models/food_type.dart';
import 'package:fitfood/repo/get_recipe_info.dart';
import 'package:flutter/foundation.dart';

class GetHomeRecipes {

  final dio = Dio();

  Future<FoodTypeList> getRecipes(String type, int no) async {
    var key = await ApiKey().getSettingskeys('spooncularkeys');
    var url = BASE_URL + "/random?number=$no&tags=$type" + '&apiKey=' + key;
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      return FoodTypeList.fromJson(response.data['recipes']);
    } else if (response.statusCode == 401) {
      throw Failure(code: 401, message: response.data['message']);
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
      throw Failure(
          code: response.statusCode!, message: response.statusMessage!);
    }
  }
}
