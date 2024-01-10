import 'package:cloud_firestore/cloud_firestore.dart';

class ApiKey {
  // static String spooncularkeys =
  //     '9f3af0f0604642ed81d0a40533a36934'; //'80230e01dc3f4f1ca78447f4486d6314';
  // static String elasticSearchUrl =
  //     'https://fitfood-b9517b.es.us-central1.gcp.cloud.es.io:9243/'; //'https://192.168.1.8:9200/';
  // static String elasticSearchUsername = "elastic";
  // static String elasticSearchPassword =
  //     "8bAUYXDBIIGy3vIFc0Tx1J9K"; //"Ch=QAibkuyoAtPxZ7t=n";
  // static String pythonServer =
  //     "https://abderrahmen13.pythonanywhere.com/"; //"http://192.168.1.8:8080/";
  // static String pythonServerUser = "user";
  // static String pythonServerPassword = "password2";
  // static String pythonServerAuthKey = "dXNlcjpwYXNzd29yZDI=";

  Future<String> getSettingskeys(String fieldname) async {
    var snap =
        await FirebaseFirestore.instance.collection('settings').doc("1").get();
    return snap.data()![fieldname];
  }
}

//String pythonServerAuthKey = 'Basic ' + base64Encode(utf8.encode('$pythonServerUser:$pythonServerPassword'));
//print(basicAuth);