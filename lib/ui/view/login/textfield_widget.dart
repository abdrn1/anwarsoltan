import 'package:anwar_alsultan/config/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;

  TextFieldWidget({
    this.controller,
    this.hint,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: 50,
      width: size.width * 0.6,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        controller: controller,
        obscureText: obscureText,
      ),
    );
  }
}
