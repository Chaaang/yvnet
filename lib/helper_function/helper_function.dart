import 'package:flutter/material.dart';

void displayErrorMessage(String message, BuildContext context){
  showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text(message),
    ));
}

void progressIndication(context){
      showDialog(
      context: context, 
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: Colors.amber[400],
        ),
    ));
}

  void showSnackBar(String snackText, Duration d, BuildContext context){
    final snackbar = SnackBar(content: Text(snackText), duration: d,);

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

    Color convertStringToColor(String colorName) {
    // Use Colors class to get a predefined color
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'yellow':
        return Color(0xFFFFCA28);
      default:
        // If the color name is not recognized, return a default color
        return Colors.red;
    }
    }