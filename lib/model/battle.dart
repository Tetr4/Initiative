import 'dart:collection';

import 'package:initiative/model/data.dart';
import 'package:scoped_model/scoped_model.dart';

class BattleModel extends Model {
  final List<Character> _participants = [];

  UnmodifiableListView<Character> get participants =>
      UnmodifiableListView(_participants);

  bool get isActive {
    return participants.isNotEmpty;
  }

  addParticipants(List<Character> list) {
    _participants.addAll(list);
    notifyListeners();
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

  clear() {
    _participants.clear();
    notifyListeners();
  }
}
