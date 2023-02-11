import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_flutter/utils/colors.dart';

pickImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();

  XFile? _file = await _picker.pickImage(source: source);
  if (_file != null) {
    return _file.readAsBytes();
  }
  print('No file was selected');
  return null;
}

showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: TextStyle(
          color: primaryColor,
        ),
      ),
      backgroundColor: mobileSearchColor,
    ),
  );
}
