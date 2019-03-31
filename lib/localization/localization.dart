import 'package:flutter/material.dart';
import 'package:initiative/model/data.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static String pluralS(Iterable items) => items.length == 1 ? "" : "s";

  // TODO static const
  Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'edit': 'Edit',
      'delete': 'Delete',
      'undo': 'UNDO',
      'titleBattle': 'Battle',
      'titleGroups': 'Add group',
      'labelNpc': 'NPC',
      'labelGroup': 'Group',
      'tooltipAddParticipant': 'Add participant',
      'tooltipRollInitiative': 'Roll initiative',
      'tooltipEndBattle': 'End battle',
      'tooltipCreateGroup': 'New group',
      'emptyTitleGroups': 'No groups.',
      'emptySubitleGroups': 'Create a group and it will show up here.',
      'emptyTitleBattle': 'No active battle.',
      'emptySubtitleBattle': 'Add participants to start the battle.',
      'messageBattleEnded': 'Battle ended'
    },
    'de': {},
  };

  // TODO static
  Map<String, Map<String, Function>> _localizedTemplates = {
    'en': {
      'deleted': (String name) => '$name deleted',
      'removed': (String name) => '$name removed',
      'groupsDeleted': (int count) => "$count groups deleted",
      'itemsSelected': (int count) => '$count selected',
      'groupSubtitle': (Group group) =>
          '${group.members.length} adventurer${pluralS(group.members)}',
    },
    'de': {},
  };

  String _getValue(String key) =>
      _localizedValues[locale.languageCode][key] ?? _localizedValues['en'][key];

  Function _getTemplate(String key) =>
      _localizedTemplates[locale.languageCode][key] ??
      _localizedTemplates['en'][key];

  String get edit => _getValue('edit');

  String get delete => _getValue('delete');

  String get undo => _getValue('undo');

  String get titleBattle => _getValue('titleBattle');

  String get titleGroups => _getValue('titleGroups');

  String get labelNpc => _getValue('labelNpc');

  String get labelGroup => _getValue('labelGroup');

  String get tooltipAddParticipant => _getValue('tooltipAddParticipant');

  String get tooltipRollInitiative => _getValue('tooltipRollInitiative');

  String get tooltipEndBattle => _getValue('tooltipEndBattle');

  String get tooltipCreateGroup => _getValue('tooltipCreateGroup');

  String get emptyTitleGroups => _getValue('emptyTitleGroups');

  String get emptySubtitleGroups => _getValue('emptySubtitleGroups');

  String get emptyTitleBattle => _getValue('emptyTitleBattle');

  String get emptySubtitleBattle => _getValue('emptySubtitleBattle');

  String get messageBattleEnded => _getValue('messageBattleEnded');

  String deleted(String name) => _getTemplate('deleted')(name);

  String removed(String name) => _getTemplate('removed')(name);

  String groupsDeleted(int count) => _getTemplate('groupsDeleted')(count);

  String itemsSelected(int count) => _getTemplate('itemsSelected')(count);

  String groupSubtitle(Group group) => _getTemplate('groupSubtitle')(group);
}
