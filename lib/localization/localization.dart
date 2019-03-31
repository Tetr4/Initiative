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
      'add_group': 'Add group',
      'new_group': 'New group',
      'edit': 'Edit',
      'delete': 'Delete',
      'undo': 'UNDO',
      'empty_groups_title': 'No groups.',
      'empty_groups_subtitle': 'Create a group and it will show up here.',
    },
    'de': {},
  };

  // TODO static
  Map<String, Map<String, Function>> _localizedTemplates = {
    'en': {
      'group_deleted': (Group group) => '${group.name} deleted',
      'groups_deleted': (int count) => "$count groups deleted",
      'items_selected': (int count) => '$count selected',
      'group_subtitle': (Group group) =>
          '${group.members.length} adventurer${pluralS(group.members)}',
    },
    'de': {},
  };

  String _getValue(String key) =>
      _localizedValues[locale.languageCode][key] ?? _localizedValues['en'][key];

  Function _getTemplate(String key) =>
      _localizedTemplates[locale.languageCode][key] ??
      _localizedTemplates['en'][key];

  String get addGroup => _getValue('add_group');

  String get newGroup => _getValue('new_group');

  String get edit => _getValue('edit');

  String get delete => _getValue('delete');

  String get undo => _getValue('undo');

  String get emptyGroupsSubtitle => _getValue('empty_groups_subtitle');

  String get emptyGroupsTitle => _getValue('empty_groups_title');

  String groupDeleted(Group group) => _getTemplate('group_deleted')(group);

  String groupsDeleted(int count) => _getTemplate('groups_deleted')(count);

  String selected(int count) => _getTemplate('items_selected')(count);

  String groupSubtitle(Group group) => _getTemplate('group_subtitle')(group);
}
