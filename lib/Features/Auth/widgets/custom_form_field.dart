import 'package:flutter/material.dart';

typedef Myvalidator = String? Function(String?);

class CustomFormField extends StatelessWidget {
  final bool isPassword;
  final TextInputType keyboardType;
  final String label;
  final String hint;
  final TextEditingController controller;
  final Myvalidator validator;
  final int lines;
  const CustomFormField({
    super.key,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    required this.label,
    required this.hint,
    required this.validator,
    required this.controller,
    this.lines = 1,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: lines,
      minLines: lines,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: isPassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        fillColor: Colors.black,
        filled: true,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Color(0xff0464BD))),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        labelText: label,
        hintText: hint,
      ),
    );
  }
}
