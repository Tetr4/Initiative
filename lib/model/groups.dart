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

  void addAll(Map<Group, int> groupToIndex) {
    groupToIndex.forEach((group, index) => _groups.insert(index, group));
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
    final Group group = _groups[groupIndex];
    final members = group.members.toList()..add(newMember);
    replace(group, group.copy(members));
  }

  void replaceMember(int groupIndex, Character oldMember, Character newMember) {
    final Group group = _groups[groupIndex];
    final memberIndex = group.members.indexOf(oldMember);
    if (memberIndex == -1) {
      addMember(groupIndex, newMember);
    } else {
      final newMembers = group.members.toList();
      newMembers.setAll(memberIndex, [newMember]);
      replace(group, group.copy(newMembers));
    }
  }

  void removeMembers(int groupIndex, List<Character> selectedAdventurers) {
    final Group group = _groups[groupIndex];
    final newMembers = group.members.toList();
    for (final adventurer in selectedAdventurers) {
      newMembers.remove(adventurer);
    }
    replace(group, group.copy(newMembers));
  }

  void addAllMembers(int groupIndex, Map<Character, int> memberToIndex) {
    final Group group = _groups[groupIndex];
    final newMembers = group.members.toList();
    memberToIndex.forEach((member, index) => newMembers.insert(index, member));
    replace(group, group.copy(newMembers));
  }
}
