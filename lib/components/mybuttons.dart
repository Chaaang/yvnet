import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  Color? color;
  MyButton({super.key, required this.text, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    Color? buttonColor = color ??Colors.amber[400];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: buttonColor ),
        padding: const EdgeInsets.all(25),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),),
        ),
      ),
    );
  }
}