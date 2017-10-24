import 'package:flutter/material.dart';
import 'package:flutter_playground/redux.dart';

void main() {
  runApp(new App2048());
}

class App2048 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '2048',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new GameRedux(
        child: new GameBoard()
      ),
    );
  }
}

class GameBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onHorizontalDragEnd: (DragEndDetails d) {
          if (d.primaryVelocity > 0) {
            GameRedux.dispatch(context, new Action(ActionType.moveRight));
          } else {
            GameRedux.dispatch(context, new Action(ActionType.moveLeft));
          }
        },
        onVerticalDragEnd: (DragEndDetails d) {
          if (d.primaryVelocity > 0) {
            GameRedux.dispatch(context, new Action(ActionType.moveDown));
          } else {
            GameRedux.dispatch(context, new Action(ActionType.moveUp));
          }
        },
        child: new Text(GameRedux.stateOf(context).currentState.tiles.toString()),
    );
  }
}
