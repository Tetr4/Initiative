import 'package:flutter/material.dart';
import 'package:initiative/model/group.dart';
import 'package:initiative/model/participant.dart';
import 'package:initiative/screens/groups.dart';

class LineupScreen extends StatefulWidget {
  LineupScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LineupScreenState();
}

class _LineupScreenState extends State<LineupScreen> {
  final List<Participant> participants = [];

  _addGroup(Group group) => setState(() {
        participants.addAll(group.heroes);
      });

  _removeParticipant(int index) => setState(() {
        participants.removeAt(index);
      });

  _addParticipant(Participant participant, int index) => setState(() {
        participants.insert(index, participant);
      });

  _selectGroup(BuildContext context) async {
    final Group group = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupsScreen()),
    );
    if (group != null) {
      _addGroup(group);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lineup'),
        actions: participants.isEmpty ? [] : [_buildStartBattleButton(context)],
      ),
      body: ListView.builder(
        itemCount: participants.length,
        itemBuilder: _buildParticipantItem,
      ),
      floatingActionButton: _buildAddParticipantButton(context),
    );
  }

  Widget _buildStartBattleButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.check),
      tooltip: 'Start battle',
      onPressed: () {
        Navigator.pop(context, participants);
      },
    );
  }

  Widget _buildParticipantItem(BuildContext context, int index) {
    final participant = participants[index];
    return Dismissible(
      background: Container(color: Theme.of(context).primaryColor),
      key: ObjectKey(participant),
      onDismissed: (direction) {
        _removeParticipant(index);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("${participant.name} dismissed"),
          action: SnackBarAction(
              label: "undo",
              onPressed: () {
                _addParticipant(participant, index);
              }),
        ));
      },
      child: ListTile(
        title: Text('${participants[index].name}'),
      ),
    );
  }

  Widget _buildAddParticipantButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _selectGroup(context);
      },
      tooltip: 'Add participant',
      child: Icon(Icons.add),
    );
  }
}
