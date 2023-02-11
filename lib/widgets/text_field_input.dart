import 'package:flutter/material.dart';
import 'package:insta_flutter/utils/colors.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;

  const TextFieldInput(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.keyboardType,
      this.isPassword = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
          contentPadding: EdgeInsets.all(8.0),
          border: inputBorder,
          enabledBorder: inputBorder,
          focusedBorder: inputBorder,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
          )),
    );
  }
}
