import 'package:flutter/material.dart';
import 'package:game/screens/player_screen.dart';

class PlayerButton extends StatelessWidget {
  final String gameName;
  const PlayerButton({required this.gameName, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => JoinGameScreen(gameName: gameName),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(color: Colors.black),
          backgroundColor: Colors.green.shade800,
        ),
        child: Text(
          "player",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    );
  }
}
