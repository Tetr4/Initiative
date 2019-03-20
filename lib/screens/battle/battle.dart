import 'package:flutter/material.dart';
import 'package:initiative/model/participant.dart';
import 'package:initiative/screens/lineup/lineup.dart';

class BattleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
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

  _lineUpAndStartBattle(BuildContext context) async {
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
        ? LandingBody(_lineUpAndStartBattle)
        : StageBody(_endBattle, _lineup);
  }
}

class LandingBody extends StatelessWidget {
  final Function(BuildContext) onStartLineup;

  LandingBody(this.onStartLineup, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Battle')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Battle not started yet.'),
            RaisedButton(
              child: const Text("FIGHT!"),
              onPressed: () => onStartLineup(context),
            )
          ],
        ),
      ),
    );
  }
}

class StageBody extends StatelessWidget {
  final VoidCallback onEndBattle;
  final List<Participant> lineup;

  StageBody(this.onEndBattle, this.lineup, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battle'),
        actions: <Widget>[
          PopupMenuButton<VoidCallback>(
            onSelected: (callback) => callback(),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: onEndBattle, child: Text("End Battle")),
              ];
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: lineup.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${lineup[index].name}'),
            trailing: Icon(Icons.drag_handle),
          );
        },
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {},
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ),
    );
  }
}
