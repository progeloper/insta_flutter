import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? callback;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;
  final String buttonText;

  const FollowButton(
      {Key? key,
      this.callback,
      required this.borderColor,
      required this.backgroundColor,
      required this.buttonText,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      // width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: callback,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            buttonText,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
