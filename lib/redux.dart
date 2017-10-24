import 'dart:math' show Random;

import 'package:flutter/widgets.dart';
import 'package:flutter_playground/store/store.dart';
import 'package:flutter_playground/state.dart';

enum ActionType {
  moveLeft,
  moveUp,
  moveRight,
  moveDown
}

class Action {
  final ActionType type;
  final int randomInt;

  Action(this.type, {this.randomInt});
}

class GameRedux extends StatelessWidget {
  final Widget child;

  GameRedux({this.child});

  @override
  Widget build(BuildContext context) {
    return new Store<BoardState, Action>(
      child: child,
      initialState: new BoardState([
        [2, 0, 2, 0],
        [0, 0, 0, 0],
        [0, 0, 4, 0],
        [0, 0, 0, 0],
      ]),
      reducer: reduce,
    );
  }

  static BoardState reduce(BoardState state, Action action) {
    switch (action.type) {
      case ActionType.moveLeft:
        return state.moveLeft().addNewTile(action.randomInt, _maxRand);
      case ActionType.moveUp:
        return state.moveUp().addNewTile(action.randomInt, _maxRand);
      case ActionType.moveRight:
        return state.moveRight().addNewTile(action.randomInt, _maxRand);
      case ActionType.moveDown:
        return state.moveDown().addNewTile(action.randomInt, _maxRand);
    }
    return state;
  }

  static CurrentStoreState<BoardState, Action> stateOf(BuildContext context) {
    return Store?.storeStateOf(context);
  }

  static void dispatch(BuildContext context, Action action) {
    Store?.dispatch(context, action);
  }
}

const int _maxRand = 1000;
Random _rand = new Random.secure();

Action moveUp() {
  return new Action(ActionType.moveUp, randomInt: _rand.nextInt(_maxRand));
}

Action moveRight() {
  return new Action(ActionType.moveRight, randomInt: _rand.nextInt(_maxRand));
}

Action moveDown() {
  return new Action(ActionType.moveDown, randomInt: _rand.nextInt(_maxRand));
}

Action moveLeft() {
  return new Action(ActionType.moveLeft, randomInt: _rand.nextInt(_maxRand));
}
