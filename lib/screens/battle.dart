import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:initiative/localization/localization.dart';
import 'package:initiative/model/battle.dart';
import 'package:initiative/model/data.dart';
import 'package:initiative/screens/dialogs/initiative.dart';
import 'package:initiative/screens/dialogs/initiative_tie.dart';
import 'package:initiative/screens/dialogs/npc.dart';
import 'package:initiative/screens/groups.dart';
import 'package:scoped_model/scoped_model.dart';

class BattleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  final Map<Character, Initiative> initiatives = Map();
  BattleModel battle;

  List<Character> get undeterminedInitiatives => battle.participants.toList()
    ..removeWhere((participant) => initiatives[participant] != null);

  List<List<Character>> get ties {
    final Map<Initiative, List<Character>> groups =
        groupBy(initiatives.keys, (character) => initiatives[character]);
    return groups.values.toList()
      ..removeWhere((characters) => characters.length == 1);
  }

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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).titleBattle),
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
      tooltip: AppLocalizations.of(context).tooltipRollInitiative,
      onPressed: () {
        initiatives.clear();
        _startInitiativeDialogs();
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
          child: Text(AppLocalizations.of(context).tooltipEndBattle),
        ),
      ],
    );
  }

  Widget _buildAddParticipantButton(BuildContext context) {
    return SpeedDial(
      child: Icon(Icons.add),
//      animatedIcon: AnimatedIcons.add_event, // TODO add_close icon?
      tooltip: AppLocalizations.of(context).tooltipAddParticipant,
      children: [
        SpeedDialChild(
          child: Icon(Icons.bug_report),
          backgroundColor: Colors.red,
          label: AppLocalizations.of(context).labelNpc,
          onTap: () => _showNpcDialog(),
        ),
        SpeedDialChild(
          child: Icon(Icons.group),
          backgroundColor: Colors.green,
          label: AppLocalizations.of(context).labelGroup,
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
                onDismissed: (direction) async {
                  final index = battle.participants.indexOf(participant);
                  battle.removeParticipant(participant);
                  _showUndoRemoveBar(context, participant, index);
                  return true;
                },
              ))
          .toList(),
    );
  }

  void _showNpcDialog() async {
    final npc = await showDialog(
      context: context,
      builder: (BuildContext context) => NpcDialog(),
    );
    if (npc != null) {
      battle.addParticipant(npc);
    }
  }

  void _startInitiativeDialogs() async {
    while (undeterminedInitiatives.isNotEmpty) {
      final participant = undeterminedInitiatives.first;
      final roll = await showDialog(
        context: context,
        builder: (BuildContext context) =>
            InitiativeDialog(participant: participant),
      );
      if (roll != null) {
        initiatives[participant] = Initiative(roll: roll);
      } else {
        return;
      }
    }
    while (ties.isNotEmpty) {
      final tiedParticipants = ties.first;
      final priorizedCharacter = await showDialog(
        context: context,
        builder: (BuildContext context) => InitiativeTieDialog(
          tiedParticipants: tiedParticipants,
        ),
      );
      if (priorizedCharacter != null) {
        final oldPrio = initiatives[priorizedCharacter];
        final newPrio = oldPrio.addPriority(tiedParticipants.length);
        initiatives[priorizedCharacter] = newPrio;
      } else {
        return;
      }
    }
    battle.reorderByInitiative(initiatives);
  }

  void _showUndoRemoveBar(
      BuildContext context, Character participant, int index) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context).removed(participant.name)),
        action: SnackBarAction(
          label: AppLocalizations.of(context).undo,
          onPressed: () => battle.addParticipantAt(participant, index),
        ),
      ));
  }

  void _showUndoClearBar(BuildContext context, List<Character> participants) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context).messageBattleEnded),
        action: SnackBarAction(
          label: AppLocalizations.of(context).undo,
          onPressed: () => battle.addParticipants(participants),
        ),
      ));
  }
}

class EmptyBattleBody extends StatelessWidget {
  // TODO use animated svg: https://github.com/2d-inc/Flare-Flutter

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 80, child: _buildLogo()),
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: _buildText(context),
            ),
            Expanded(flex: 20, child: _buildSubText(context)),
          ],
        ),
      ),
    );
  }

  Image _buildLogo() {
    return Image.asset(
      'assets/battle_swords.png',
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
    );
  }

  Text _buildText(BuildContext context) {
    return Text(
      AppLocalizations.of(context).emptyTitleBattle,
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Text _buildSubText(BuildContext context) {
    return Text(
      AppLocalizations.of(context).emptySubtitleBattle,
      style: Theme.of(context).textTheme.subtitle2,
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
