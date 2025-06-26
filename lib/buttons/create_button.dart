import 'dart:io';
import 'dart:math';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:game/screens/waitingRoom_screen.dart';

class CreateButton extends StatelessWidget {
  final String gameName;
  final int? playercount;
  const CreateButton({
    super.key,
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
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: Colors.black),
          backgroundColor: Colors.green.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          if (gameName.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please type game name!')),
            );
            return;
          }

          // افتح إعدادات الـ Hotspot للمستخدم
          _openHotspotSettings();

          // توليد كود ثم الانتقال مباشرةً إلى WaitingroomScreen
          final code = _generateGameCode();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WaitingroomScreen(
                gameName: gameName,
                playercount: playercount,
                gameCode: code,
                playersName: [],
              ),
            ),
          );
        },
        child: const Text(
          'Create',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      ),
    );
  }
}
