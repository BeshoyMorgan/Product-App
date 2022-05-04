import 'package:flutter/material.dart';

class TextFieldAuth extends StatelessWidget {
  final String labelText;
  final String hintText;
  var keyboardType;
  TextEditingController controller = TextEditingController();
  final bool obscureText;
  Widget prefixIcon;
  IconButton? suffixIcon;

  TextFieldAuth({
    required this.labelText,
    required this.hintText,
    required this.keyboardType,
    required this.controller,
    required this.obscureText,
    required this.prefixIcon,
    this.suffixIcon,
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
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
    );
  }
}
