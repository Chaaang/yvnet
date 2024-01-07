import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final IconData? icon;
  const MyTextField({super.key, required this.hintText, required this.obscureText, required this.controller, required this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hintText,
        hintStyle: const TextStyle( fontSize: 12),
        prefixIcon:  Icon(icon)
        
      ),
      obscureText: obscureText,
    );

}
}