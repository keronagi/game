import 'package:flutter/material.dart';
import 'package:game/screens/waitingRoom_screen.dart';
import 'dart:io';
import 'package:game/widgets/playSound.dart';

class JoingameButton extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController ipController;
  final String? hostName;
  const JoingameButton({
    this.hostName,
    required this.nameController,
    required this.ipController,

    super.key,
  });

  @override
  State<JoingameButton> createState() => _JoingameButtonState();
}

class _JoingameButtonState extends State<JoingameButton> {
  late Socket _socket;
  final String gameName = "";
  final String _dummyGameCode = "ABC123";
  final int _dummyPlayerCount = 2;

  Future<void> _connectedToIPhost() async {
    final name = widget.nameController.text.trim();
    final hostIP = widget.ipController.text.trim();
    if (name.isEmpty || hostIP.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("input name and ip host")));
      return;
    }
    try {
      _socket = await Socket.connect(hostIP, 3000);
      _socket.write(name);
      _socket.listen((data) {
        final message = String.fromCharCodes(data);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => WaitingroomScreen(
              gameName: gameName,
              playercount: _dummyPlayerCount,
              gameCode: _dummyGameCode,
              playersName: [],
              hostName: widget.hostName,
            ),
          ),
        );
      });
    } catch (e) {
      print("❌ Connection failed: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to connect to host")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade800),
        onPressed: () {
          SoundManager.playClick();
          _connectedToIPhost();
        },
        child: Text(
          "join game",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    );
  }
}
