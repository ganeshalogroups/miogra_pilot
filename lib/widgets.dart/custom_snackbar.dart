import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String message;

  const CustomSnackBar({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16.0, // Adjust top margin
      left: 15.0,
      right: 15.0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
