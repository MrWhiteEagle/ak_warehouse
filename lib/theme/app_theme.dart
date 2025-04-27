import 'package:flutter/material.dart';

ThemeData regular() {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 207, 16, 93),
      onPrimary: Colors.white,
      secondary: const Color.fromARGB(255, 255, 217, 0),
      onSecondary: const Color.fromARGB(255, 160, 64, 0),
      error: const Color.fromARGB(255, 167, 11, 0),
      onError: Colors.white,
      surface: Colors.grey.shade200,
      onSurface: Colors.black,
    ),
  );
}
