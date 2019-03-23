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

  bool get _activeBattle => _lineup.isNotEmpty;

  _startBattle(List<Participant> participants) => setState(() {
        _lineup = participants;
      });

  _endBattle() => setState(() {
        _lineup = [];
      });

  _selectLineupAndStartBattle(BuildContext context) async {
    final List<Participant> lineup = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LineupScreen()),
    );
    if (lineup != null && lineup.isNotEmpty) {
      _startBattle(lineup);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battle'),
        actions: _activeBattle ? [_buildEndBattleButton(context)] : [],
      ),
      body: _activeBattle
          ? BattleBody(_endBattle, _lineup)
          : LandingBody(_selectLineupAndStartBattle),
      floatingActionButton: _activeBattle ? _buildAddParticipantButton() : null,
    );
  }

  Widget _buildEndBattleButton(BuildContext context) {
    return PopupMenuButton<VoidCallback>(
      onSelected: (callback) => callback(),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: _endBattle,
            child: Text("End Battle"),
          ),
        ];
      },
    );
  }

  FloatingActionButton _buildAddParticipantButton() {
    return FloatingActionButton(
      onPressed: () {
        // TODO
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );
  }
}
