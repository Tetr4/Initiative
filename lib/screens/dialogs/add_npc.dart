import 'package:flutter/material.dart';
import 'package:initiative/model/data.dart';

class NpcDialog extends StatefulWidget {
  final Function(Character npc) onCreate;

  NpcDialog({Key key, @required this.onCreate}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NpcDialogState();
}

class _NpcDialogState extends State<NpcDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add NPC"),
      content: Form(
        key: _formKey,
        child: _buildNameField(), // TODO count field?
      ),
      actions: <Widget>[_buildCreateButton(context)],
    );
  }

  TextFormField _buildNameField() {
    return TextFormField(
      key: _nameKey,
      decoration: InputDecoration(labelText: "Name"),
      validator: (text) {
        if (text.isEmpty) {
          return 'Please enter a name';
        }
      },
    );
  }

  FlatButton _buildCreateButton(BuildContext context) {
    return FlatButton(
      child: new Text("Create"),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          final npc = Character(
            name: _nameKey.currentState.value,
            type: CharacterType.NPC,
          );
          Navigator.of(context).pop();
          widget.onCreate(npc);
        }
      },
    );
  }
}
