import 'package:flutter/material.dart';
import 'package:initiative/model/group.dart';
import 'package:initiative/model/participant.dart';
import 'package:initiative/screens/heroes/heroes.dart';

class GroupsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final List<Group> groups = [];

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
        itemBuilder: (context, index) {
          return ListTile(
            title:
                Text('${groups[index].name} - ${groups[index].heroes.length}'),
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HeroesScreen(groups[index])),
              );
            },
            onTap: () => Navigator.pop(context, groups[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return new GroupDialog(_createGroup);
              });
        },
        tooltip: 'Add group',
        child: Icon(Icons.add),
      ),
    );
  }
}

class GroupDialog extends StatefulWidget {
  final Function(Group group) onCreateGroup;

  const GroupDialog(this.onCreateGroup, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New Group"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          onSaved: (text) => _name = text,
          decoration: InputDecoration(labelText: "Name"),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
          },
        ),
      ),
      actions: <Widget>[
        new FlatButton(
            child: new Text("Create"),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                Navigator.of(context).pop();
                widget.onCreateGroup(Group(_name, [
                  Participant("asdf"),
                  Participant("asdf 2"),
                ]));
              }
            })
      ],
    );
  }
}
