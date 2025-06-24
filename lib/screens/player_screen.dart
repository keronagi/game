import 'dart:io';
import 'package:flutter/material.dart';
import 'package:game/buttons/joinGame_button.dart';

class JoinGameScreen extends StatefulWidget {
  final String gameName;
  const JoinGameScreen({super.key, required this.gameName});

  @override
  State<JoinGameScreen> createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  final _namecontroller = TextEditingController();
  final _ipHostController = TextEditingController();
  late Socket _socket;

  @override
  void dispose() {
    _ipHostController.dispose();
    _namecontroller.dispose();
    _socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade100,
        centerTitle: true,
        title: Text(
          " join game",
          style: TextStyle(
            color: Colors.pinkAccent.shade700,
            fontSize: 30,
            fontFamily: "cairo",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              TextField(
                controller: _namecontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hint: Text(
                    "input your name",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              Divider(color: Colors.blueGrey.shade300, thickness: 1),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              TextField(
                controller: _ipHostController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hint: Text(
                    "input ip host",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              JoingameButton(
                nameController: _namecontroller,
                ipController: _ipHostController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
