import 'package:flutter/material.dart';
import 'package:initiative/model/data.dart';
import 'package:initiative/model/groups.dart';
import 'package:initiative/screens/adventurers.dart';
import 'package:initiative/screens/dialogs/create_group.dart';
import 'package:scoped_model/scoped_model.dart';

class GroupsScreen extends StatelessWidget {
  void _editGroup(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdventurersScreen(groupIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GroupsModel>(
        builder: (context, child, groups) {
      final onEdit = (int index) => _editGroup(context, index);
      final onSelected = (Group group) => Navigator.pop(context, group);
      final onCreate = (Group group) {
        groups.add(group);
        onEdit(groups.items.indexOf(group));
      };
      return Scaffold(
        appBar: AppBar(title: Text('Add group')),
        body: _buildGroupsList(groups.items, onEdit, onSelected),
        floatingActionButton: _buildCreateGroupButton(context, onCreate),
      );
    });
  }

  Widget _buildGroupsList(
    List<Group> groups,
    void Function(int index) onEdit,
    void Function(Group) onSelected,
  ) {
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) =>
          _buildGroupItem(groups[index], index, onEdit, onSelected),
    );
  }

  Widget _buildGroupItem(
    Group group,
    int index,
    void Function(int index) onEdit,
    void Function(Group) onSelected,
  ) {
    return ListTile(
      leading: Icon(Icons.group),
      title: Text(group.name),
      subtitle: Text('${group.members.length} adventurers'),
      onLongPress: () => onEdit(index),
      onTap: () => onSelected(group),
    );
  }

  Widget _buildCreateGroupButton(
      BuildContext context, void Function(Group) onCreate) {
    return FloatingActionButton(
      onPressed: () => _showCreateGroupDialog(context, onCreate),
      tooltip: 'New group',
      child: Icon(Icons.add),
    );
  }

  void _showCreateGroupDialog(
      BuildContext context, void Function(Group) onCreate) {
    showDialog(
      context: context,
      builder: (BuildContext context) => GroupDialog(onCreate: onCreate),
    );
  }
}
