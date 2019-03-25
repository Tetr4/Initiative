import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:initiative/model/group.dart';
import 'package:initiative/model/participant.dart';
import 'package:initiative/screens/groups.dart';

class BattleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  final List<Participant> participants = [];

  _addGroup(Group group) => setState(() {
        participants.addAll(group.adventurers);
      });

  _removeParticipant(Participant participant) => setState(() {
        participants.remove(participant);
      });

  _addParticipant(Participant participant, int index) => setState(() {
        participants.insert(index, participant);
      });

  _selectGroup(BuildContext context) async {
    final Group group = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupsScreen(),
        fullscreenDialog: true,
      ),
    );
    if (group != null) {
      _addGroup(group);
    }
  }

  _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Participant item = participants.removeAt(oldIndex);
      participants.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lineup'),
        actions: participants.isEmpty ? [] : [_buildInitiativeButton(context)],
      ),
      body: participants.isEmpty
          ? _buildEmptyState()
          : Scrollbar(
              child: Builder(builder: _buildParticipantList),
            ),
      floatingActionButton: _buildAddParticipantButton(context),
    );
  }

  Widget _buildInitiativeButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.casino),
      tooltip: 'Roll initiative',
      onPressed: () {
        // TODO
      },
    );
  }

  Widget _buildAddParticipantButton(BuildContext context) {
    return SpeedDial(
      child: Icon(Icons.add),
//      animatedIcon: AnimatedIcons.add_event, // TODO add_close icon?
      tooltip: 'Add participant',
      children: [
        SpeedDialChild(
          child: Icon(Icons.bug_report),
          backgroundColor: Colors.red,
          label: 'NPC',
          onTap: () => print('FIRST CHILD'),
        ),
        SpeedDialChild(
          child: Icon(Icons.face),
          backgroundColor: Colors.blue,
          label: 'Adventurer',
          onTap: () => print('SECOND CHILD'),
        ),
        SpeedDialChild(
          child: Icon(Icons.group),
          backgroundColor: Colors.green,
          label: 'Group',
          onTap: () => _selectGroup(context),
        ),
      ],
    );
  }

  _buildEmptyState() {
    // TODO use animated svg: https://github.com/2d-inc/Flare-Flutter
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/battle_swords.png',
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
          ),
          Padding(
              padding: EdgeInsets.only(top: 32, bottom: 16),
              child: Text(
                'No active battle.',
                style: Theme.of(context).textTheme.title,
              )),
          Text(
            'Add participants to start the battle.',
            style: Theme.of(context).textTheme.subtitle,
          )
        ],
      ),
    );
  }

  Widget _buildParticipantList(BuildContext context) {
    return ReorderableListView(
      onReorder: _onReorder,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: participants
          .map((participant) => LineupItem(
                key: ObjectKey(participant),
                participant: participant,
                onDismissed: (direction) {
                  final index = participants.indexOf(participant);
                  _removeParticipant(participant);
                  _showUndoBar(context, participant, index);
                },
              ))
          .toList(),
    );
  }

  void _showUndoBar(BuildContext context, Participant participant, int index) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("${participant.name} removed"),
      action: SnackBarAction(
        label: "undo",
        onPressed: () => _addParticipant(participant, index),
      ),
    ));
  }
}

class LineupItem extends StatelessWidget {
  final Participant participant;
  final ConfirmDismissCallback onDismissed;

  LineupItem({Key key, @required this.participant, @required this.onDismissed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final participant = this.participant; // required for smart cast
    return Dismissible(
      background: Container(color: Theme.of(context).primaryColor),
      key: ObjectKey(participant),
      onDismissed: onDismissed,
      child: participant is Adventurer
          ? ListTile(
              leading: Icon(Icons.face),
              title: Text(participant.name),
              subtitle: Text(participant.description),
              trailing: Icon(Icons.drag_handle),
            )
          : ListTile(
              leading: Icon(Icons.bug_report),
              title: Text(participant.name),
              trailing: Icon(Icons.drag_handle),
            ),
    );
  }
}
