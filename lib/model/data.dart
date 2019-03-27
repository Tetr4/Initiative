class Character {
  final String name;
  final String description;
  final CharacterType type;

  Character(this.name, this.description, this.type);

  Character.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        type = json['type'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'type': type,
      };
}

enum CharacterType { ADVENTURER, NPC }

class Group {
  final String name;
  final List<Character> members;

  Group(this.name, this.members);

  Group copy(List<Character> newMembers) {
    return Group(this.name, newMembers);
  }
}
