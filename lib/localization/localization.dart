import 'package:flutter/material.dart';
import 'package:initiative/model/data.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static String pluralS(Iterable items) => items.length == 1 ? "" : "s";

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'edit': 'Edit',
      'delete': 'Delete',
      'undo': 'UNDO',
      'actionSave': 'SAVE',
      'actionCreate': 'CREATE',
      'actionDone': 'DONE',
      'actionAutoRoll': 'ROLL (1-25)',
      'titleBattle': 'Battle',
      'titleAddGroup': 'Add group',
      'titleNewGroup': 'New group',
      'titleAddMember': 'Add member',
      'titleAddNpc': 'Add NPC',
      'titleInitiativeTie': 'Who should be first?',
      'labelName': 'Name',
      'labelDescription': 'Description',
      'labelInitiative': 'Initiative',
      'labelErrorName': 'Enter a name',
      'labelErrorDescription': 'Enter a description',
      'labelErrorInitiative': 'Enter the rolled initiative',
      'labelNpc': 'NPC',
      'labelGroup': 'Group',
      'tooltipAddParticipant': 'Add participant',
      'tooltipAddMember': 'Add adventurer',
      'tooltipRollInitiative': 'Roll initiative',
      'tooltipEndBattle': 'End battle',
      'tooltipCreateGroup': 'New group',
      'emptyTitleGroups': 'No groups.',
      'emptySubtitleGroups': 'Create a group and it will show up here.',
      'emptyTitleBattle': 'No active battle.',
      'emptySubtitleBattle': 'Add participants to start the battle.',
      'emptyTitleGroup': 'No group members.',
      'emptySubtitleGroup': 'Add adventurers and they will show up here.',
      'messageBattleEnded': 'Battle ended'
    },
    'de': {
      'edit': 'Bearbeiten',
      'delete': 'Löschen',
      'undo': 'RÜCKGÄNGIG',
      'actionSave': 'SPEICHERN',
      'actionCreate': 'ERSTELLEN',
      'actionDone': 'FERTIG',
      'actionAutoRoll': 'WÜRFELN (1-25)',
      'titleBattle': 'Kampf',
      'titleAddGroup': 'Gruppe hinzufügen',
      'titleNewGroup': 'Gruppe erstellen',
      'titleAddMember': 'Mitglied hinzufügen',
      'titleAddNpc': 'NPC hinzufügen',
      'titleInitiativeTie': 'Wer ist zuerst dran?',
      'labelName': 'Name',
      'labelDescription': 'Beschreibung',
      'labelInitiative': 'Initiative',
      'labelErrorName': 'Gib einen Namen ein',
      'labelErrorDescription': 'Gib eine Beschreibung ein',
      'labelErrorInitiative': 'Gib die gewürfelte initiative ein',
      'labelNpc': 'NPC',
      'labelGroup': 'Gruppe',
      'tooltipAddParticipant': 'Teilnehmer hinzufügen',
      'tooltipAddMember': 'Abenteurer hinzufügen',
      'tooltipRollInitiative': 'Initiative würfeln',
      'tooltipEndBattle': 'Kampf beenden',
      'tooltipCreateGroup': 'Gruppe erstellen',
      'emptyTitleGroups': 'Keine Gruppen.',
      'emptySubtitleGroups':
          'Erstelle eine Gruppe und sie wird hier auftauchen.',
      'emptyTitleBattle': 'Kein aktiver Kampf.',
      'emptySubtitleBattle':
          'Füge Teilnehmer hinzu, um das Gefecht zu beginnen.',
      'emptyTitleGroup': 'Keine Gruppenmitglieder.',
      'emptySubtitleGroup':
          'Füge Abenteurer hinzu und sie werden hier auftauchen.',
      'messageBattleEnded': 'Kampf beendet'
    },
  };

  static Map<String, Map<String, Function>> _localizedTemplates = {
    'en': {
      'titleEdit': (String name) => 'Edit $name',
      'titleInitiative': (Character char) => "${char.name}'s initiative",
      'deleted': (String name) => '$name deleted',
      'removed': (String name) => '$name removed',
      'groupsDeleted': (int count) => "$count groups deleted",
      'membersDeleted': (int count) => "$count members deleted",
      'itemsSelected': (int count) => '$count selected',
      'groupSubtitle': (Group group) =>
          '${group.members.length} adventurer${pluralS(group.members)}',
    },
    'de': {
      'titleEdit': (String name) => '$name bearbeiten',
      'titleInitiative': (Character char) => "${char.name}s Initiative",
      'deleted': (String name) => '$name entfernt',
      'removed': (String name) => '$name entfernt',
      'groupsDeleted': (int count) => "$count Gruppen entfernt",
      'membersDeleted': (int count) => "$count Mitglieder entfernt",
      'itemsSelected': (int count) => '$count ausgewählt',
      'groupSubtitle': (Group group) => '${group.members.length} Abenteurer',
    },
  };

  String _getValue(String key) =>
      _localizedValues[locale.languageCode][key] ?? _localizedValues['en'][key];

  Function _getTemplate(String key) =>
      _localizedTemplates[locale.languageCode][key] ??
      _localizedTemplates['en'][key];

  String get edit => _getValue('edit');

  String get delete => _getValue('delete');

  String get undo => _getValue('undo');

  String get actionSave => _getValue('actionSave');

  String get actionCreate => _getValue('actionCreate');

  String get actionDone => _getValue('actionDone');

  String get actionAutoRoll => _getValue('actionAutoRoll');

  String get titleBattle => _getValue('titleBattle');

  String get titleAddGroup => _getValue('titleAddGroup');

  String get titleNewGroup => _getValue('titleNewGroup');

  String get titleAddMember => _getValue('titleAddMember');

  String get titleAddNpc => _getValue('titleAddNpc');

  String get titleInitiativeTie => _getValue('titleInitiativeTie');

  String get labelName => _getValue('labelName');

  String get labelDescription => _getValue('labelDescription');

  String get labelInitiative => _getValue('labelInitiative');

  String get labelErrorName => _getValue('labelErrorName');

  String get labelErrorDescription => _getValue('labelErrorDescription');

  String get labelErrorInitiative => _getValue('labelErrorInitiative');

  String get labelNpc => _getValue('labelNpc');

  String get labelGroup => _getValue('labelGroup');

  String get tooltipAddParticipant => _getValue('tooltipAddParticipant');

  String get tooltipAddMember => _getValue('tooltipAddMember');

  String get tooltipRollInitiative => _getValue('tooltipRollInitiative');

  String get tooltipEndBattle => _getValue('tooltipEndBattle');

  String get tooltipCreateGroup => _getValue('tooltipCreateGroup');

  String get emptyTitleGroups => _getValue('emptyTitleGroups');

  String get emptySubtitleGroups => _getValue('emptySubtitleGroups');

  String get emptyTitleBattle => _getValue('emptyTitleBattle');

  String get emptySubtitleBattle => _getValue('emptySubtitleBattle');

  String get emptyTitleGroup => _getValue('emptyTitleGroup');

  String get emptySubtitleGroup => _getValue('emptySubtitleGroup');

  String get messageBattleEnded => _getValue('messageBattleEnded');

  String titleEdit(String name) => _getTemplate('titleEdit')(name);

  String titleInitiative(Character c) => _getTemplate('titleInitiative')(c);

  String deleted(String name) => _getTemplate('deleted')(name);

  String removed(String name) => _getTemplate('removed')(name);

  String groupsDeleted(int count) => _getTemplate('groupsDeleted')(count);

  String membersDeleted(int count) => _getTemplate('membersDeleted')(count);

  String itemsSelected(int count) => _getTemplate('itemsSelected')(count);

  String groupSubtitle(Group group) => _getTemplate('groupSubtitle')(group);
}
