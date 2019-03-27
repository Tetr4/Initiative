import 'package:flutter/material.dart';
import 'package:initiative/model/data.dart';
import 'package:initiative/model/groups.dart';
import 'package:initiative/screens/dialogs/create_adventurer.dart';
import 'package:scoped_model/scoped_model.dart';

class AdventurersScreen extends StatelessWidget {
  final int groupIndex;

  AdventurersScreen({Key key, @required this.groupIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GroupsModel>(
        builder: (context, child, groups) {
      final group = groups.items[groupIndex];
      return Scaffold(
        appBar: AppBar(title: Text('Edit ${group.name}')),
        body: _buildAdventurerList(group.adventurers),
        floatingActionButton: _buildCreateAdventurerButton(context,
            (adventurer) => groups.addAdventurer(groupIndex, adventurer)),
      );
    });
  }

  _buildAdventurerList(List<Adventurer> adventurers) {
    return ListView.builder(
      itemCount: adventurers.length,
      itemBuilder: (context, index) => _buildAdventurerItem(adventurers[index]),
    );
  }

  Widget _buildAdventurerItem(Adventurer adventurer) {
    return ListTile(
      title: Text(adventurer.name),
      subtitle: Text(adventurer.description),
    );
  }

  FloatingActionButton _buildCreateAdventurerButton(
      BuildContext context, Function(Adventurer) onCreate) {
    return FloatingActionButton(
      onPressed: () => _showCreateAdventurerDialog(context, onCreate),
      tooltip: 'Add adventurer',
      child: Icon(Icons.add),
    );
  }

  _showCreateAdventurerDialog(
    BuildContext context,
    Function(Adventurer) onCreate,
  ) =>
      showDialog(
        context: context,
        builder: (BuildContext context) => AdventurerDialog(onCreate: onCreate),
      );
}
