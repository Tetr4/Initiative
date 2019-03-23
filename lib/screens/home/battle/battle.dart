import 'package:flutter/material.dart';
import 'package:initiative/model/participant.dart';

class StageBody extends StatefulWidget {
  final VoidCallback onEndBattle;
  final List<Participant> lineup;

  StageBody(this.onEndBattle, this.lineup, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StageBodyState();
}

class _StageBodyState extends State<StageBody> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Battle'),
        actions: <Widget>[
          PopupMenuButton<VoidCallback>(
            onSelected: (callback) => callback(),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: widget.onEndBattle, child: Text("End Battle")),
              ];
            },
          ),
        ],
      ),
      body: Scrollbar(
        child: ReorderableListView(
          onReorder: _onReorder,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: widget.lineup.map<Widget>(_buildListTile).toList(),
        ),
      ),
    );

//      floatingActionButton: FloatingActionButton(
//        onPressed: () {},
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ),
  }

}
