import 'package:flutter/material.dart';
import "screens/homeScreen.dart";

import "classes/colorsScheme.dart" as scheme;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Hotel Yak & Yeti',
      theme: buildThemeData(),
      home: SafeArea(child: MyHomePage()),
    );
  }
}

ThemeData buildThemeData() {
  final appTheme = ThemeData.light();
  return appTheme.copyWith(
    primaryColor: scheme.colorScheme().primaryColor,
    accentColor: scheme.colorScheme().accentColor,
    tabBarTheme: TabBarTheme(
        indicator: UnderlineTabIndicator(
            borderSide:
                BorderSide(color: scheme.colorScheme().accentColor, width: 3))),
  );
}
