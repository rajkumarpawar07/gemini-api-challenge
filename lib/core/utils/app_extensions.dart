import 'package:flutter/material.dart';
export 'package:gemini_api_challenge/shared/components/dimens.dart';

extension BuildContextExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;
}
