class Character {
  final String name;
  final String description;
  final CharacterType type;

  Character({
    required this.name,
    this.description = "",
    this.type = CharacterType.adventurer,
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

enum CharacterType { adventurer, npc }

class Group {
  final String name;
  final List<Character> members;

  Group({required this.name, this.members = const []});

  Group.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        members = (json['members'] as List).map((item) => Character.fromJson(item)).toList();

  Map<String, dynamic> toJson() => {
        'name': name,
        'members': members,
      };

  Group copy(List<Character> newMembers) => Group(name: name, members: newMembers);
}

class Initiative implements Comparable<Initiative> {
  final int roll;
  final int priority;

  Initiative({required this.roll, this.priority = 0});

  @override
  bool operator ==(other) {
    return (other is Initiative && other.roll == roll && other.priority == priority);
  }

  @override
  int get hashCode => roll.hashCode * priority.hashCode;

  @override
  int compareTo(Initiative other) {
    final rollResult = roll.compareTo(other.roll);
    if (rollResult != 0) {
      // higher roll first
      return -rollResult;
    } else {
      // higher priority first
      return -priority.compareTo(other.priority);
    }
  }

  Initiative addPriority(int value) {
    return Initiative(roll: roll, priority: priority + value);
  }
}
