import 'dart:collection';
import 'dart:convert';

import 'package:initiative/model/data.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BattleModel extends Model {
  final SharedPreferences prefs;
  final List<Character> _participants = [];

  BattleModel(this.prefs);

  UnmodifiableListView<Character> get participants =>
      UnmodifiableListView(_participants);

  bool get isActive {
    return participants.isNotEmpty;
  }

  Future loadData() async {
    _participants.clear();
    final pref = prefs.getString("Battle");
    if (pref != null) {
      final List items = jsonDecode(pref);
      final List<Character> loadedParticipants =
          items.map((item) => Character.fromJson(item)).toList();
      _participants.addAll(loadedParticipants);
      notifyListeners();
    }

    // TODO skip first set?
    addListener(() => prefs.setString("Battle", jsonEncode(_participants)));
  }

  addGroup(Group group) {
    for (final member in group.members) {
      if (!participants.contains(member)) {
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
