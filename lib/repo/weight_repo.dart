import 'package:elastic_client/elastic_client.dart';
import 'package:fitfood/api/api_key.dart';
import 'package:fitfood/models/weight.dart';
import 'package:flutter/foundation.dart';

class WeightRepo {
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

  Future<Weight?> getWeightByUidDate(String uid, String day) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final searchResult = await _client.search(
          index: 'recorded_weight',
          query: {
            "bool": {
              "must": [
                {
                  "term": {"day": day}
                },
                {
                  "term": {"uid": uid}
                },
              ]
            }
          },
          source: true);
      if (kDebugMode) {
        print(
            "----------- getWeightByUidDate Found ${searchResult.totalCount} ----------");
      }

      await _transport.close();

      if (searchResult.totalCount <= 0) {
        if (kDebugMode) {
          print('-- WEIGHT NOT FOUND BY UID AND DATE --');
        }
        return null;
      } else {
        Weight weight = Weight.fromJson(searchResult.hits[0].doc);
        return weight;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<List<Weight>?> getWeightsByUid(String uid) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final searchResult = await _client.search(
        index: 'recorded_weight',
        query: {
          "term": {
            "uid": {"value": uid}
          }
        },
        source: true,
        sort: [
          {'day': 'asc'}
        ],
      );
      if (kDebugMode) {
        print(
            "----------- getWeightByUid Found ${searchResult.totalCount} ----------");
      }
      List<Weight> weights = [];
      for (final iter in searchResult.hits) {
        Map<dynamic, dynamic> currDoc = iter.doc;
        weights.add(Weight.fromJson(currDoc));
      }
      await _transport.close();

      if (searchResult.totalCount <= 0) {
        if (kDebugMode) {
          print('-- WEIGHTS NOT FOUND BY UID --');
        }
        return null;
      } else {
        return weights;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<bool> updateWeightById(String uid, Weight weight) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final updateResult = await _client.updateDoc(
          index: 'recorded_weight',
          type: '_doc',
          id: uid,
          doc: weight.toJson());

      await _transport.close();

      if (!updateResult) {
        if (kDebugMode) {
          print('-- Recorded weight NOT UPDATED --');
        }
        return false;
      } else {
        if (kDebugMode) {
          print('-- Recorded weight UPDATED --');
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

  Future<bool> createWeight(Weight weight) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final updateResult = await _client.updateDoc(
        index: 'recorded_weight',
        type: '_doc',
        id: weight.day! + "_" + weight.uid!,
        doc: weight.toJson(),
      );

      await _transport.close();

      if (!updateResult) {
        if (kDebugMode) {
          print('-- Recorded weight NOT CREATED --');
        }
        return false;
      } else {
        if (kDebugMode) {
          print('-- Recorded weight CREATED --');
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

WeightRepo weightRepo = WeightRepo();
