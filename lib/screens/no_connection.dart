import 'package:fitfood/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Image.asset(
              "assets/images/1_No Connection.png",
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 100,
              left: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white, // background
                    onPrimary: Colors.green, // foreground
                    onSurface: Colors.white,
                    minimumSize: const Size.fromHeight(30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const SplashScreen(),
                      ));
                },
                child: Text("Retry".toUpperCase()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
