import 'package:flutter/material.dart';
import 'package:initiative/model/data.dart';
import 'package:initiative/model/groups.dart';
import 'package:initiative/screens/dialogs/adventurer.dart';
import 'package:scoped_model/scoped_model.dart';

class AdventurersScreen extends StatefulWidget {
  final int groupIndex;

  AdventurersScreen({Key key, @required this.groupIndex}) : super(key: key);

  @override
  _AdventurersScreenState createState() => _AdventurersScreenState();
}

// TODO generic multi select widget for both groups and adventurers?
class _AdventurersScreenState extends State<AdventurersScreen> {
  GroupsModel _groups;
  Group group;
  Map<Character, bool> selection = Map();
  List<Character> selectedAdventurers;

  bool get isSelecting => selectedAdventurers.length > 0;

  bool isSelected(adventurer) => selection[adventurer] == true;

  void _initState(GroupsModel groups) {
    _groups = groups;
    group = groups.items[widget.groupIndex];
    selection = Map.fromIterable(group.members, value: isSelected);
    selectedAdventurers = selection.keys.where(isSelected).toList();
  }

  void toggleSelection(Character adventurer) => setState(() {
        selection[adventurer] = !selection[adventurer];
      });

  void deselectAll() => setState(() => selection.clear());

  Future<bool> _onBackPressed() {
    if (isSelecting) {
      deselectAll();
    }
    return Future.value(!isSelecting);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GroupsModel>(
      builder: (context, child, groups) {
        _initState(groups);
        return WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            appBar: _buildAppBar(context, selectedAdventurers.length),
            body: _buildAdventurersList(group.members),
            floatingActionButton: _buildCreateAdventurerButton(context),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, int selectedItems) {
    final List<Widget> actions = [];
    if (selectedItems == 1) {
      actions.add(_buildEditButton(context));
    }
    if (selectedItems > 0) {
      actions.add(Builder(builder: _buildDeleteButton));
    }
    return AppBar(
      title: Text(
          selectedItems > 0 ? "$selectedItems selected" : "Edit ${group.name}"),
      actions: actions,
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.edit),
      tooltip: "Edit",
      onPressed: () {
        deselectAll();
        _showEditAdventurerDialog(context, selectedAdventurers.first);
      },
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete),
      tooltip: "Delete",
      onPressed: () {
        final Map<Character, int> memberToIndex = Map.fromIterable(
            selectedAdventurers,
            value: (adventurer) => group.members.indexOf(adventurer));
        _groups.removeMembers(widget.groupIndex, selectedAdventurers);
        _showUndoBar(context, memberToIndex);
      },
    );
  }

  Widget _buildAdventurersList(List<Character> adventurers) {
    return ListView.builder(
      itemCount: adventurers.length,
      itemBuilder: (context, index) {
        final adventurer = adventurers[index];
        return _buildAdventurerItem(adventurer, isSelected(adventurer));
      },
    );
  }

  Widget _buildAdventurerItem(Character adventurer, bool isSelected) {
    final icon = isSelected ? Icons.check : Icons.face;
    return ListTile(
      leading: CircleAvatar(child: Icon(icon)),
      title: Text(adventurer.name),
      subtitle: Text(adventurer.description),
      onTap: isSelecting ? () => toggleSelection(adventurer) : null,
      onLongPress: () => toggleSelection(adventurer),
    );
  }

  FloatingActionButton _buildCreateAdventurerButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showCreateAdventurerDialog(context),
      tooltip: 'Add adventurer',
      child: Icon(Icons.add),
    );
  }

  void _showEditAdventurerDialog(BuildContext context, Character adventurer) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AdventurerDialog(
            adventurer: adventurer,
            onSave: (newAdventurer) {
              _groups.replaceMember(
                  widget.groupIndex, adventurer, newAdventurer);
            },
          ),
    );
  }

  void _showCreateAdventurerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AdventurerDialog(onSave: (adventurer) {
            _groups.addMember(widget.groupIndex, adventurer);
          }),
    );
  }

  void _showUndoBar(BuildContext context, Map<Character, int> memberToIndex) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(memberToIndex.length == 1
          ? "${memberToIndex.keys.first.name} deleted"
          : "${memberToIndex.length} members deleted"),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () =>
            _groups.addAllMembers(widget.groupIndex, memberToIndex),
      ),
    ));
  }
}
