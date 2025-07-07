import 'package:flutter/material.dart';
import 'package:game/buttons/controllers_buttons.dart';
import 'package:game/controllers/game_controllers.dart';
import 'package:game/screens/final_result.dart';
import 'package:game/widgets/textfeid_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GameScreen extends StatefulWidget {
  final List<String> playersName;
  final String gameName;
  final IO.Socket? socket;
  final String myName;
  const GameScreen({
    super.key,
    required this.myName,
    required this.playersName,
    required this.gameName,
    this.socket,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameController controller;
  int? currentRoundScore;
  bool showRoundScore = false;
  Widget _infoTile(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    controller = GameController(playersName: widget.playersName);
    controller.startNewRound(() => setState(() {}));
    controller.startTimer(onTick: () => setState(() {}), onEnd: _endRound);

    if (widget.socket != null) {
      widget.socket!.on("round result", (data) {
        final scoreMap = Map<String, int>.from(data);
        controller.apllyscorses(scoreMap);

        setState(() {
          currentRoundScore = scoreMap[widget.myName];
          showRoundScore = true;
        });
      });
    }
  }

  void _endRound() {
    setState(() {
      controller.endRound();
    });

    if (widget.myName == widget.playersName.first) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FinalResult(
            players: widget.playersName,
            answers: controller.getAllAnswers(),
            socket: widget.socket,
            onSubmit: (Map<String, int> updatedScores) {
              setState(() {
                controller.apllyscorses(updatedScores);
                currentRoundScore = updatedScores[widget.myName];
                showRoundScore = true;

                if (controller.currentRound == controller.totalRounds) {
                  Future.delayed(Duration(milliseconds: 300), () {
                    _showFinalResult();
                  });
                } else {
                  controller.currentRound++;
                  controller.startNewRound(() => setState(() {}));
                  controller.startTimer(
                    onTick: () => setState(() {}),
                    onEnd: _endRound,
                  );
                }
              });
            },
          ),
        ),
      );
    }
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
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Player",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Score",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              ...controller.playerscores.map(
                (p) => TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("${p['name']}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("${p['score']}"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                controller.restartGame();
                controller.startNewRound(() => setState(() {}));
                controller.startTimer(
                  onTick: () => setState(() {}),
                  onEnd: _endRound,
                );
              });
              Navigator.pop(context);
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

  @override
  void dispose() {
    controller.dispose();
    widget.socket!.off("round result");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          widget.gameName,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: "Cairo",
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ✅ Round Info
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                color: Colors.indigo.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoTile(
                        "Round",
                        "${controller.currentRound} / ${controller.totalRounds}",
                      ),
                      _infoTile("Letter", "${controller.currentLetter}"),
                      _infoTile("Time", "${controller.remainingTime}s"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Player Score Box (if available)
              if (showRoundScore && currentRoundScore != null)
                Container(
                  padding: EdgeInsets.all(14),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_events, color: Colors.green),
                      SizedBox(width: 10),
                      Text(
                        'Your Score: $currentRoundScore pts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                ),

              // ✅ Player Cards
              ...widget.playersName.map((player) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player == widget.myName
                              ? "👤 You ($player)"
                              : "👥 $player",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: player == widget.myName
                                ? Colors.indigo
                                : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            buildInputField(
                              label: "ولد",
                              controller: controller.boyController[player]!,
                              isEnabled: !controller.isStoped,
                            ),
                            buildInputField(
                              label: "بنت",
                              controller: controller.girlController[player]!,
                              isEnabled: !controller.isStoped,
                            ),
                            buildInputField(
                              label: "جماد",
                              controller: controller.objectController[player]!,
                              isEnabled: !controller.isStoped,
                            ),
                            buildInputField(
                              label: "حيوان",
                              controller: controller.animalController[player]!,
                              isEnabled: !controller.isStoped,
                            ),
                            buildInputField(
                              label: "نبات",
                              controller: controller.plantController[player]!,
                              isEnabled: !controller.isStoped,
                            ),
                            buildInputField(
                              label: "بلاد",
                              controller: controller.countryController[player]!,
                              isEnabled: !controller.isStoped,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              // ✅ Control Buttons
              ControlButtons(
                onStop: () {
                  controller.timer?.cancel();
                  setState(() {
                    controller.isPaused = true;
                    controller.isStoped = true;
                  });
                },
                onComplete: _endRound,
                onContinue: () {
                  setState(() {
                    controller.isPaused = false;
                    controller.isStoped = false;
                  });
                  controller.startTimer(
                    onTick: () => setState(() {}),
                    onEnd: _endRound,
                  );
                },
                isCompleteEnabled: controller.areAllFieldsValid(),
                isPaused: controller.isPaused,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
