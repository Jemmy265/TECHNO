// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (text) {
        if (text == null || text.trim().isEmpty) {
          return "Please write a post";
        }
        return null;
      },
      controller: controller,
      cursorColor: Colors.black,
      maxLines: null,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        hintText: "What's on your mind?",
        hintStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.add, color: Colors.black),
      ),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        height: 1.5,
      ),
      textAlignVertical: TextAlignVertical.top,
    );
  }
}
