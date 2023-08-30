import 'package:flutter/material.dart';
import 'package:initiative/localization/localization.dart';
import 'package:initiative/model/data.dart';

class InitiativeTieDialog extends StatelessWidget {
  final List<Character> tiedParticipants;

  const InitiativeTieDialog({
    super.key,
    required this.tiedParticipants,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).titleInitiativeTie),
      content: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: tiedParticipants.length,
        itemBuilder: (context, index) {
          final group = tiedParticipants[index];
          return _buildItem(context, group);
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, Character character) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(character.type == CharacterType.adventurer ? Icons.face : Icons.bug_report),
      ),
      title: Text(character.name),
      onTap: () => Navigator.of(context).pop(character),
    );
  }
}
