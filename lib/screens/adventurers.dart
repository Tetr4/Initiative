import 'package:flutter/material.dart';
import 'package:initiative/model/data.dart';
import 'package:initiative/model/groups.dart';
import 'package:initiative/screens/dialogs/create_adventurer.dart';
import 'package:scoped_model/scoped_model.dart';

class AdventurersScreen extends StatefulWidget {
  final int groupIndex;

  AdventurersScreen({Key key, @required this.groupIndex}) : super(key: key);

  @override
  _AdventurersScreenState createState() => _AdventurersScreenState();
}

class _AdventurersScreenState extends State<AdventurersScreen> {
  List<Adventurer> adventurers;
  GroupsModel groups;

  _addAdventurer(Adventurer adventurer) {
    groups.addAdventurer(widget.groupIndex, adventurer);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GroupsModel>(
        builder: (context, child, groups) {
      this.groups = groups;
      final group = groups.items[widget.groupIndex];
      this.adventurers = group.adventurers;
      return Scaffold(
        appBar: AppBar(title: Text('Edit ${group.name}')),
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
    });
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
