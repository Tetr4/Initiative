import 'dart:collection';
import 'dart:convert';

import 'package:initiative/model/data.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BattleModel extends Model {
  final SharedPreferences prefs;
  final List<Character> _participants = [];

  UnmodifiableListView<Character> get participants =>
      UnmodifiableListView(_participants);

  bool get isActive {
    return participants.isNotEmpty;
  }

  BattleModel(this.prefs);

  Future loadData() async {
    _participants.clear();
    final pref = prefs.getString("Battle");
    if (pref != null) {
      final Map json = jsonDecode(pref);
      final battleGroup = Group.fromJson(json);
      _participants.addAll(battleGroup.members);
      notifyListeners();
    }
    // auto save
    removeListener(saveData);
    addListener(saveData);
  }

  saveData() async {
    final battleGroup = Group(
      name: "Battle",
      members: _participants,
    );
    prefs.setString("Battle", jsonEncode(battleGroup));
  }

  addGroup(Group group) {
    for (final member in group.members) {
      // only add members that are not participating
      final contained = (participant) => participant.name == member.name;
      if (!participants.any(contained)) {
        _participants.add(member);
      }
    }
    notifyListeners();
  }

  removeParticipant(Character participant) {
    _participants.remove(participant);
    notifyListeners();
  }

  addParticipant(Character participant) {
    _participants.add(participant);
    notifyListeners();
  }

  addParticipantAt(Character participant, int index) {
    _participants.insert(index, participant);
    notifyListeners();
  }

  reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Character participant = _participants.removeAt(oldIndex);
    _participants.insert(newIndex, participant);
    notifyListeners();
  }

  reorderByInitiative(Map<Character, int> initiatives) {
    // TODO Initiative type (roll, dex, 2nd roll) instead of int
    _participants.sort((a, b) => initiatives[b].compareTo(initiatives[a]));
    notifyListeners();
  }
}
