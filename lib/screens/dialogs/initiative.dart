import 'dart:math';

import 'package:flutter/material.dart';
import 'package:initiative/localization/localization.dart';
import 'package:initiative/model/data.dart';

class InitiativeDialog extends StatefulWidget {
  final Character participant;

  const InitiativeDialog({
    super.key,
    required this.participant,
  });

  @override
  State<StatefulWidget> createState() => _InitiativeDialogState();
}

class _InitiativeDialogState extends State<InitiativeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _initiativeKey = GlobalKey<FormFieldState<String>>();
  final _initiativeController = TextEditingController();
  final random = Random();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).titleInitiative(widget.participant),
      ),
      content: Form(
        key: _formKey,
        child: _buildInitiativeField(),
      ),
      actions: <Widget>[_buildAutoRollButton(context), _buildCreateButton(context)],
    );
  }

  Widget _buildInitiativeField() {
    return TextFormField(
      key: _initiativeKey,
      autofocus: true,
      controller: _initiativeController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).labelInitiative,
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty || num.tryParse(value) == null) {
          return AppLocalizations.of(context).labelErrorInitiative;
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildAutoRollButton(BuildContext context) {
    return TextButton(
      child: Text(AppLocalizations.of(context).actionAutoRoll),
      onPressed: () {
        _initiativeController.text = (random.nextInt(20) + 1).toString();
      },
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return TextButton(
      child: Text(AppLocalizations.of(context).actionDone),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          final initiative = num.parse(_initiativeKey.currentState!.value!);
          Navigator.of(context).pop(initiative);
        }
      },
    );
  }
}
