import 'package:flutter/material.dart';
import 'package:game/screens/host_screen.dart';
import 'package:game/widgets/playSound.dart';

class HostButton extends StatelessWidget {
  const HostButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {
          SoundManager.playClick();
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => HostScreen()));
        },
        icon: Icon(Icons.wifi_tethering, color: Colors.white), // أيقونة معبّرة
        label: Text(
          "Create Game", // أو "Start as Host"
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade700,
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
