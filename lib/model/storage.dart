import 'dart:convert';

import 'package:initiative/model/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  final SharedPreferences prefs;

  Storage(this.prefs);

  Future<List<Group>> loadGroups() async {
    final pref = prefs.getString("Groups");
    if (pref != null) {
      final List json = jsonDecode(pref);
      final List<Group> groups =
          json.map((item) => Group.fromJson(item)).toList();
      return groups;
    } else {
      // default group
      final defaultGroup = Group(name: "Foobarion", members: [
        Character(name: "Turweck", description: "Zwerg Magier"),
        Character(name: "Raven", description: "Halbelf Schurke"),
        Character(name: "Artemis", description: "Mensch Hexenmeister"),
        Character(name: "Vincent", description: "Mensch Kleriker"),
        Character(name: "Zarzuket", description: "Gnom Mentalist"),
      ]);
      return [defaultGroup];
    }
  }

  Future<bool> saveGroups(List<Group> groups) =>
      prefs.setString("Groups", jsonEncode(groups));

  Future<List<Character>> loadBattle() async {
    final pref = prefs.getString("Battle");
    if (pref != null) {
      final Map json = jsonDecode(pref);
      final battleGroup = Group.fromJson(json);
      return battleGroup.members;
    } else {
      return [];
    }
  }

  Future<bool> saveBattle(List<Character> participants) {
    final battleGroup = Group(
      name: "Battle",
      members: participants,
    );
    return prefs.setString("Battle", jsonEncode(battleGroup));
  }
}
