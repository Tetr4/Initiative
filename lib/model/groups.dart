import 'dart:collection';

import 'package:initiative/model/data.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupsModel extends Model {
  final SharedPreferences prefs;

  final List<Group> _groups = [
    Group(name: "Foobarion", members: [
      Character(name: "Turweck", description: "Zwerg Magier"),
      Character(name: "Raven", description: "Halbelf Schurke"),
      Character(name: "Artemis", description: "Mensch Hexenmeister"),
      Character(name: "Vincent", description: "Mensch Kleriker"),
      Character(name: "Zarzuket", description: "Gnom Mentalist"),
    ])
  ];

  GroupsModel(this.prefs);

  UnmodifiableListView<Group> get items => UnmodifiableListView(_groups);

  Future loadData() async {
//    _jsonData = json.decode(await rootBundle.loadString('assets/words.json'));
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

  void addMember(int groupIndex, Character newMember) {
    final Group oldGroup = _groups[groupIndex];
    // data is immutable, so we copy it
    final members = List<Character>.from(oldGroup.members)..add(newMember);
    final newGroup = oldGroup.copy(members);
    replace(oldGroup, newGroup);
  }
}
