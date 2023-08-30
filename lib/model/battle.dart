import 'dart:collection';
import 'dart:math';

import 'package:initiative/model/data.dart';
import 'package:scoped_model/scoped_model.dart';

class BattleModel extends Model {
  final List<Character> _participants = [];

  UnmodifiableListView<Character> get participants => UnmodifiableListView(_participants);

  bool get isActive {
    return participants.isNotEmpty;
  }

  void addParticipants(List<Character> list) {
    _participants.addAll(list);
    notifyListeners();
  }

  void addGroup(Group group) {
    for (final member in group.members) {
      // only add members that are not participating
      contained(participant) => participant.name == member.name;
      if (!participants.any(contained)) {
        _participants.add(member);
      }
    }
    notifyListeners();
  }

  void removeParticipant(Character participant) {
    _participants.remove(participant);
    notifyListeners();
  }

  void addParticipant(Character participant) {
    _participants.add(participant);
    notifyListeners();
  }

  void addParticipantAt(Character participant, int index) {
    final newIndex = min(index, _participants.length);
    _participants.insert(newIndex, participant);
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Character participant = _participants.removeAt(oldIndex);
    _participants.insert(newIndex, participant);
    notifyListeners();
  }

  void reorderByInitiative(Map<Character, Initiative> initiatives) {
    _participants.sort((a, b) => initiatives[a]!.compareTo(initiatives[b]!));
    notifyListeners();
  }

  void clear() {
    _participants.clear();
    notifyListeners();
  }
}
