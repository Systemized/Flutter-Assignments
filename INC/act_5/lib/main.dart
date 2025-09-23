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

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateHunger();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _nameController.dispose();
    super.dispose();
  }



  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
    });
  }

  Color moodColor() {
    if (petName.isEmpty) {
      return Colors.amber;
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
                onPressed: _playWithPet,
                child: Text('Play with Your Pet'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _feedPet,
                child: Text('Feed Your Pet'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
