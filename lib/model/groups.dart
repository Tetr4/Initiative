import 'dart:collection';

import 'package:initiative/model/data.dart';
import 'package:scoped_model/scoped_model.dart';

class GroupsModel extends Model {
  final List<Group> _groups = [];

  UnmodifiableListView<Group> get items => UnmodifiableListView(_groups);

  void addItems(List<Group> groups) {
    _groups.addAll(groups);
    notifyListeners();
  }

  void add(Group group) {
    _groups.add(group);
    notifyListeners();
  }

  void addAll(Map<Group, int> groupsAndIndices) {
    groupsAndIndices.forEach((group, index) => _groups.insert(index, group));
    notifyListeners();
  }

  void removeAll(List<Group> deletedGroups) {
    for (final group in deletedGroups) {
      _groups.remove(group);
    }
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

  void addMember(int groupIndex, Character newMember) {
    final Group oldGroup = _groups[groupIndex];
    // data is immutable, so we copy it
    final members = List<Character>.from(oldGroup.members)..add(newMember);
    final newGroup = oldGroup.copy(members);
    replace(oldGroup, newGroup);
  }

  int indexOf(Group group) => _groups.indexOf(group);
}
