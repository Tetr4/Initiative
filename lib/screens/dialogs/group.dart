import 'package:flutter/material.dart';
import 'package:initiative/localization/localization.dart';
import 'package:initiative/model/data.dart';

class GroupDialog extends StatefulWidget {
  final void Function(Group group) onCreate;

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
      title: Text(AppLocalizations.of(context).titleNewGroup),
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
      validator: (value) {
        if (value.isEmpty) {
          return AppLocalizations.of(context).labelErrorName;
        }
      },
    );
  }

  FlatButton _buildCreateButton(BuildContext context) {
    return FlatButton(
      child: new Text(AppLocalizations.of(context).actionCreate),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          final group = Group(name: _nameKey.currentState.value);
          Navigator.of(context).pop();
          widget.onCreate(group);
        }
      },
    );
  }
}
