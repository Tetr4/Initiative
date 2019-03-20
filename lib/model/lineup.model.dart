import 'dart:collection';

import 'package:initiative/model/participant.dart';
import 'package:scoped_model/scoped_model.dart';

class LineupModel extends Model {
  final List<Participant> _participants = [];
  UnmodifiableListView<Participant> get participants => UnmodifiableListView(_participants);

  void add(Participant participant) {
    _participants.add(participant);
    notifyListeners();
  }

  void set(List<Participant> participants) {
    _participants.clear();
    _participants.addAll(participants);
    notifyListeners();
  }

  void remove(Participant participant) {
    _participants.remove(participant);
    notifyListeners();
  }
}
