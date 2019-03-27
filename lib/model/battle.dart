import 'dart:collection';

import 'package:initiative/model/data.dart';
import 'package:scoped_model/scoped_model.dart';

class BattleModel extends Model {
  final List<Participant> _participants = [];

  UnmodifiableListView<Participant> get participants =>
      UnmodifiableListView(_participants);

  bool get isActive {
    return participants.isNotEmpty;
  }

  setParticipants(List<Participant> participants) {
    _participants.clear();
    _participants.addAll(participants);
    notifyListeners();
  }

  addGroup(Group group) {
    for (final adventurer in group.adventurers) {
      if (!participants.contains(adventurer)) {
        _participants.add(adventurer);
      }
    }
    notifyListeners();
  }

  removeParticipant(Participant participant) {
    _participants.remove(participant);
    notifyListeners();
  }

  addNpc(Npc npc) {
    _participants.add(npc);
    notifyListeners();
  }

  addParticipant(Participant participant, int index) {
    _participants.insert(index, participant);
    notifyListeners();
  }

  reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Participant item = _participants.removeAt(oldIndex);
    _participants.insert(newIndex, item);
    notifyListeners();
  }

  reorderByInitiative(Map<Participant, int> initiatives) {
    _participants.sort((a, b) => initiatives[b].compareTo(initiatives[a]));
    notifyListeners();
  }
}
