import 'package:flutter/material.dart';
import 'package:flutter_weather_app/Screen/home.dart';





void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateful Widget Scaffold Example',
      home: Home(),
    );
  }
}