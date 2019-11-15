import 'package:flutter/material.dart';
import 'package:initiative/localization/localization.dart';
import 'package:initiative/model/data.dart';

class NpcDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NpcDialogState();
}

class _NpcDialogState extends State<NpcDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).titleAddNpc),
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
      autofocus: true,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).labelName,
      ),
      validator: (text) =>
          text.isEmpty ? AppLocalizations.of(context).labelErrorName : null,
    );
  }

  FlatButton _buildCreateButton(BuildContext context) {
    return FlatButton(
      child: new Text(AppLocalizations.of(context).actionCreate),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          final npc = Character(
            name: _nameKey.currentState.value,
            type: CharacterType.NPC,
          );
          Navigator.of(context).pop(npc);
        }
      },
    );
  }
}
