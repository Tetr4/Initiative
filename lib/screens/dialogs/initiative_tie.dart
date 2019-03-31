import 'package:flutter/material.dart';
import 'package:initiative/localization/localization.dart';
import 'package:initiative/model/data.dart';

class InitiativeTieDialog extends StatelessWidget {
  final List<Character> tiedParticipants;
  final void Function(Character priorizedCharacter) onTieResolved;

  InitiativeTieDialog({
    Key key,
    @required this.tiedParticipants,
    @required this.onTieResolved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).titleInitiativeTie),
      content: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return Container(
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
        child: Icon(character.type == CharacterType.ADVENTURER
            ? Icons.face
            : Icons.bug_report),
      ),
      title: Text(character.name),
      onTap: () {
        Navigator.of(context).pop();
        onTieResolved(character);
      },
    );
  }
}
