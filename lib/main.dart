// This sample shows adding an action to an [AppBar] that opens a shopping cart.

import 'package:flutter/material.dart';
import 'package:initiative/screens/battle/battle.dart';

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
      home: BattleScreen(),
    );
  }
}

