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

  _addGroup(Group group) {
    setState(() {
      participants.addAll(group.heroes);
    });
  }

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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            tooltip: 'Start battle',
            onPressed: () {
              Navigator.pop(context, participants);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: participants.length,
        itemBuilder: (context, index) {
          final participant = participants[index];
          return Dismissible(
            background: Container(color: Colors.red),
            key: Key(participant.name),
            onDismissed: (direction) {
              setState(() {
                participants.removeAt(index);
              });
              Scaffold
                  .of(context)
                  .showSnackBar(SnackBar(content: Text("${participant.name} dismissed")));
            },
            child: ListTile(
              title: Text('${participants[index].name}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectGroup(context);
        },
        tooltip: 'Add participant',
        child: Icon(Icons.add),
      ),
    );
  }
}
