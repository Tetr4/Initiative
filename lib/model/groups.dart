import 'dart:collection';

import 'package:initiative/model/data.dart';
import 'package:scoped_model/scoped_model.dart';

class GroupsModel extends Model {
  final List<Group> _groups = [
    Group("Foobarion", [
      Adventurer("Turweck", "Zwerg Magier"),
      Adventurer("Raven", "Halbelf Schurke"),
      Adventurer("Artemis", "Mensch Hexenmeister"),
      Adventurer("Vincent", "Mensch Kleriker"),
      Adventurer("Zarzuket", "Gnom Mentalist"),
    ])
  ];

  UnmodifiableListView<Group> get items => UnmodifiableListView(_groups);

  setGroups(List<Group> groups) {
    _groups.clear();
    _groups.addAll(groups);
    notifyListeners();
  }

  add(Group group) {
    _groups.add(group);
    notifyListeners();
  }

  remove(Group group) {
    _groups.remove(group);
    notifyListeners();
  }

  replace(Group oldGroup, Group newGroup) {
    final groupIndex = _groups.indexOf(oldGroup);
    if (groupIndex == -1) {
      _groups.add(newGroup);
    } else {
      _groups.setAll(groupIndex, [newGroup]);
    }
    notifyListeners();
  }

  void addAdventurer(int groupIndex, Adventurer adventurer) {
    final Group oldGroup = _groups[groupIndex];
    // data is immutable, so we copy it
    final adventurers = List<Adventurer>.from(oldGroup.adventurers)
      ..add(adventurer);
    final newGroup = oldGroup.copy(adventurers);
    replace(oldGroup, newGroup);
  }
}
