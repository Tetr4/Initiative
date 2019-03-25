import 'package:flutter/material.dart';
import 'package:initiative/model/group.dart';

class AdventurersScreen extends StatelessWidget {
  final Group group;

  AdventurersScreen({Key key, @required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adventurers'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Adventurers.'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return new HeroDialog();
              });
        },
        tooltip: 'Add adventurer',
        child: Icon(Icons.add),
      ),
    );
  }
}

class HeroDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New Adventurer"),
      content: Text("New Adventurer"),
      actions: <Widget>[
        new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              // TODO
              Navigator.of(context).pop();
            })
      ],
    );
  }
}
