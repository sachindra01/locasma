// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:locasma/common/styles.dart';

class CustomTextField extends StatefulWidget {
  final controller, textCapitalization, obscureText, textInputAction, validator;
  const CustomTextField(
      {Key? key,
      this.controller,
      @required this.obscureText,
      @required this.textCapitalization,
      @required this.textInputAction,
      this.validator})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 46.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: const Border(
            top: BorderSide(width: 1, color: textFieldBorder),
            left: BorderSide(width: 1, color: textFieldBorder),
            right: BorderSide(width: 1, color: textFieldBorder),
            bottom: BorderSide(width: 1, color: textFieldBorder),
          )),
      child: TextFormField(
        controller: widget.controller,
        cursorColor: black,
        cursorHeight: 18.0,
        cursorRadius: const Radius.circular(5),
        obscureText: widget.obscureText,
        textCapitalization: widget.textCapitalization,
        textInputAction: widget.textInputAction,
        validator: widget.validator,
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
            fillColor: textfieldColor,
            filled: true,
            border: InputBorder.none),
      ),
    );
  }
}
