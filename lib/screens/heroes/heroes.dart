import 'package:flutter/material.dart';
import 'package:initiative/model/group.dart';

class HeroesScreen extends StatelessWidget {
  // TODO heroes property
  final Group group;

  HeroesScreen(this.group, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heroes'),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.shopping_cart),
//            tooltip: 'Open shopping cart',
//            onPressed: () {
//              // ...
//            },
//          ),
//        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Heroes.'),
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
        tooltip: 'Add hero',
        child: Icon(Icons.add),
      ),
    );
  }

}

class HeroDialog extends StatelessWidget {
  const HeroDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New Hero"),
      content: Text("New Hero"),
      actions: <Widget>[
        new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
    );
  }
}