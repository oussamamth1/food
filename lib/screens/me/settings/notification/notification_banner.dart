import 'package:flutter/material.dart';
import 'setup_notification.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationBanner extends StatefulWidget {
  const NotificationBanner({Key? key}) : super(key: key);

  @override
  State<NotificationBanner> createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<NotificationBanner> {
  bool isButtonActive = true;
  String language = "en";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey.shade200,
            leading: const BackButton(color: Colors.black),
          ),
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Image(
                          width: 200,
                          image: AssetImage('assets/images/notifications.png')),
                      ),
                      Text(AppLocalizations.of(context)!.people_with_notifications,
                        style:
                            const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 10)),
                      Text(AppLocalizations.of(context)!.we_will_send_useful,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 25.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // background
                            onPrimary: Colors.white, // foreground
                            onSurface: Colors.green,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: isButtonActive
                              ? () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SetUpNotification()),
                                  );
                                }
                              : null,
                          child: Text(AppLocalizations.of(context)!.set_up_notifications,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey.shade200, // background
                          onPrimary: Colors.green, // foreground
                          onSurface: Colors.grey.shade200,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.remind_me_later,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
