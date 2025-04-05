import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    this.textColor = Colors.black,
    this.borderColor = Colors.transparent,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: borderColor, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        icon: Icon(icon, color: textColor),
        label: Text(
          text,
          style: TextStyle(fontSize: 16, color: textColor),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
