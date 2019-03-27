import 'package:flutter/material.dart';
import 'package:initiative/model/battle.dart';
import 'package:initiative/screens/battle.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(InitiativeApp());

class InitiativeApp extends StatelessWidget {
  final battle = BattleModel();

  // TODO connect battle model with local persistence repository

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Initiative App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: ScopedModel<BattleModel>(
        model: battle,
        child: BattleScreen(),
      ),
    );
  }
}
