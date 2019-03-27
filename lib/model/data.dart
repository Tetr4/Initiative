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

class Group {
  final String name;
  final List<Adventurer> adventurers;

  Group(this.name, this.adventurers);

  Group copy(List<Adventurer> adventurers) {
    return Group(this.name, adventurers);
  }
}
