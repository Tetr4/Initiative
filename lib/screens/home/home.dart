import 'package:flutter/material.dart';
import 'package:initiative/model/participant.dart';
import 'package:initiative/screens/home/battle/battle.dart';
import 'package:initiative/screens/home/landing/landing.dart';
import 'package:initiative/screens/lineup/lineup.dart';

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

  @override
  Widget build(BuildContext context) {
    return _lineup.isEmpty
        ? LandingBody(_selectLineupAndStartBattle)
        : StageBody(_endBattle, _lineup);
  }
}
