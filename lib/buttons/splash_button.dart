import 'package:flutter/material.dart';
import 'package:game/screens/home_screen.dart';

class startButton extends StatelessWidget {
  const startButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.green.shade800,
        ),
        child: Text(
          "start",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    );
  }
}
