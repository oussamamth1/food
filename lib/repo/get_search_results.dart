import 'package:dio/dio.dart';
import 'package:fitfood/api/api_key.dart';
import 'package:fitfood/models/auto_complete.dart';
import 'package:fitfood/models/faliure.dart';
import 'package:fitfood/models/search_results.dart';

class SearchRepo {

  Future<SearchResultList> getSearchList(String type, int no) async {
    var key = await ApiKey().getSettingskeys('spooncularkeys');
    var url =
        'https://api.spoonacular.com/recipes/complexSearch?query=$type&number=$no&apiKey=$key';

    var response = await Dio().get(url);

    if (response.statusCode == 200) {
      return SearchResultList.fromJson(response.data['results']);
    } else if (response.statusCode == 401) {
      throw Failure(code: 401, message: response.data['message']);
    } else {
      throw Failure(
          code: response.statusCode!, message: response.statusMessage!);
    }
  }

  Future<SearchAutoCompleteList> getAutoCompleteList(String searchText) async {
    var key = await ApiKey().getSettingskeys('spooncularkeys');
    var url =
        'https://api.spoonacular.com/recipes/autocomplete?number=100&query=$searchText&apiKey=$key';
    var response = await Dio().get(url);

    if (response.statusCode == 200) {
      return SearchAutoCompleteList.fromJson(response.data);
    } else if (response.statusCode == 401) {
      throw Failure(code: 401, message: response.data['message']);
    } else {
      throw Failure(
          code: response.statusCode!, message: response.statusMessage!);
    }
  }
}
