import 'package:flutter/widgets.dart';

class CurrentStoreState<StateType, ActionType> {
  final StateType currentState;
  final ActionType lastAction;
  final StateType previousState;

  const CurrentStoreState(this.currentState, this.lastAction, this.previousState);
}

typedef StateType Reducer<StateType, ActionType>(StateType state, ActionType action);

class Store<StateType, ActionType> extends StatefulWidget {
  final Widget child;
  final Reducer<StateType, ActionType> reduce;
  final StateType initialState;

  Store({this.child, this.initialState, reducer}): this.reduce = reducer;

  @override
  State createState() => new _StoreState<StateType, ActionType>();

  static CurrentStoreState storeStateOf(BuildContext context) {
    final _StoreScope storeScope = context.inheritFromWidgetOfExactType(_StoreScope);
    return storeScope?.state?.state;
  }

  static void dispatch<ActionType>(BuildContext context, ActionType action) {
    final _StoreScope storeScope = context.inheritFromWidgetOfExactType(_StoreScope);
    storeScope.state.dispatch(action);
  }
}

class _StoreState<StateType, ActionType> extends State<Store<StateType, ActionType>> {
  CurrentStoreState<StateType, ActionType> state;

  void dispatch(ActionType action) {
    StateType newState = widget.reduce(state.currentState, action);
    setState(() {
      state = new CurrentStoreState<StateType, ActionType>(
        newState,
        action,
        state.currentState
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _StoreScope(this, child: widget.child);
  }

  @override
  void initState() {
    super.initState();
    state = new CurrentStoreState(widget.initialState, null, null);
  }
}

class _StoreScope extends InheritedWidget {
  final _StoreState state;

  _StoreScope(this.state, {Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(_StoreScope old) {
    return true;
  }
}
