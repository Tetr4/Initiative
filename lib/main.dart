import 'package:flutter/material.dart';
import 'package:initiative/screens/home/home.dart';

void main() => runApp(InitiativeApp());

class InitiativeApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Initiative App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark
      ),
      home: HomeScreen(),
    );
  }
}

