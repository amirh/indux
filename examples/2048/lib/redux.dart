import 'dart:math' show Random;

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_playground/state.dart';
import 'package:indux/indux.dart';

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
        return _addNewTileIfMoved(state.moveLeft(), state, action.randomInt);
      case ActionType.moveUp:
        return _addNewTileIfMoved(state.moveUp(), state, action.randomInt);
      case ActionType.moveRight:
        return _addNewTileIfMoved(state.moveRight(), state, action.randomInt);
      case ActionType.moveDown:
        return _addNewTileIfMoved(state.moveDown(), state, action.randomInt);
    }
    return state;
  }

  static BoardState _addNewTileIfMoved(BoardState newState, BoardState prevState, int randomInt) {
    if (const DeepCollectionEquality().equals(prevState.tiles, newState.tiles)) {
      return new BoardState(prevState.tiles);
    }
    return newState.addNewTile(randomInt, _maxRand);
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
