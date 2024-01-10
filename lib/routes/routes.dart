import 'package:fitfood/models/profile.dart';
import 'package:fitfood/screens/no_connection.dart';
import 'package:fitfood/screens/authentification/login.dart';
import 'package:fitfood/screens/authentification/register/step1_goal.dart';
import 'package:fitfood/screens/authentification/register/step2_personal_informations.dart';
import 'package:fitfood/screens/authentification/register/step3_enter_email.dart';
import 'package:fitfood/screens/me/me.dart';
import 'package:fitfood/screens/me/settings/account/language.dart';
import 'package:fitfood/screens/me/settings/notification/notification_banner.dart';
import 'package:fitfood/screens/me/settings/notification/setup_notification.dart';
import 'package:fitfood/screens/me/settings/settings.dart';
import 'package:fitfood/screens/nav/bottom_nav_screen.dart';

class Routes {
  static final all = {
    '/language': (context) => const Step0Language(),
    //'/pay': (context) => const Step0Language(),
    // Register
    '/step-goal': (context) => const Step1Goal(),
    '/step-personal-informations': (context) => Step2Gender(
        profile: Profile(), sampleIngredients: const [], kitchens: const []),
    '/step-email': (context) => Step3EnterEmail(profile: Profile()),
    '/login': (context) => const Login(),
    '/home': (context) => const BottomNavView(),
    '/me': (context) => const Me(),
    '/settings': (context) => const Settings(),
    '/notifications': (context) => const NotificationBanner(),
    '/setup-notifications': (context) => const SetUpNotification(),
    '/no-internet': (context) => const NoConnectionScreen(),
  };
}
