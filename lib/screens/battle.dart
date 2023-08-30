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
  const BattleScreen({super.key});

  @override
  State<StatefulWidget> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  final Map<Character, Initiative> initiatives = {};
  late BattleModel battle;

  List<Character> get undeterminedInitiatives =>
      battle.participants.toList()..removeWhere((participant) => initiatives[participant] != null);

  List<List<Character>> get ties {
    final Map<Initiative, List<Character>> groups = groupBy(initiatives.keys, (character) => initiatives[character]!);
    return groups.values.toList()..removeWhere((characters) => characters.length == 1);
  }

  Future<void> _selectGroup(BuildContext context) async {
    final Group? group = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GroupsScreen(),
        fullscreenDialog: true,
      ),
    );
    if (group != null) {
      battle.addGroup(group);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<BattleModel>(builder: (context, child, battle) {
      this.battle = battle;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).titleBattle),
          actions: battle.isActive ? _buildBattleButtons(context) : [],
        ),
        body: battle.isActive ? Scrollbar(child: Builder(builder: _buildParticipantList)) : _EmptyBattleBody(),
        floatingActionButton: _buildAddParticipantButton(context),
      );
    });
  }

  List<Widget> _buildBattleButtons(BuildContext context) =>
      [_buildInitiativeButton(context), _buildEndBattleButton(context)];

  Widget _buildInitiativeButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.casino),
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
      tooltip: AppLocalizations.of(context).tooltipAddParticipant,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.bug_report),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          label: AppLocalizations.of(context).labelNpc,
          onTap: () => _showNpcDialog(),
        ),
        SpeedDialChild(
          child: const Icon(Icons.group),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          label: AppLocalizations.of(context).labelGroup,
          onTap: () => _selectGroup(context),
        ),
      ],
      child: const Icon(Icons.add),
    );
  }

  Widget _buildParticipantList(BuildContext context) {
    return ReorderableListView(
      buildDefaultDragHandles: true,
      onReorder: battle.reorder,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: battle.participants
          .mapIndexed((index, participant) => _LineupItem(
                key: ObjectKey(participant),
                index: index,
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

  Future<void> _showNpcDialog() async {
    final npc = await showDialog(
      context: context,
      builder: (BuildContext context) => const NpcDialog(),
    );
    if (npc != null) {
      battle.addParticipant(npc);
    }
  }

  Future<void> _startInitiativeDialogs() async {
    while (undeterminedInitiatives.isNotEmpty) {
      final participant = undeterminedInitiatives.first;
      final roll = await showDialog(
        context: context,
        builder: (BuildContext context) => InitiativeDialog(participant: participant),
      );
      if (roll != null) {
        initiatives[participant] = Initiative(roll: roll);
      } else {
        return;
      }
    }
    while (ties.isNotEmpty) {
      final tiedParticipants = ties.first;
      if (!context.mounted) return;
      final priorizedCharacter = await showDialog(
        context: context,
        builder: (BuildContext context) => InitiativeTieDialog(
          tiedParticipants: tiedParticipants,
        ),
      );
      if (priorizedCharacter != null) {
        final oldPrio = initiatives[priorizedCharacter]!;
        final newPrio = oldPrio.addPriority(tiedParticipants.length);
        initiatives[priorizedCharacter] = newPrio;
      } else {
        return;
      }
    }
    battle.reorderByInitiative(initiatives);
  }

  void _showUndoRemoveBar(BuildContext context, Character participant, int index) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        actionOverflowThreshold: 0.5,
        content: Text(AppLocalizations.of(context).removed(participant.name)),
        action: SnackBarAction(
          label: AppLocalizations.of(context).undo,
          onPressed: () => battle.addParticipantAt(participant, index),
        ),
      ));
  }

  void _showUndoClearBar(BuildContext context, List<Character> participants) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        actionOverflowThreshold: 0.5,
        content: Text(AppLocalizations.of(context).messageBattleEnded),
        action: SnackBarAction(
          label: AppLocalizations.of(context).undo,
          onPressed: () => battle.addParticipants(participants),
        ),
      ));
  }
}

class _EmptyBattleBody extends StatelessWidget {
  // TODO use animated svg: https://github.com/2d-inc/Flare-Flutter

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 80, child: _buildLogo()),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: _buildText(context),
            ),
            Expanded(flex: 20, child: _buildSubText(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/battle_swords.png',
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
    );
  }

  Widget _buildText(BuildContext context) {
    return Text(
      AppLocalizations.of(context).emptyTitleBattle,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildSubText(BuildContext context) {
    return Text(
      AppLocalizations.of(context).emptySubtitleBattle,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }
}

class _LineupItem extends StatelessWidget {
  final Character participant;
  final ConfirmDismissCallback onDismissed;
  final int index;

  const _LineupItem({
    super.key,
    required this.participant,
    required this.onDismissed,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final participant = this.participant; // required for smart cast
    return Dismissible(
      background: Container(color: Theme.of(context).primaryColor),
      key: ObjectKey(participant),
      onDismissed: onDismissed,
      child: participant.type == CharacterType.adventurer
          ? ListTile(
              leading: const CircleAvatar(child: Icon(Icons.face)),
              title: Text(participant.name),
              subtitle: Text(participant.description),
              trailing: ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle),
              ),
            )
          : ListTile(
              leading: const CircleAvatar(child: Icon(Icons.bug_report)),
              title: Text(participant.name),
              trailing: ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle),
              ),
            ),
    );
  }
}
