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

  Group({@required this.name, this.members = const []});

  Group copy(List<Character> newMembers) =>
      Group(name: this.name, members: newMembers);
}
