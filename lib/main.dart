import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:fitfood/routes/routes.dart';
import 'package:fitfood/screens/splash_screen.dart';
import 'package:fitfood/services/preferences.dart';
import 'package:fitfood/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();
  var dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  await Hive.openBox('Favorite');
  String? langg = await preferences.getStringValue('language');
  runApp(MyApp(lang: langg));
}

class MyApp extends StatelessWidget {
  final String? lang;
  const MyApp({Key? key, this.lang}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fit'Food",
      theme: ThemeData(
        fontFamily: 'Satoshi',
        primarySwatch: Colors.green,
        primaryColor: mainColor0,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontFamily: 'Telma',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 202, 95, 95),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
         GlobalMaterialLocalizations.delegate,
         GlobalWidgetsLocalizations.delegate,
         GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('de', ''), // German, no country code
        Locale('es', ''), // Spanish, no country code
        Locale('fr', ''), // French, no country code
        Locale('pt', ''), // Portuguese, no country code
        Locale('ru', ''), // Russian, no country code
      ],
      locale: lang != null ? Locale(lang!, '') : const Locale('en', ''),
      //initialRoute: '/login',
      routes: Routes.all,
      home: const SplashScreen(),
      // home: BlocProvider(
      //   create: (context) => RandomRecipeBloc(),
      //   child: const RandomRecipe(),
      // ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
