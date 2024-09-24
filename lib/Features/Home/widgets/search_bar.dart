// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController? searchTextController;
  final void Function(String)? onChanged;
  const SearchTextField({
    Key? key,
    this.searchTextController,
    required this.onChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchTextController,
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: 'find a Character',
        hintStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      onChanged: onChanged,
    );
  }
}
