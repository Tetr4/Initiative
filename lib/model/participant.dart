class Participant {
  final String name;

  Participant(this.name);
}

class Adventurer extends Participant {
  final String description;

  Adventurer(String name, this.description) : super(name);
}

class Npc extends Participant {
  Npc(String name) : super(name);
}
