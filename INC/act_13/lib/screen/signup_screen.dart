import 'package:flutter/material.dart';

import 'package:confetti/confetti.dart';

import 'success_screen.dart';

// Signup Screen w/ Interactive Form

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _dobController = TextEditingController();

  bool _isPasswordVisible = false;

  bool _isLoading = false;

  // Avatar selection (emoji used for simplicity)
  String _selectedAvatar = '🧭';

  // Password strength: 0=empty/weak, 1=weak, 2=medium, 3=strong
  int _passwordStrength = 0;

  // Progress tracker (0.0-1.0)
  double _progress = 0.0;

  // Last milestone reached (0,25,50,75,100)
  int _lastMilestone = 0;

  // Confetti for milestones
  late final ConfettiController _milestoneConfetti;

  @override
  void dispose() {
    _nameController.dispose();

    _emailController.dispose();

    _passwordController.dispose();

    _dobController.dispose();

    _milestoneConfetti.dispose();

    _nameController.removeListener(_updateProgressFromListeners);
    _emailController.removeListener(_updateProgressFromListeners);
    _passwordController.removeListener(_updatePasswordAndProgress);
    _dobController.removeListener(_updateProgressFromListeners);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _milestoneConfetti = ConfettiController(duration: const Duration(seconds: 1));

    // update progress & strength as user types
    _nameController.addListener(_updateProgressFromListeners);
    _emailController.addListener(_updateProgressFromListeners);
    _passwordController.addListener(_updatePasswordAndProgress);
    _dobController.addListener(_updateProgressFromListeners);

    _updateProgressFromListeners();
    _updatePasswordAndProgress();
  }

  void _updateProgressFromListeners() {
    int filled = 0;
    if (_nameController.text.trim().isNotEmpty) filled++;
    if (_emailController.text.trim().isNotEmpty) filled++;
    if (_passwordController.text.isNotEmpty) filled++;
    if (_dobController.text.isNotEmpty) filled++;

    double newProgress = (filled / 4.0).clamp(0.0, 1.0);

    setState(() {
      _progress = newProgress;
    });

    _checkMilestone();
  }

  void _updatePasswordAndProgress() {
    final pw = _passwordController.text;
    int strength = _computePasswordStrength(pw);
    setState(() {
      _passwordStrength = strength;
    });
    _updateProgressFromListeners();
  }

  int _computePasswordStrength(String pw) {
    if (pw.isEmpty) return 0;
    int score = 0;
    if (pw.length >= 6) score++;
    if (RegExp(r'[A-Z]').hasMatch(pw) && RegExp(r'[a-z]').hasMatch(pw)) score++;
    if (RegExp(r'\d').hasMatch(pw)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(pw) && pw.length >= 8) score++;

    // normalize to 0..3
    if (score >= 4) return 3;
    if (score >= 3) return 2;
    if (score >= 1) return 1;
    return 0;
  }

  void _checkMilestone() {
    int percent = (_progress * 100).round();
    int milestone = 0;
    if (percent >= 100) milestone = 100;
    else if (percent >= 75) milestone = 75;
    else if (percent >= 50) milestone = 50;
    else if (percent >= 25) milestone = 25;

    if (milestone > _lastMilestone && milestone > 0) {
      _lastMilestone = milestone;
      _milestoneConfetti.play();

      String message = '';
      if (milestone == 25) message = 'Nice start! 25% done — keep going!';
      if (milestone == 50) message = 'Halfway there! 50% complete — great work!';
      if (milestone == 75) message = 'So close! 75% done — almost there!';
      if (milestone == 100) message = 'All set! 100% complete — ready for adventure!';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Date Picker Function

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime(1900),

      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
      _updateProgressFromListeners();
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return; // Check if the widget is still in the tree

        setState(() {
          _isLoading = false;
        });

        // Build badges
        final List<String> badges = [];
        if (_passwordStrength >= 3) badges.add('Strong Password Master');
        final now = DateTime.now();
        if (now.hour < 12) badges.add('The Early Bird Special');
        if (_progress >= 1.0) badges.add('Profile Completer - Filled all fields');

        Navigator.pushReplacement(
          context,

          MaterialPageRoute(
            builder: (context) => SuccessScreen(
              userName: _nameController.text,
              avatar: _selectedAvatar,
              badges: badges,
            ),
          ),
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Account 🎉'),

        backgroundColor: Colors.deepPurple,

        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),

        child: SingleChildScrollView(
          child: Form(
            key: _formKey,

            child: Column(
              children: [
                // Animated Form Header
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),

                  curve: Curves.easeInOut,

                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100],

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Row(
                    children: [
                      Icon(
                        Icons.tips_and_updates,

                        color: Colors.deepPurple[800],
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          'Complete your adventure profile!',

                          style: TextStyle(
                            color: Colors.deepPurple[800],

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Milestone confetti (top-centered)
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _milestoneConfetti,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [Colors.deepPurple, Colors.purple, Colors.blue, Colors.green],
                    numberOfParticles: 20,
                    maxBlastForce: 20,
                  ),
                ),

                // Progress bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: _progress,
                            minHeight: 10,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('${(_progress * 100).round()}%'),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),

                // Avatar selection
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Choose an avatar', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: ['🧭', '🦊', '🐲', '🪐'].map((a) {
                        final bool selected = _selectedAvatar == a;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedAvatar = a;
                              });
                            },
                            child: CircleAvatar(
                              radius: selected ? 26 : 22,
                              backgroundColor: selected ? Colors.deepPurple : Colors.grey[200],
                              child: Text(a, style: TextStyle(fontSize: selected ? 26 : 22)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

                // Name Field
                _buildTextField(
                  controller: _nameController,

                  label: 'Adventure Name',

                  icon: Icons.person,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'What should we call you on this adventure?';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Email Field
                _buildTextField(
                  controller: _emailController,

                  label: 'Email Address',

                  icon: Icons.email,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'We need your email for adventure updates!';
                    }

                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Oops! That doesn\'t look like a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // DOB w/Calendar
                TextFormField(
                  controller: _dobController,

                  readOnly: true,

                  onTap: _selectDate,

                  decoration: InputDecoration(
                    labelText: 'Date of Birth',

                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.deepPurple,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    filled: true,

                    fillColor: Colors.grey[50],

                    suffixIcon: IconButton(
                      icon: const Icon(Icons.date_range),

                      onPressed: _selectDate,
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'When did your adventure begin?';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Pswd Field w/ Toggle
                TextFormField(
                  controller: _passwordController,

                  obscureText: !_isPasswordVisible,

                  decoration: InputDecoration(
                    labelText: 'Secret Password',

                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.deepPurple,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    filled: true,

                    fillColor: Colors.grey[50],

                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,

                        color: Colors.deepPurple,
                      ),

                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Every adventurer needs a secret password!';
                    }

                    if (value.length < 6) {
                      return 'Make it stronger! At least 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // Password strength meter
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _passwordStrength == 0
                          ? 'Password strength: Empty'
                          : _passwordStrength == 1
                              ? 'Password strength: Weak'
                              : _passwordStrength == 2
                                  ? 'Password strength: Medium'
                                  : 'Password strength: Strong',
                      style: TextStyle(
                        color: _passwordStrength == 0
                            ? Colors.grey
                            : _passwordStrength == 1
                                ? Colors.red
                                : _passwordStrength == 2
                                    ? Colors.orange
                                    : Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (_passwordStrength / 3.0).clamp(0.0, 1.0),
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(_passwordStrength <= 1
                            ? Colors.red
                            : _passwordStrength == 2
                                ? Colors.orange
                                : Colors.green),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),

                // Submit Button w/ Loading Animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),

                  width: _isLoading ? 60 : double.infinity,

                  height: 60,

                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.deepPurple,
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _submitForm,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),

                            padding: const EdgeInsets.symmetric(vertical: 16),

                            elevation: 5,
                          ),

                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text(
                                'Start My Adventure',

                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),

                              SizedBox(width: 10),

                              Icon(Icons.rocket_launch, color: Colors.white),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,

    required String label,

    required IconData icon,

    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,

      decoration: InputDecoration(
        labelText: label,

        prefixIcon: Icon(icon, color: Colors.deepPurple),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

        filled: true,

        fillColor: Colors.grey[50],
      ),

      validator: validator,
    );
  }
}
