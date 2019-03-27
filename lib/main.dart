import 'package:flutter/material.dart';
import 'package:initiative/model/battle.dart';
import 'package:initiative/model/groups.dart';
import 'package:initiative/screens/battle.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final prefs = await SharedPreferences.getInstance();

  final battle = BattleModel(prefs);
  battle.loadData();
  final groups = GroupsModel(prefs);
  groups.loadData();

  runApp(
    ScopedModel<BattleModel>(
      model: battle,
      child: ScopedModel<GroupsModel>(
        model: groups,
        child: InitiativeApp(),
      ),
    ),
  );
}

class InitiativeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Initiative App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: BattleScreen(),
    );
  }
}
