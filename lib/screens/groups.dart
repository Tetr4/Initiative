import 'package:flutter/material.dart';
import 'package:initiative/model/data.dart';
import 'package:initiative/model/groups.dart';
import 'package:initiative/screens/adventurers.dart';
import 'package:initiative/screens/dialogs/group.dart';
import 'package:scoped_model/scoped_model.dart';

class GroupsScreen extends StatefulWidget {
  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  GroupsModel _groups;
  Map<Group, bool> selection = Map();
  List<Group> selectedGroups;
  bool isSelecting;

  void _initState(GroupsModel groups) {
    _groups = groups;
    selection = Map.fromIterable(
      groups.items,
      value: (group) => isSelected(group), // keep state
    );
    selectedGroups = selection.keys.where(isSelected).toList();
    isSelecting = selectedGroups.length > 0;
  }

  void toggleSelection(Group group) => setState(() {
        selection[group] = !selection[group];
      });

  void deselectAll() => setState(() => selection.clear());

  bool isSelected(Group group) => selection[group] == true;

  void _editGroup(BuildContext context, Group group) {
    deselectAll();
    final index = _groups.items.indexOf(group);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdventurersScreen(groupIndex: index),
      ),
    );
  }

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
            appBar: _buildAppBar(context, selectedGroups.length),
            body: _buildGroupsList(groups.items),
            floatingActionButton: _buildCreateGroupButton(context),
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
      title: Text(selectedItems > 0 ? "$selectedItems selected" : "Add group"),
      actions: actions,
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.edit),
      tooltip: "Edit",
      onPressed: () => _editGroup(context, selectedGroups.first),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete),
      tooltip: "Delete",
      onPressed: () {
        final Map<Group, int> groupsAndIndices = Map.fromIterable(
            selectedGroups,
            value: (group) => _groups.items.indexOf(group));
        _groups.removeAll(selectedGroups);
        _showUndoRemoveBar(context, groupsAndIndices);
      },
    );
  }

  Widget _buildGroupsList(List<Group> groups) {
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return _buildGroupItem(group, isSelected(group));
      },
    );
  }

  Widget _buildGroupItem(Group group, bool isSelected) {
    final pluralS = group.members.length == 1 ? "" : "s";
    final icon = isSelected ? Icons.check : Icons.group;
    return ListTile(
      leading: CircleAvatar(child: Icon(icon)),
      title: Text(group.name),
      subtitle: Text("${group.members.length} adventurer$pluralS"),
      onTap: () =>
          isSelecting ? toggleSelection(group) : Navigator.pop(context, group),
      onLongPress: () => toggleSelection(group),
    );
  }

  Widget _buildCreateGroupButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showCreateGroupDialog(context),
      tooltip: "New group",
      child: Icon(Icons.add),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => GroupDialog(
            onCreate: (group) {
              _groups.add(group);
              _editGroup(context, group);
            },
          ),
    );
  }

  void _showUndoRemoveBar(
      BuildContext context, Map<Group, int> groupsAndIndices) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(groupsAndIndices.length == 1
          ? "${groupsAndIndices.keys.first.name} deleted"
          : "${groupsAndIndices.length} groups deleted"),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () => _groups.addAll(groupsAndIndices),
      ),
    ));
  }
}
