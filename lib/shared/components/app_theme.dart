import 'package:flutter/material.dart';

class AppTheme {
  static ColorScheme colorScheme() {
    return ColorScheme.fromSeed(
      seedColor: const Color(0xffBE93E4),
      primary: const Color(0xffBE93E4),
      primaryContainer: const Color(0xffF9F1FE),
      onPrimaryContainer: const Color(0xffD3B4ED),
      secondary: const Color(0xff3A5CCC),
      secondaryContainer: const Color(0xffF0F4FF),
      onSecondaryContainer: const Color(0xff8DA4EF),
      outline: const Color(0xffBE93E4),
    );
  }

  static InputBorder chatInputBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xffBE93E4), width: 1),
      );
}
