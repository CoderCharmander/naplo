import 'dart:io';

import 'package:filcnaplo/theme/colors/dark_desktop.dart';
import 'package:filcnaplo/theme/colors/dark_mobile.dart';
import 'package:filcnaplo/theme/colors/light_desktop.dart';
import 'package:filcnaplo/theme/colors/light_mobile.dart';
import 'package:flutter/material.dart';

class AppColors {
  static ThemeAppColors of(BuildContext context) => fromBrightness(Theme.of(context).brightness);

  static fromBrightness(Brightness brightness) {
    if (Platform.isAndroid || Platform.isIOS) {
      switch (brightness) {
        case Brightness.light:
          return LightMobileAppColors();
        case Brightness.dark:
          return DarkMobileAppColors();
      }
    } else {
      switch (brightness) {
        case Brightness.light:
          return LightDesktopAppColors();
        case Brightness.dark:
          return DarkDesktopAppColors();
      }
    }
  }
}

abstract class ThemeAppColors {
  final Color shadow = const Color(0x00000000);
  final Color text = const Color(0x00000000);
  final Color background = const Color(0x00000000);
  final Color highlight = const Color(0x00000000);
  final Color red = const Color(0x00000000);
  final Color orange = const Color(0x00000000);
  final Color yellow = const Color(0x00000000);
  final Color green = const Color(0x00000000);
  final Color filc = const Color(0x00000000);
  final Color teal = const Color(0x00000000);
  final Color blue = const Color(0x00000000);
  final Color indigo = const Color(0x00000000);
  final Color purple = const Color(0x00000000);
  final Color pink = const Color(0x00000000);
}
