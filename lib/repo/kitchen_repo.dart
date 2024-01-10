import 'package:elastic_client/elastic_client.dart';
import 'package:fitfood/api/api_key.dart';
import 'package:fitfood/models/kitchen.dart';
import 'package:flutter/foundation.dart';

class KitchenRepo {
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

  Future<List<Kitchen>?> getAllKitchens() async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);

      List<Kitchen> kitchens = [];

      final searchResult = await _client.search(
          index: 'kitchens', query: Query.matchAll(), size: 100, source: true);
      if (kDebugMode) {
        print("----------- Found ${searchResult.totalCount} ----------");
      }
      // return searchResult.toMap();
      for (final iter in searchResult.hits) {
        Map<dynamic, dynamic> currDoc = iter.doc;
        kitchens.add(Kitchen.fromJson(currDoc));
      }

      await _transport.close();

      if (searchResult.totalCount <= 0) {
        return null;
      } else {
        return kitchens;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}

KitchenRepo kitchenRepo = KitchenRepo();
