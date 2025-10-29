import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:confetti/confetti.dart';

// Tha Big Confetti Celebration

class SuccessScreen extends StatefulWidget {
  final String userName;
  final String avatar;
  final List<String> badges;

  const SuccessScreen({super.key, required this.userName, this.avatar = '🧭', this.badges = const []});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 10),
    );

    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],

      body: Stack(
        children: [
          // Confetti Aniiiii
          Align(
            alignment: Alignment.topCenter,

            child: ConfettiWidget(
              confettiController: _confettiController,

              blastDirectionality: BlastDirectionality.explosive,

              shouldLoop: false,

              colors: const [
                Colors.deepPurple,

                Colors.purple,

                Colors.blue,

                Colors.green,

                Colors.orange,
              ],
            ),
          ),

          // Tha Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  // Celebration it is  Icon
                    // Show selected avatar in a circle
                    AnimatedContainer(
                    duration: const Duration(seconds: 1),

                    curve: Curves.elasticOut,

                    width: 150,

                    height: 150,

                    decoration: BoxDecoration(
                      color: Colors.deepPurple,

                      shape: BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.5),

                          blurRadius: 20,

                          spreadRadius: 5,
                        ),
                      ],
                    ),

                    child: Center(
                      child: Text(
                        widget.avatar,
                        style: const TextStyle(fontSize: 60),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Personalized Welcome Message
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Welcome, ${widget.userName}! 🎉',

                        textAlign: TextAlign.center,

                        textStyle: const TextStyle(
                          fontSize: 28,

                          fontWeight: FontWeight.bold,

                          color: Colors.deepPurple,
                        ),

                        speed: const Duration(milliseconds: 100),
                      ),
                    ],

                    totalRepeatCount: 1,
                  ),

                  const SizedBox(height: 20),

                  const SizedBox(height: 8),

                  const Text(
                    'Your adventure begins now!',

                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  // Badges
                  if (widget.badges.isNotEmpty) ...[
                    const Text('Achievements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.badges.map((b) {
                        IconData icon = Icons.emoji_events;
                        if (b.contains('Early Bird')) icon = Icons.wb_sunny;
                        if (b.contains('Password')) icon = Icons.lock;
                        return Chip(
                          avatar: Icon(icon, color: Colors.white, size: 18),
                          label: Text(b),
                          backgroundColor: Colors.deepPurpleAccent,
                          labelStyle: const TextStyle(color: Colors.white),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),
                  ],

                  const SizedBox(height: 50),

                  // Daaa... Continue Button
                  ElevatedButton(
                    onPressed: () {
                      _confettiController.play();
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,

                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),

                    child: const Text(
                      'More Celebration!',

                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
