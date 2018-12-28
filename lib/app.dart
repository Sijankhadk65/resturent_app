import 'package:flutter/material.dart';
import "screens/homeScreen.dart";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Hotel Yak & Yeti',
      theme: buildThemeData(),
      home: MyHomePage(),
    );
  }
}

ThemeData buildThemeData() {
  final appTheme = ThemeData.light();
  return appTheme.copyWith(
      primaryColor: Colors.deepOrange[400],
      primaryColorDark: Colors.deepOrangeAccent[200],
      accentColor: Colors.blueGrey,
      tabBarTheme: TabBarTheme(
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.blueGrey, width: 3.0))),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blueGrey,
      ));
}
