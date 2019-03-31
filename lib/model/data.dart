import 'package:meta/meta.dart';

class Character {
  final String name;
  final String description;
  final CharacterType type;

  Character({
    @required this.name,
    this.description = "",
    this.type = CharacterType.ADVENTURER,
  });

  Character.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        type = CharacterType.values[json['type']];

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'type': type.index,
      };
}

enum CharacterType { ADVENTURER, NPC }

class Group {
  final String name;
  final List<Character> members;

  Group({@required this.name, this.members = const []});

  Group.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        members = (json['members'] as List)
            .map((item) => Character.fromJson(item))
            .toList();

  Map<String, dynamic> toJson() => {
        'name': name,
        'members': members,
      };

  Group copy(List<Character> newMembers) =>
      Group(name: this.name, members: newMembers);
}

class Initiative extends Comparable<Initiative> {
  final int roll;
  final int priority;

  Initiative({@required this.roll, this.priority = 0});

  bool operator ==(other) {
    return (other is Initiative &&
        other.roll == roll &&
        other.priority == priority);
  }

  @override
  int get hashCode => roll.hashCode * priority.hashCode;

  @override
  int compareTo(Initiative other) {
    final rollResult = this.roll.compareTo(other.roll);
    if (rollResult != 0) {
      // higher roll first
      return -rollResult;
    } else {
      // higher priority first
      return -this.priority.compareTo(other.priority);
    }
  }

  Initiative addPriority(int value) {
    return Initiative(roll: this.roll, priority: this.priority + value);
  }
}
