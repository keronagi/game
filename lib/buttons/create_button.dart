import 'dart:io';
import 'dart:math';
import 'package:game/widgets/playSound.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:game/screens/waitingRoom_screen.dart';

class CreateButton extends StatelessWidget {
  final String gameName;
  final int? playercount;
  final String? hostName;
  const CreateButton({
    super.key,
    this.hostName,
    required this.gameName,
    required this.playercount,
  });
  void _openHotspotSettings() {
    if (Platform.isAndroid) {
      const intent = AndroidIntent(
        action: 'android.settings.TETHER_SETTINGS',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      intent.launch();
    }
  }

  String _generateGameCode() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(
      6,
      (i) => chars[Random().nextInt(chars.length)],
    ).join();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        icon: Icon(Icons.play_arrow_rounded, size: 30, color: Colors.white),
        label: Text(
          'Create Game',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade800,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          SoundManager.playClick();
          if (gameName.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please type game name!')),
            );
            return;
          }

          _openHotspotSettings();

          final code = _generateGameCode();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WaitingroomScreen(
                gameName: gameName,
                playercount: playercount,
                gameCode: code,
                playersName: [],
                hostName: hostName,
              ),
            ),
          );
        },
      ),
    );
  }
}
