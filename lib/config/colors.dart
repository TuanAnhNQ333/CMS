
import 'package:flutter/material.dart';

class ThemeColors {
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color tertiaryTextColor;
  final Color mainColor;
  final Color oppositeColor;

  ThemeColors(
      {required this.primaryTextColor,
        required this.secondaryTextColor,
        required this.tertiaryTextColor,
        required this.mainColor,
        required this.oppositeColor
      });
}

final lightColors = ThemeColors(
  primaryTextColor: Colors.black,
  secondaryTextColor: Colors.black.withOpacity(0.7),
  tertiaryTextColor: Colors.black.withOpacity(0.5),
  mainColor: Colors.white,
  oppositeColor: Colors.black,
);

final darkColors = ThemeColors(
  primaryTextColor: Colors.white,
  secondaryTextColor: Colors.white.withOpacity(0.7),
  tertiaryTextColor: Colors.white.withOpacity(0.5),
  mainColor: Colors.black,
  oppositeColor: Colors.white,

);
