// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPress;
  final Widget? label;
  final height, width, elevation, btnColor;
  const CustomButton(
      {Key? key,
      this.onPress,
      this.label,
      this.height,
      this.width,
      this.elevation,
      required this.btnColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPress,
        child: label,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(37.0),
          ),
          elevation: elevation,
          primary: btnColor,
        ),
      ),
    );
  }
}
