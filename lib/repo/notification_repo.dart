import 'dart:convert';

import 'package:elastic_client/elastic_client.dart';
import 'package:fitfood/api/api_key.dart';
import 'package:fitfood/models/notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationRepo {
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

  Future<Notifications?> getById(String uid) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final searchResult = await _client.search(
          index: 'notifications',
          query: {
            "term": {
              "uid": {"value": uid}
            }
          },
          source: true);
      Notifications notification = Notifications();
      if (kDebugMode) {
        print(
            "----------- Found ${searchResult.totalCount} NOTIFICATION ----------");
      }
      // return searchResult.toMap();
      for (final iter in searchResult.hits) {
        Map<dynamic, dynamic> currDoc = iter.doc;
        notification = Notifications.fromJson(currDoc);
      }

      await _transport.close();

      if (searchResult.totalCount <= 0) {
        return null;
      } else {
        return notification;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<bool> updateNotificationById(
      String uid, Notifications notification) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final updateResult = await _client
          .updateDoc(index: 'notifications', type: '_doc', id: uid, doc: {
        'uid': uid,
        'mealTime': json.encode(notification.mealTime!.toJson()),
        'water': notification.water,
      });

      await _transport.close();

      if (!updateResult) {
        if (kDebugMode) {
          print('-- NOTIFICATION NOT UPDATED --');
        }
        return false;
      } else {
        if (kDebugMode) {
          print('-- NOTIFICATION UPDATED --');
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

  Future<bool> createNotification(Notifications notification) async {
    try {
      await initt();
      final _transport = HttpTransport(
          url: elasticSearchUrl,
          authorization:
              basicAuthorization(elasticSearchUsername, elasticSearchPassword));
      final _client = Client(_transport);
      final updateResult = await _client.updateDoc(
        index: 'notifications',
        type: '_doc',
        id: notification.uid,
        doc: {
          'uid': notification.uid,
          'mealTime': json.encode(notification.mealTime!.toJson()),
          'water': notification.water,
        },
      );

      await _transport.close();

      if (!updateResult) {
        if (kDebugMode) {
          print('-- NOTIFICATION NOT CREATED --');
        }
        return false;
      } else {
        if (kDebugMode) {
          print('-- NOTIFICATION CREATED --');
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

NotificationRepo notificationRepo = NotificationRepo();
