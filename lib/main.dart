import 'package:flutter/material.dart';
import 'package:weather_app/presentation/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {'/': (_) => HomeScreen()},
    );
  }
}
