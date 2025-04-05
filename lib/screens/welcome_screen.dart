import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildTitle(),
          const SizedBox(height: 10),
          _buildSubtitle(),
          const SizedBox(height: 20),
          _buildOptionCards(context),
          const SizedBox(height: 20),
          _buildBackToLoginButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Image.asset('assets/images/welcome.jpg', height: 200),
    );
  }

  Widget _buildTitle() {
    return const Text(
      "Nice to meet you!",
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.brown),
    );
  }

  Widget _buildSubtitle() {
    return const Text(
      "Choose your journey to get started",
      style: TextStyle(fontSize: 18, color: Colors.black54),
    );
  }

  Widget _buildOptionCards(BuildContext context) {
    return Column(
      children: [
        _buildOptionCard(
          icon: Icons.track_changes,
          title: "Track my cycle",
          description: "Track period, conception, pregnancy, or perimenopause experiences.",
          onTap: () {},
        ),
        const SizedBox(height: 15),
        _buildOptionCard(
          icon: Icons.link,
          title: "Connect",
          description: "See a partner or companion's important cycle dates.",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildOptionCard({required IconData icon, required String title, required String description, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.brown, size: 28),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown)),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 250,
                      child: Text(description, style: const TextStyle(fontSize: 16, color: Colors.black54)),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.brown),
          ],
        ),
      ),
    );
  }

  Widget _buildBackToLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      },
      child: const Text(
        "Back to Login",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
      ),
    );
  }
}
