import 'package:flutter/material.dart';
import 'package:game/screens/host_screen.dart';

class HostButton extends StatelessWidget {
  const HostButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => HostScreen()));
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(color: Colors.black),
          backgroundColor: Colors.green.shade800,
        ),
        child: Text(
          "host",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    );
  }
}
