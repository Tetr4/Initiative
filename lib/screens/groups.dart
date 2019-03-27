import 'package:flutter/material.dart';
import 'package:initiative/model/data.dart';
import 'package:initiative/model/groups.dart';
import 'package:initiative/screens/adventurers.dart';
import 'package:initiative/screens/dialogs/create_group.dart';
import 'package:scoped_model/scoped_model.dart';

class GroupsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  GroupsModel groups;

  _createGroup(Group group) {
    groups.add(group);
    _editGroup(groups.items.indexOf(group));
  }

  _editGroup(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScopedModel<GroupsModel>(
              model: groups,
              child: AdventurersScreen(groupIndex: index),
            ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GroupsModel>(
        builder: (context, child, groups) {
      this.groups = groups;
      return Scaffold(
        appBar: AppBar(title: Text('Add group')),
        body: ListView.builder(
          itemCount: groups.items.length,
          itemBuilder: _buildGroupItem,
        ),
        floatingActionButton: _buildCreateGroupButton(context),
      );
    });
  }

  Widget _buildGroupItem(context, index) {
    final group = groups.items[index];
    return ListTile(
      title: Text(group.name),
      subtitle: Text('${group.adventurers.length} adventurers'),
      onLongPress: () => _editGroup(index),
      onTap: () => Navigator.pop(context, group),
    );
  }

  Widget _buildCreateGroupButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) =>
                GroupDialog(onCreate: _createGroup),
          ),
      tooltip: 'New group',
      child: Icon(Icons.add),
    );
  }
}
