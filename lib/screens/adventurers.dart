import 'package:flutter/material.dart';
import 'package:initiative/model/group.dart';
import 'package:initiative/model/participant.dart';
import 'package:initiative/screens/dialogs/create_adventurer.dart';

class AdventurersScreen extends StatefulWidget {
  final Group group;

  AdventurersScreen({Key key, @required this.group}) : super(key: key);

  @override
  _AdventurersScreenState createState() =>
      _AdventurersScreenState(group.adventurers.toList());
}

class _AdventurersScreenState extends State<AdventurersScreen> {
  final List<Adventurer> adventurers;

  _AdventurersScreenState(this.adventurers);

  _addAdventurer(Adventurer adventurer) {
    setState(() {
      adventurers.add(adventurer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add adventurers')),
      body: ListView.builder(
        itemCount: adventurers.length,
        itemBuilder: _buildAdventurerItem,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) =>
                  AdventurerDialog(onCreate: _addAdventurer),
            ),
        tooltip: 'Add adventurer',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildAdventurerItem(context, index) {
    final adventurer = adventurers[index];
    return ListTile(
      title: Text(adventurer.name),
      subtitle: Text(adventurer.description),
//      onTap: () => Navigator.pop(context, groups[index]),
    );
  }
}
