import 'package:flutter/material.dart';
import 'package:initiative/localization/localization.dart';
import 'package:initiative/model/data.dart';

class AdventurerDialog extends StatefulWidget {
  final Character adventurer;

  AdventurerDialog({
    Key key,
    this.adventurer,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdventurerDialogState();
}

class _AdventurerDialogState extends State<AdventurerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormFieldState<String>>();
  final _nameFocus = FocusNode();
  final _descriptionKey = GlobalKey<FormFieldState<String>>();
  final _descriptionFocus = FocusNode();

  Character get adventurer => widget.adventurer;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        adventurer != null
            ? AppLocalizations.of(context).titleEdit(adventurer.name)
            : AppLocalizations.of(context).titleAddMember,
      ),
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
      focusNode: _nameFocus,
      autofocus: true,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).labelName,
      ),
      initialValue: adventurer?.name,
      validator: (text) {
        if (text.isEmpty) {
          return AppLocalizations.of(context).labelErrorName;
        }
      },
      onFieldSubmitted: (term) {
        _nameFocus.unfocus();
        FocusScope.of(context).requestFocus(_descriptionFocus);
      },
    );
  }

  TextFormField _buildDescriptionField() {
    return TextFormField(
      key: _descriptionKey,
      focusNode: _descriptionFocus,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).labelDescription,
      ),
      initialValue: adventurer?.description,
      validator: (text) {
        if (text.isEmpty) {
          return AppLocalizations.of(context).labelErrorDescription;
        }
      },
    );
  }

  FlatButton _buildCreateButton(BuildContext context) {
    return FlatButton(
      child: new Text(
        adventurer != null
            ? AppLocalizations.of(context).actionSave
            : AppLocalizations.of(context).actionCreate,
      ),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          final adventurer = Character(
            name: _nameKey.currentState.value,
            description: _descriptionKey.currentState.value,
          );
          Navigator.of(context).pop(adventurer);
        }
      },
    );
  }
}
