import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GameController {
  final int totalRounds;
  final List<String> playersName;

  int currentRound = 1;
  String? currentLetter;
  int remainingTime = 60;
  bool isPaused = false;
  bool isStoped = false;
  Timer? timer;
  List<String> usedLetters = [];
  List<Map<String, dynamic>> playerscores = [];

  late Map<String, TextEditingController> boyController;
  late Map<String, TextEditingController> girlController;
  late Map<String, TextEditingController> objectController;
  late Map<String, TextEditingController> countryController;
  late Map<String, TextEditingController> plantController;
  late Map<String, TextEditingController> animalController;

  GameController({required this.playersName, this.totalRounds = 10}) {
    playerscores = playersName
        .map((name) => {'name': name, 'score': 0})
        .toList();
    boyController = {
      for (var name in playersName) name: TextEditingController(),
    };
    girlController = {
      for (var name in playersName) name: TextEditingController(),
    };
    animalController = {
      for (var name in playersName) name: TextEditingController(),
    };
    objectController = {
      for (var name in playersName) name: TextEditingController(),
    };
    plantController = {
      for (var name in playersName) name: TextEditingController(),
    };
    countryController = {
      for (var name in playersName) name: TextEditingController(),
    };
  }

  void generateLetter() {
    const letters = "ابتثجحخدذرزسشصضقفكمنليغعهطظو";
    String randomLetter;
    do {
      randomLetter = letters[Random().nextInt(letters.length)];
    } while (usedLetters.contains(randomLetter));
    currentLetter = randomLetter;
    usedLetters.add(randomLetter);
  }

  void resetControllers() {
    for (var name in playersName) {
      boyController[name]?.clear();
      girlController[name]?.clear();
      objectController[name]?.clear();
      animalController[name]?.clear();
      countryController[name]?.clear();
      plantController[name]?.clear();
    }
  }

  void startNewRound(VoidCallback updateState) {
    if (currentRound <= totalRounds) {
      generateLetter();
      remainingTime = 60;
      isPaused = false;
      isStoped = false;
      resetControllers();
      updateState();
    }
  }

  void startTimer({required Function onTick, required VoidCallback onEnd}) {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (!isPaused) {
        if (remainingTime > 0) {
          remainingTime--;
          onTick();
        } else {
          t.cancel();
          onEnd();
        }
      }
    });
  }

  void endRound() {
    timer?.cancel();
    isStoped = true;
  }

  void restartGame() {
    currentRound = 1;
    usedLetters.clear();
    remainingTime = 60;
    playerscores = playersName
        .map((name) => {'name': name, 'score': 0})
        .toList();
  }

  bool areAllFieldsValid() {
    final letter = currentLetter;
    if (letter == null) return false;

    bool startsWith(String text) =>
        text.trim().isNotEmpty && text.trim().startsWith(letter);

    for (var name in playersName) {
      if (!startsWith(boyController[name]?.text ?? '')) return false;
      if (!startsWith(girlController[name]?.text ?? '')) return false;
      if (!startsWith(objectController[name]?.text ?? '')) return false;
      if (!startsWith(animalController[name]?.text ?? '')) return false;
      if (!startsWith(plantController[name]?.text ?? '')) return false;
      if (!startsWith(countryController[name]?.text ?? '')) return false;
    }

    return true;
  }

  Map<String, Map<String, String>> getAllAnswers() {
    return {
      for (var name in playersName)
        name: {
          "ولد": boyController[name]?.text ?? "",
          "بنت": girlController[name]?.text ?? "",
          "جماد": objectController[name]?.text ?? "",
          "حيوان": animalController[name]?.text ?? "",
          "نبات": plantController[name]?.text ?? "",
          "بلاد": countryController[name]?.text ?? "",
        },
    };
  }

  void apllyscorses(Map<String, int> scores) {
    for (var entry in scores.entries) {
      final player = entry.key;
      final score = entry.value;

      final index = playerscores.indexWhere((p) => p['name'] == player);

      if (index != -1) {
        playerscores[index]['score'] =
            (playerscores[index]['score'] ?? 0) + score;
      } else {
        playerscores.add({'name': player, 'score': score});
      }
    }
  }

  void dispose() {
    timer?.cancel();
    for (var name in playersName) {
      boyController[name]?.dispose();
      girlController[name]?.dispose();
      objectController[name]?.dispose();
      animalController[name]?.dispose();
      countryController[name]?.dispose();
      plantController[name]?.dispose();
    }
  }
}
