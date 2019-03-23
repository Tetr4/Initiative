import 'package:flutter/material.dart';
import 'package:initiative/model/participant.dart';
import 'package:initiative/screens/home_body/battle.dart';
import 'package:initiative/screens/home_body/landing.dart';
import 'package:initiative/screens/lineup.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Participant> _lineup = [];

  _startBattle(List<Participant> participants) {
    setState(() {
      _lineup = participants;
    });
  }

  _endBattle() {
    setState(() {
      _lineup = [];
    });
  }

  _selectLineupAndStartBattle(BuildContext context) async {
    final List<Participant> lineup = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LineupScreen()),
    );
    if (lineup != null && lineup.isNotEmpty) {
      _startBattle(lineup);
    }
  }

  List<Widget> _buildBattleActions(BuildContext context) => <Widget>[
        PopupMenuButton<VoidCallback>(
          onSelected: (callback) => callback(),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: _endBattle,
                child: Text("End Battle"),
              ),
            ];
          },
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battle'),
        actions: _lineup.isEmpty ? null : _buildBattleActions(context),
      ),
      body: _lineup.isEmpty
          ? LandingBody(_selectLineupAndStartBattle)
          : BattleBody(_endBattle, _lineup),
      floatingActionButton: _lineup.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () {},
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ),
    );
  }
}
