import 'package:flutter/material.dart';

class PaymentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final bool isDarkMode = false;

  const PaymentButton({Key? key, required this.onPressed, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
      ),
      child: Text(
        'Pagar',
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      ),
    );
  }
}
