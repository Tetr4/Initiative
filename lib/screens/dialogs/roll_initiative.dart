import 'dart:math';

import 'package:flutter/material.dart';
import 'package:initiative/model/data.dart';

class InitiativeDialog extends StatefulWidget {
  final Character participant;
  final Function(int initiative) onRolled;

  InitiativeDialog({
    Key key,
    @required this.participant,
    @required this.onRolled,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InitiativeDialogState();
}

class _InitiativeDialogState extends State<InitiativeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _initiativeKey = GlobalKey<FormFieldState<String>>();
  final _initiativeController = new TextEditingController();
  final random = Random();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("${widget.participant.name}'s initiative"),
      content: Form(
        key: _formKey,
        child: _buildInitiativeField(), // TODO count field?
      ),
      actions: <Widget>[
        _buildAutoRollButton(context),
        _buildCreateButton(context)
      ],
    );
  }

  TextFormField _buildInitiativeField() {
    return TextFormField(
      key: _initiativeKey,
      autofocus: true,
      controller: _initiativeController,
      decoration: InputDecoration(labelText: "Initiative"),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty || num.tryParse(value) == null) {
          return "Please enter the rolled initiative.";
        }
      },
    );
  }

  FlatButton _buildAutoRollButton(BuildContext context) {
    return FlatButton(
      child: new Text("roll (1-25)"),
      onPressed: () {
        _initiativeController.text = (random.nextInt(25) + 1).toString();
      },
    );
  }

  FlatButton _buildCreateButton(BuildContext context) {
    return FlatButton(
      child: new Text("done"),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          final initiative = num.parse(_initiativeKey.currentState.value);
          Navigator.of(context).pop();
          widget.onRolled(initiative);
        }
      },
    );
  }
}
