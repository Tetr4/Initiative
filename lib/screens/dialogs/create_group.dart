import 'package:flutter/material.dart';
import 'package:initiative/model/group.dart';

class GroupDialog extends StatefulWidget {
  final Function(Group group) onCreate;

  GroupDialog({Key key, @required this.onCreate}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New group"),
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
          widget.onCreate(Group(name, []));
        }
      },
    );
  }
}
