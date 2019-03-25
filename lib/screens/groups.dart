import 'package:flutter/material.dart';
import 'package:initiative/model/group.dart';
import 'package:initiative/model/participant.dart';
import 'package:initiative/screens/heroes.dart';

class GroupsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final List<Group> groups = [
    Group("Foobarion", [
      Character("Turweck", "Zwerg Magier"),
      Character("Raven", "Halbelf Schurke"),
      Character("Artemis", "Mensch Hexenmeister"),
      Character("Vincent", "Mensch Kleriker"),
      Character("Zarzuket", "Gnom Mentalist"),
    ])
//    Npc("Giant Spider"),
//    Npc("Dragon"),
//    Npc("Goblin 1"),
//    Npc("Goblin 2"),
//    Npc("Goblin 3"),
//    Npc("Goblin 4"),
//    Npc("Goblin 5"),
  ];

  _createGroup(Group group) {
    setState(() {
      groups.add(group);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Groups')),
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
      subtitle: Text('${group.heroes.length} adventurers'),
      onLongPress: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HeroesScreen(group: groups[index]),
          )),
      onTap: () => Navigator.pop(context, groups[index]),
    );
  }

  Widget _buildCreateGroupButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return GroupDialog(_createGroup);
          }),
      tooltip: 'Add group',
      child: Icon(Icons.add),
    );
  }
}

class GroupDialog extends StatefulWidget {
  final Function(Group group) onCreateGroup;

  GroupDialog(this.onCreateGroup, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New Group"),
      content: Form(
        key: _formKey,
        child: _buildNameField(),
      ),
      actions: <Widget>[_buildCreateButton(context)],
    );
  }

  TextFormField _buildNameField() {
    return TextFormField(
      key: _nameKey,
      decoration: InputDecoration(labelText: "Name"),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
    );
  }

  FlatButton _buildCreateButton(BuildContext context) {
    return FlatButton(
      child: new Text("Create"),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          final name = _nameKey.currentState.value;
          Navigator.of(context).pop();
          widget.onCreateGroup(Group(name, []));
        }
      },
    );
  }
}
