import 'package:flutter/material.dart';

class LandingBody extends StatelessWidget {
  final Function(BuildContext) onStartLineup;

  LandingBody({Key key, @required this.onStartLineup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Battle not started yet.'),
          RaisedButton(
            child: const Text("FIGHT!"),
            onPressed: () => onStartLineup(context),
          )
        ],
      ),
    );
  }
}
