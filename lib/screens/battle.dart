import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:initiative/model/battle.dart';
import 'package:initiative/model/data.dart';
import 'package:initiative/screens/dialogs/add_npc.dart';
import 'package:initiative/screens/dialogs/roll_initiative.dart';
import 'package:initiative/screens/groups.dart';
import 'package:scoped_model/scoped_model.dart';

class BattleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  final List<Character> initiativeUndetermined = [];
  final Map<Character, int> initiatives = Map();
  BattleModel battle;

  Future<void> _selectGroup(BuildContext context) async {
    final Group group = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupsScreen(),
        fullscreenDialog: true,
      ),
    );
    if (group != null) {
      battle.addGroup(group);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<BattleModel>(
        builder: (context, child, battle) {
      this.battle = battle;
      return Scaffold(
        appBar: AppBar(
          title: Text('Battle'),
          actions: battle.isActive ? _buildBattleButtons(context) : [],
        ),
        body: battle.isActive
            ? Scrollbar(child: Builder(builder: _buildParticipantList))
            : EmptyBattleBody(),
        floatingActionButton: _buildAddParticipantButton(context),
      );
    });
  }

  List<Widget> _buildBattleButtons(BuildContext context) =>
      [_buildInitiativeButton(context), _buildEndBattleButton(context)];

  Widget _buildInitiativeButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.casino),
      tooltip: 'Roll initiative',
      onPressed: () {
        initiatives.clear();
        initiativeUndetermined.clear();
        initiativeUndetermined.addAll(battle.participants);
        _showNextInitiativeDialog();
      },
    );
  }

  Widget _buildEndBattleButton(BuildContext context) {
    return PopupMenuButton<VoidCallback>(
      onSelected: (callback) => callback(),
      itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: () {
                final removedParticipants = battle.participants.toList();
                battle.clear();
                _showUndoClearBar(context, removedParticipants);
              },
              child: Text("End Battle"),
            ),
          ],
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
          onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) =>
                    NpcDialog(onCreate: battle.addParticipant),
              ),
        ),
//        SpeedDialChild(
//          child: Icon(Icons.face),
//          backgroundColor: Colors.blue,
//          label: 'Adventurer',
//          onTap: () => print('SECOND CHILD'),
//        ),
        SpeedDialChild(
          child: Icon(Icons.group),
          backgroundColor: Colors.green,
          label: 'Group',
          onTap: () => _selectGroup(context),
        ),
      ],
    );
  }

  Widget _buildParticipantList(BuildContext context) {
    return ReorderableListView(
      onReorder: battle.reorder,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: battle.participants
          .map((participant) => LineupItem(
                key: ObjectKey(participant),
                participant: participant,
                onDismissed: (direction) {
                  final index = battle.participants.indexOf(participant);
                  battle.removeParticipant(participant);
                  _showUndoRemoveBar(context, participant, index);
                },
              ))
          .toList(),
    );
  }

  void _showNextInitiativeDialog() {
    if (initiativeUndetermined.isEmpty) {
      battle.reorderByInitiative(initiatives);
    } else {
      final participant = initiativeUndetermined.removeAt(0);
      showDialog(
        context: context,
        builder: (BuildContext context) => InitiativeDialog(
              participant: participant,
              onRolled: (initiative) {
                // TODO handle ties
                initiatives[participant] = initiative;
                _showNextInitiativeDialog();
              },
            ),
      );
    }
  }

  void _showUndoRemoveBar(
      BuildContext context, Character participant, int index) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("${participant.name} removed"),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () => battle.addParticipantAt(participant, index),
      ),
    ));
  }

  void _showUndoClearBar(BuildContext context, List<Character> participants) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Battle ended"),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () => battle.addParticipants(participants),
      ),
    ));
  }
}

class EmptyBattleBody extends StatelessWidget {
  // TODO use animated svg: https://github.com/2d-inc/Flare-Flutter

  @override
  Widget build(BuildContext context) {
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
}

class LineupItem extends StatelessWidget {
  final Character participant;
  final ConfirmDismissCallback onDismissed;

  LineupItem({
    Key key,
    @required this.participant,
    @required this.onDismissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final participant = this.participant; // required for smart cast
    return Dismissible(
      background: Container(color: Theme.of(context).primaryColor),
      key: ObjectKey(participant),
      onDismissed: onDismissed,
      child: participant.type == CharacterType.ADVENTURER
          ? ListTile(
              leading: CircleAvatar(child: Icon(Icons.face)),
              title: Text(participant.name),
              subtitle: Text(participant.description),
              trailing: Icon(Icons.drag_handle),
            )
          : ListTile(
              leading: CircleAvatar(child: Icon(Icons.bug_report)),
              title: Text(participant.name),
              trailing: Icon(Icons.drag_handle),
            ),
    );
  }
}
