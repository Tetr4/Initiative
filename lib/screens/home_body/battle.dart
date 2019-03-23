import 'package:flutter/material.dart';
import 'package:initiative/model/participant.dart';

class BattleBody extends StatefulWidget {
  final VoidCallback onEndBattle;
  final List<Participant> lineup;

  BattleBody(this.onEndBattle, this.lineup, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BattleBodyState();
}

class _BattleBodyState extends State<BattleBody> {
  _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Participant item = widget.lineup.removeAt(oldIndex);
      widget.lineup.insert(newIndex, item);
    });
  }

  ListTile _buildListTile(Participant participant) {
    return ListTile(
      key: ObjectKey(participant),
      title: Text('${participant.name}'),
      // TODO use handle for dragging, instead of long-press
      trailing: Icon(Icons.drag_handle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ReorderableListView(
        onReorder: _onReorder,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: widget.lineup.map<Widget>(_buildListTile).toList(),
      ),
    );
  }
}
