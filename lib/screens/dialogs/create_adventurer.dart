import 'package:flutter/material.dart';
import 'package:initiative/model/data.dart';

class AdventurerDialog extends StatefulWidget {
  final Function(Character adventurer) onCreate;

  AdventurerDialog({Key key, @required this.onCreate}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdventurerDialogState();
}

class _AdventurerDialogState extends State<AdventurerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormFieldState<String>>();
  final _descriptionKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New adventurer"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_buildNameField(), _buildDescriptionField()],
        ),
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

  TextFormField _buildDescriptionField() {
    return TextFormField(
      key: _descriptionKey,
      decoration: InputDecoration(labelText: "Description"),
      validator: (text) {
        if (text.isEmpty) {
          return 'Please enter a description';
        }
      },
    );
  }

  FlatButton _buildCreateButton(BuildContext context) {
    return FlatButton(
      child: new Text("Create"),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          final adventurer = Character(
            name: _nameKey.currentState.value,
            description: _descriptionKey.currentState.value,
          );
          Navigator.of(context).pop();
          widget.onCreate(adventurer);
        }
      },
    );
  }
}
