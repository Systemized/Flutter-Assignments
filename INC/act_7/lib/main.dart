import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MoodModel(),
      child: MyApp(),
    ),
  );
}

// Mood Model - The "Brain" of our app
class MoodModel with ChangeNotifier {
  String _currentMood = '😁';
  String get currentMood => _currentMood;
  int happyCount = 0;
  int sadCount = 0;
  int excitedCount = 0;

  void setHappy() {
    _currentMood = '😁';
    happyCount += 1;
    notifyListeners();
  }

  void setSad() {
    _currentMood = '😭';
    sadCount += 1;
    notifyListeners();
  }

  void setExcited() {
    _currentMood = '🤯';
    excitedCount += 1;
    notifyListeners();
  }

  Color moodColor() {
    if (_currentMood == '😁') {
      return Colors.blue;
    } else if (_currentMood == '😭') {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }
}

// Main App Widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Toggle Challenge',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

// Home Page
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mood Toggle Challenge')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('How are you feeling?', style: TextStyle(fontSize: 24)),
            SizedBox(height: 30),
            MoodDisplay(),
            SizedBox(height: 50),
            MoodButtons(),
          ],
        ),
      ),
      backgroundColor: Provider.of<MoodModel>(context).moodColor(),
    );
  }
}

// Widget that displays the current mood
class MoodDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Text(
          moodModel.currentMood,
          style: TextStyle(fontSize: 100),
        );
      },
    );
  }
}

// Widget with buttons to change the mood
class MoodButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setHappy();
          },
          child: Column(
            children: [
              Text('😁'),
              Text(Provider.of<MoodModel>(context).happyCount.toString())
            ],
          )
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setSad();
          },
          child: Column(
            children: [
              Text('😭'),
              Text(Provider.of<MoodModel>(context).sadCount.toString())
            ]
          )
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setExcited();
          },
          child: Column(
            children: [
              Text('🤯'),
              Text(Provider.of<MoodModel>(context).excitedCount.toString())
            ],
          )


        ),
      ],
    );
  }
}