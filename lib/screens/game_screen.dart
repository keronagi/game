import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final List<String> playersName;
  final String gameName;
  const GameScreen({
    super.key,
    required this.gameName,
    required this.playersName,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int currentRound = 1;
  final int totalRounds = 10;
  String? currentLetter;
  bool isStoped = false;
  Timer? _timer;
  bool isPaused = false;
  int remainingTime = 60;
  List<String> usedLetters = [];
  late List<Map<String, dynamic>> playerscores;
  final TextEditingController boyController = TextEditingController();
  final TextEditingController girlController = TextEditingController();
  final TextEditingController objectController = TextEditingController();
  final TextEditingController animalController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController plantController = TextEditingController();
  @override
  void initState() {
    playerscores = widget.playersName
        .map((name) => {"name": name, "score": 0})
        .toList();
    super.initState();
    _startNewRound();
    _startTimer();
  }

  void _startNewRound() {
    if (currentRound <= totalRounds) {
      genratetRandomLetter();
      _startTimer();
      setState(() {
        isPaused = false;
        isStoped = false;
        remainingTime = 60;
        boyController.clear();
        girlController.clear();
        objectController.clear();
        countryController.clear();
        plantController.clear();
        animalController.clear();
      });
    }
  }

  void genratetRandomLetter() {
    const letters = "ابتثجحخدذرزسشصضقفكمنليغعهطظو";
    String randomLetter;
    do {
      randomLetter = letters[Random().nextInt(letters.length)];
    } while (usedLetters.contains(randomLetter));
    setState(() {
      currentLetter = randomLetter;
      usedLetters.add(randomLetter);
    });
  }

  void _showFinalResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "game over",
          style: TextStyle(fontSize: 30, color: Colors.blue.shade900),
        ),
        content: SingleChildScrollView(
          child: Table(
            border: TableBorder.all(color: Colors.black12),
            children: [
              TableRow(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Player",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Score",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              ...playerscores.map((player) {
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${player['name']}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${player['score']}"),
                    ),
                  ],
                );
                // ignore: unnecessary_to_list_in_spreads
              }).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartGame();
            },
            child: Text("restart"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("ok"),
          ),
        ],
      ),
    );
  }

  void _startTimer() {
    _timer?.cancel();
    remainingTime = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused) {
        setState(() {
          if (remainingTime > 0) {
            remainingTime--;
          } else {
            _endRound();
          }
        });
      }
    });
  }

  void _endRound() {
    _timer?.cancel();
    setState(() {
      isStoped = true;
    });
    for (var player in playerscores) {
      player['score'] += calculatePlayerScore(player);
    }
    if (currentRound < totalRounds) {
      _showFinalResult();
    }
  }

  int calculatePlayerScore(Map<String, dynamic> player) {
    return 10;
  }

  void _restartGame() {
    setState(() {
      currentRound = 1;
      usedLetters.clear();
      playerscores = playerscores
          .map((p) => {'name': p['name'], 'score': 0})
          .toList();
    });
    _startNewRound();
  }

  bool _areAllFieldsFilled() {
    final letter = currentLetter;
    if (letter == null) return false;
    bool startWithLetter(String text) =>
        text.trim().length > 1 && text.trim().startsWith(letter);
    return startWithLetter(boyController.text) &&
        startWithLetter(girlController.text) &&
        startWithLetter(objectController.text) &&
        startWithLetter(animalController.text) &&
        startWithLetter(plantController.text) &&
        startWithLetter(countryController.text);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget buildinputfeild(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      enabled: !isStoped,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        centerTitle: true,
        title: Text(
          widget.gameName,
          style: TextStyle(
            fontSize: 40,
            color: Colors.pinkAccent.shade700,
            fontFamily: "cairo",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  "round : $currentRound/$totalRounds",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text("letter :$currentLetter", style: TextStyle(fontSize: 20)),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                "time left : $remainingTime sec",
                style: TextStyle(fontSize: 30, color: Colors.green.shade500),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.002),
              buildinputfeild("ولد", boyController),
              SizedBox(height: MediaQuery.of(context).size.height * 0.002),
              buildinputfeild("بنت", girlController),
              SizedBox(height: MediaQuery.of(context).size.height * 0.002),
              buildinputfeild("جماد", objectController),
              SizedBox(height: MediaQuery.of(context).size.height * 0.002),
              buildinputfeild("حيوان", animalController),
              SizedBox(height: MediaQuery.of(context).size.height * 0.002),
              buildinputfeild("نبات", plantController),
              SizedBox(height: MediaQuery.of(context).size.height * 0.002),
              buildinputfeild("بلاد", countryController),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ElevatedButton(
                      onPressed: () {
                        _timer?.cancel();
                        setState(() {
                          isPaused = true;
                          isStoped = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                      ),
                      child: Text(
                        "stop",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ElevatedButton(
                      onPressed: _areAllFieldsFilled() ? _endRound : null,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                      ),
                      child: Text(
                        "complete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                    ),
                    onPressed: () {},
                    child: Text(
                      "new round",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              if (isPaused)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade500,
                  ),
                  onPressed: () {
                    remainingTime;
                    setState(() {
                      isStoped = false;
                      isPaused = false;
                    });
                  },
                  child: Text(
                    "continue",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
