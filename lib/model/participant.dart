class Participant {
  final String name;

  Participant(this.name);
}

class Character extends Participant {
  final String description;

  Character(String name, this.description) : super(name);
}

class Npc extends Participant {
  Npc(String name) : super(name);
}
