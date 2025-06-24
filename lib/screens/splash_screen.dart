import 'package:flutter/material.dart';
import 'package:game/buttons/splash_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.30),
                Image.asset("assets/images/bus.png", width: 70),
                SizedBox(width: MediaQuery.of(context).size.width * 0.001),
                Image.asset("assets/images/brain.png", width: 70),
              ],
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "اتوبيس",
                      style: TextStyle(
                        color: Colors.pinkAccent.shade700,
                        fontFamily: "cairo",
                        fontSize: 40,
                      ),
                    ),
                    TextSpan(
                      text: "complete",
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontFamily: "cairo",
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            startButton(),
          ],
        ),
      ),
    );
  }
}
