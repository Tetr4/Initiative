import 'package:flutter/material.dart';
import 'package:initiative/model/data.dart';
import 'package:initiative/screens/adventurers.dart';
import 'package:initiative/screens/dialogs/create_group.dart';

class GroupsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final List<Group> groups = [
    Group("Foobarion", [
      Adventurer("Turweck", "Zwerg Magier"),
      Adventurer("Raven", "Halbelf Schurke"),
      Adventurer("Artemis", "Mensch Hexenmeister"),
      Adventurer("Vincent", "Mensch Kleriker"),
      Adventurer("Zarzuket", "Gnom Mentalist"),
    ])
  ];

  _addAdventurersToGroup(Group group) async {
    final List<Adventurer> adventurers = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdventurersScreen(group: group),
        fullscreenDialog: true,
      ),
    );
    setState(() {
      groups.add(Group(group.name, adventurers));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add group')),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: _buildGroupItem,
      ),
      floatingActionButton: _buildCreateGroupButton(context),
    );
  }

  Widget _buildGroupItem(context, index) {
    final group = groups[index];
    return ListTile(
      title: Text(group.name),
      subtitle: Text('${group.adventurers.length} adventurers'),
      onLongPress: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdventurersScreen(group: groups[index]),
          )),
      onTap: () => Navigator.pop(context, groups[index]),
    );
  }

  Widget _buildCreateGroupButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) =>
                GroupDialog(onCreate: _addAdventurersToGroup),
          ),
      tooltip: 'New group',
      child: Icon(Icons.add),
    );
  }
}
