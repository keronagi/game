import 'package:flutter/material.dart';
import 'package:game/screens/game_screen.dart';

class StartGameButton extends StatelessWidget {
  final List<String> playersName;
  final String gameName;
  const StartGameButton({
    super.key,
    required this.gameName,
    required this.playersName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.green.shade800,
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Center(child: Text("Game Started!"))),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  GameScreen(playersName: playersName, gameName: gameName),
            ),
          );
        },
        child: Text(
          "start game",
          style: TextStyle(
            fontSize: 28,
            fontFamily: "cairo",
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
