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
      'groupsTitle': 'Add group',
      'createGroupTooltip': 'New group',
      'emptyGroupsTitle': 'No groups.',
      'emptyGroupsSubtitle': 'Create a group and it will show up here.',
    },
    'de': {},
  };

  // TODO static
  Map<String, Map<String, Function>> _localizedTemplates = {
    'en': {
      'groupDeleted': (Group group) => '${group.name} deleted',
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

  String get groupsTitle => _getValue('groupsTitle');

  String get createGroupTooltip => _getValue('createGroupTooltip');

  String get emptyGroupsTitle => _getValue('emptyGroupsTitle');

  String get emptyGroupsSubtitle => _getValue('emptyGroupsSubtitle');

  String groupDeleted(Group group) => _getTemplate('groupDeleted')(group);

  String groupsDeleted(int count) => _getTemplate('groupsDeleted')(count);

  String itemsSelected(int count) => _getTemplate('itemsSelected')(count);

  String groupSubtitle(Group group) => _getTemplate('groupSubtitle')(group);
}
