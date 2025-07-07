import 'package:flutter/material.dart';
import 'package:game/screens/player_screen.dart';
import 'package:game/widgets/playSound.dart';

class PlayerButton extends StatelessWidget {
  final String gameName;
  const PlayerButton({required this.gameName, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {
          SoundManager.playClick();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => JoinGameScreen(gameName: gameName),
            ),
          );
        },
        icon: Icon(Icons.person, color: Colors.white), // أيقونة معبّرة عن لاعب
        label: Text(
          "Join Game", // بدل كلمة player فقط
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}
