import 'package:flutter/material.dart';
import 'package:game/buttons/host_button.dart';
import 'package:game/buttons/player_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  final String gameName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "choose the status?",
                style: TextStyle(
                  fontFamily: "cairo",
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Divider(
                color: Colors.blueGrey.shade200,
                thickness: 2,
                endIndent: 25,
                indent: 25,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              HostButton(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              PlayerButton(gameName: gameName),
            ],
          ),
        ),
      ),
    );
  }
}
