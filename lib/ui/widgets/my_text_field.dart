import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  var keyboardType;
  TextEditingController controller = TextEditingController();

  MyTextField({
    required this.labelText,
    required this.hintText,
    required this.keyboardType,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: 18,
        ),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      keyboardType: keyboardType,
      controller: controller,
    );
  }
}
