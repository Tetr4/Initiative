import 'dart:collection';

import 'package:initiative/model/data.dart';
import 'package:scoped_model/scoped_model.dart';

class GroupsModel extends Model {
  final List<Group> _groups = [];

  UnmodifiableListView<Group> get groups => UnmodifiableListView(_groups);

  void loadGroups() {
    _groups.add(Group("Foobarion", [
      Adventurer("Turweck", "Zwerg Magier"),
      Adventurer("Raven", "Halbelf Schurke"),
      Adventurer("Artemis", "Mensch Hexenmeister"),
      Adventurer("Vincent", "Mensch Kleriker"),
      Adventurer("Zarzuket", "Gnom Mentalist"),
    ]));
  }

  void add(Group group) {
    _groups.add(group);
    notifyListeners();
  }

  void remove(Group group) {
    _groups.remove(group);
    notifyListeners();
  }

  void replace(Group oldGroup, Group newGroup) {
    final groupIndex = _groups.indexOf(oldGroup);
    if (groupIndex == -1) {
      _groups.add(newGroup);
    } else {
      _groups.setAll(groupIndex, [newGroup]);
    }
    notifyListeners();
  }
}
