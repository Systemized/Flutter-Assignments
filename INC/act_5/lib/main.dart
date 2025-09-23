import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  final TextEditingController _nameController = TextEditingController();

  String petName = "";
  int happinessLevel = 50;
  int hungerLevel = 50;
  String petMood = "Neutral 😐";


  Timer? _timer;
  // Tracks win condition: happiness maintained above threshold for a duration
  Timer? _winTimer;
  int _happinessStreakSeconds = 0;
  static const int _winThresholdSeconds = 180; // 3 minutes
  static const int _happinessWinThreshold = 80;

  bool _isWinner = false;
  bool _isGameOver = false;
  int _energyLevel = 50; // 0-100 energy level for the pet

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateHunger();
    });
    // Check happiness streak every second for win condition
    _winTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isWinner || _isGameOver) return;
      if (happinessLevel > _happinessWinThreshold) {
        _happinessStreakSeconds += 1;
        if (_happinessStreakSeconds >= _winThresholdSeconds) {
          _onWin();
        }
      } else {
        _happinessStreakSeconds = 0;
      }
      _checkLossCondition();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _winTimer?.cancel();
    _nameController.dispose();
    super.dispose();
  }



  void _playWithPet() {
    setState(() {
      if (_isWinner || _isGameOver) return;
      happinessLevel += 10;
      if (happinessLevel > 100) happinessLevel = 100;
      _energyLevel -= 10;
      if (_energyLevel < 0) _energyLevel = 0;
      _updateHunger();
    });
    _checkWinLoss();
  }

  void _feedPet() {
    setState(() {
      if (_isWinner || _isGameOver) return;
      hungerLevel -= 10;
      if (hungerLevel < 0) hungerLevel = 0;
      _energyLevel += 5;
      if (_energyLevel > 100) _energyLevel = 100;
      _updateHappiness();
    });
    _checkWinLoss();
  }

  void _updateHappiness() {
    if (_isWinner || _isGameOver) return;
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
    if (happinessLevel > 100) happinessLevel = 100;
    if (happinessLevel < 0) happinessLevel = 0;
  }

  void _updateHunger() {
    setState(() {
      if (_isWinner || _isGameOver) return;
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
      _energyLevel -= 5;
      if (_energyLevel < 0) _energyLevel = 0;
      if (happinessLevel < 0) happinessLevel = 0;
    });
    _checkWinLoss();
  }

  void _checkWinLoss() {
    if (_isWinner || _isGameOver) return;
    // Win handled by _winTimer based on streak; ensure not missed if called from actions
    if (_happinessStreakSeconds >= _winThresholdSeconds && happinessLevel > _happinessWinThreshold) {
      _onWin();
      return;
    }
    _checkLossCondition();
  }

  void _checkLossCondition() {
    if (_isWinner || _isGameOver) return;
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      _onGameOver();
    }
  }

  void _onWin() {
    _isWinner = true;
    _timer?.cancel();
    _winTimer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('You Win!'),
        content: const Text('Your pet stayed happy for 3 minutes!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
    setState(() {});
  }

  void _onGameOver() {
    _isGameOver = true;
    _timer?.cancel();
    _winTimer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: const Text('Hunger reached 100 and happiness dropped to 10.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
    setState(() {});
  }

  void _resetGame() {
    _timer?.cancel();
    _winTimer?.cancel();
    setState(() {
      _isWinner = false;
      _isGameOver = false;
      _happinessStreakSeconds = 0;
      petName = petName; // keep name
      happinessLevel = 50;
      hungerLevel = 50;
      petMood = "Neutral 😐";
      _energyLevel = 50;
    });
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateHunger();
    });
    _winTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isWinner || _isGameOver) return;
      if (happinessLevel > _happinessWinThreshold) {
        _happinessStreakSeconds += 1;
        if (_happinessStreakSeconds >= _winThresholdSeconds) {
          _onWin();
        }
      } else {
        _happinessStreakSeconds = 0;
      }
      _checkLossCondition();
    });
  }

  Color moodColor() {
    if (petName.isEmpty) {
      return const Color.fromARGB(255, 255, 215, 94);
    }
    if (happinessLevel > 70) {
      petMood = "Happy 😀";
      return Colors.green;
    } else if (happinessLevel > 29) {
      petMood = "Neutral 😐";
      return Colors.grey;
    } else {
      petMood = "Unhappy 😞";
      return Colors.red;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      backgroundColor: moodColor(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          <Widget>[
            if (petName.isEmpty) ...[
              SizedBox(
                width: 200,
                child: 
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter your pet's name",
                    ),
                  ),
              ),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    petName = _nameController.text.trim();
                  });
                },
                child: Text("Confirm Name"),
              ),
            ] else ...[


              Image(
                image: AssetImage("../assets/pixelFox.png"),
                width: 200,
                height: 200,
              ),
              SizedBox(height: 13.0),
              Text(
                'Name: $petName',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Happiness Level: $happinessLevel',
                style: TextStyle(fontSize: 20.0),
              ),
              Text(
                'Mood: $petMood',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Hunger Level: $hungerLevel',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: (_isWinner || _isGameOver) ? null : _playWithPet,
                child: Text('Play with Your Pet'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: (_isWinner || _isGameOver) ? null : _feedPet,
                child: Text('Feed Your Pet'),
              ),
              SizedBox(height: 16.0),
              if (_isWinner) ...[
                Text('You Win! 🎉', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
              ] else if (_isGameOver) ...[
                Text('Game Over 💀', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
              ],
              if (_isWinner || _isGameOver) ...[
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _resetGame,
                  child: const Text('Reset Game'),
                ),
              ],
              SizedBox(height: 24.0),
              Text('Energy Level: $_energyLevel', style: TextStyle(fontSize: 18.0)),
              SizedBox(height: 8.0),
              SizedBox(
                width: 240,
                child: LinearProgressIndicator(
                  value: _energyLevel.clamp(0, 100) / 100.0,
                  minHeight: 12,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
