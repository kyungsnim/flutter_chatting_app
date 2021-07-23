import 'package:flutter/material.dart';

appBarMain(BuildContext context) {
  return AppBar(
    title: Text('Flutter Chat'),
  );
}

textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
          color: Colors.white70
      ),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white54)
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white54)
      )
  );
}

simpleTextFieldStyle() {
  return TextStyle(
    color: Colors.white70,
    fontSize: 18
  );
}