import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingCOntroller;
  final bool isPass;
  final String hinttext;
  final IconData icon;

  const TextFieldInput({
    super.key,
    required this.textEditingCOntroller,
    this.isPass = false,
    required this.icon,
    required this.hinttext,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPass,
      controller: textEditingCOntroller,
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: const TextStyle(color: Colors.black45, fontSize: 18),
        prefixIcon: Icon(
          icon,
          color: Colors.black45,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: InputBorder.none,
        filled: true,
        fillColor: Color(0xFFedf0f8),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Colors.blue),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
