import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obsecureText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final IconData? icon;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obsecureText,
    required this.controller,
    this.focusNode,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextField(
          obscureText: obsecureText,
          controller: controller,
          focusNode: focusNode,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade700),
            prefixIcon: icon != null ? Icon(
              icon,
              color: Colors.black,
            ) : null,
          ),
        ),
      ),
    );
  }
}
