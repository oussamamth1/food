import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitfood/models/profile.dart';
import 'package:fitfood/repo/user_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;
import 'package:fitfood/services/preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///
/// for Firebase
///
class FirebaseAuths {
  //To create new User
  Future<Map> createUserAuth(Profile profile, String language, context) async {
    if (kDebugMode) {
      print('-- CREATE USER 1 --');
      print(profile.email);
      print(profile.password);
      print(language);
    }
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      firebaseAuth.setLanguageCode(language);
      UserCredential authres =
          await firebaseAuth.createUserWithEmailAndPassword(
              email: profile.email!, password: profile.password!);
      User? user = authres.user;
      if (user != null) {
        await user.updateDisplayName(profile.name);
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }
        if (kDebugMode) {
          print('-- CREATE USER 2 --');
          print(user);
        }
        return {'uid': user.uid};
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return {
          'error': AppLocalizations.of(context)!.the_password_provided_weak
        };
      } else if (e.code == 'email-already-in-use') {
        return {
          'error': AppLocalizations.of(context)!.the_account_already_exists
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return {'error': AppLocalizations.of(context)!.something_wrong};
  }

  //To verify new User
  Future<Map> signIn(String email, String password, context) async {
    try {
      UserCredential authres = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = authres.user;
      if (user != null && user.emailVerified) {
        return {'uid': user.uid};
      } else {
        if (user == null) {
          return {'error': AppLocalizations.of(context)!.something_wrong};
        } else {
          await user.sendEmailVerification();
          return {
            'error': AppLocalizations.of(context)!.your_account_not_valid
          };
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return {'error': AppLocalizations.of(context)!.no_user_found};
      } else if (e.code == 'wrong-password') {
        return {'error': AppLocalizations.of(context)!.wrong_password_provided};
      } else if (e.code == 'invalid-email') {
        return {'error': AppLocalizations.of(context)!.your_account_not_valid};
      } else if (e.code == 'user-disabled') {
        return {'error': AppLocalizations.of(context)!.your_account_disabled};
      }
    }
    return {'error': AppLocalizations.of(context)!.something_wrong};
  }

  Future<void> saveToken() async {
    User? user = await currentUserObject();
    var jwt = await user!.getIdToken();
    preferences.setStringValue('token', jwt!);
  }

  Future<String?> getToken() async {
    User? user = await currentUserObject();
    var jwt = await user!.getIdToken(true);
    return jwt;
  }

  Future<String?> currentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null;
  }

  Future<User?> currentUserObject() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  Future<Profile?> getCurrentUser() async {
    //Récupère le user si demandé
    var uid = await currentUserId();
    if (uid != null) {
      return await userRop.getUserById(uid);
    }
    return null;
  }

  Future<String> updateCurrentUserPassword(String newPassword, context) async {
    try {
      await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
      return AppLocalizations.of(context)!.password_updated_successfully;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return AppLocalizations.of(context)!.the_password_provided_weak;
      }
    }
    return AppLocalizations.of(context)!.something_wrong;
  }

  Future<String?> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (kIsWeb) {
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        return webBrowserInfo.userAgent;
      } else {
        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          return androidInfo.model;
        } else if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          return iosInfo.utsname.machine;
        } else if (Platform.isLinux) {
          LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
          return linuxInfo.id;
        } else if (Platform.isMacOS) {
          MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
          return macOsInfo.model;
        } else if (Platform.isWindows) {
          WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
          return windowsInfo.computerName;
        }
      }
    } on PlatformException {
      return null;
    }
    return null;
  }
}
