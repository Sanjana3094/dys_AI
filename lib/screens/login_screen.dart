import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'welcome_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildOverlay(),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/background1.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(color: Colors.black.withOpacity(0.3));
  }

  Widget _buildContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/logo.png', width: 140),
          const SizedBox(height: 15),
          const Text(
            'DYS-Ai',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 35),
          _buildSignInButtons(context),
          const SizedBox(height: 25),
          _buildSignUpText(),
        ],
      ),
    );
  }

  Widget _buildSignInButtons(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: "Sign in with Email",
          icon: Icons.email,
          color: Colors.green,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: "Sign in with Phone number",
          icon: Icons.phone,
          color: Colors.transparent,
          borderColor: Colors.white,
          textColor: Colors.white,
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: "Sign in with Apple",
          icon: Icons.apple,
          color: Colors.transparent,
          borderColor: Colors.white,
          textColor: Colors.white,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSignUpText() {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Don't have an account? Sign up",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
