import 'package:flutter/material.dart';

extension Ext on BuildContext {
  double get height => MediaQuery.of(this).size.height;

  double get width => MediaQuery.of(this).size.width;

  EdgeInsets get mqPadding => MediaQuery.of(this).padding;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  InputDecorationTheme get inputDecorationTheme =>
      Theme.of(this).inputDecorationTheme;

  ThemeData get theme => Theme.of(this);

  Brightness get brightness => Theme.of(this).brightness;

  NavigatorState get navigator => Navigator.of(this);


}
