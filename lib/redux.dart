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

  Action(this.type);
}

class GameRedux extends StatelessWidget {
  final Widget child;

  GameRedux({this.child});

  @override
  Widget build(BuildContext context) {
    return new Store<BoardState, Action>(
      child: child,
      initialState: new BoardState([
        [0, 0, 2, 0],
        [0, 0, 0, 0],
        [0, 0, 4, 0],
        [0, 0, 0, 0],
      ]),
      reducer: (BoardState state, Action action) {
        switch (action.type) {
          case ActionType.moveLeft:
            return state.moveLeft();
          case ActionType.moveUp:
            return state.moveUp();
          case ActionType.moveRight:
            return state.moveRight();
          case ActionType.moveDown:
            return state.moveDown();
        }
      }
    );
  }

  static CurrentStoreState<BoardState, Action> stateOf(BuildContext context) {
    return Store?.storeStateOf(context);
  }

  static void dispatch(BuildContext context, Action action) {
    Store?.dispatch(context, action);
  }
}
