// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// A Redux store widget.
///
/// A Widget hierarchy can only have a single [Store] object.
///
/// Widgets down the tree can dispatch actions by calling [Store.dispatch].

/// Widgets down the tree canand depend on the store's state by fetching it with
/// [Store.storeStateOf], as this is using [InheritedWidget], widgets that
/// depend on the store's state will get rebuilt when the state changes.
class Store<StateType, ActionType> extends StatefulWidget {

  final Widget child;

  final Reducer<StateType, ActionType> reducer;

  final StateType initialState;

  final List<OnStoreUpdate<ActionType>> middleware;

  Store({
    @required this.child,
    @required this.initialState,
    @required this.reducer,
    this.middleware = const<OnStoreUpdate>[]
  });

  @override
  State createState() => new _StoreState<StateType, ActionType>();

  /// Returns the [StoreUpdate] of the Store.
  ///
  /// The context of the calling widget is be used to fetch the store from the
  /// widget tree.
  static StoreUpdate storeStateOf(BuildContext context) {
    final _StoreScope storeScope = context.inheritFromWidgetOfExactType(_StoreScope);
    return storeScope?.state?.update;
  }

  /// Dispatches an action to the Store.
  ///
  /// The context of the calling widget is be used to fetch the store from the
  /// widget tree.
  static void dispatch<ActionType>(BuildContext context, ActionType action) {
    final _StoreScope storeScope = context.inheritFromWidgetOfExactType(_StoreScope);
    storeScope.state.dispatch(action);
  }
}

typedef StateType Reducer<StateType, ActionType>(StateType state, ActionType action);

/// The current state of the store.
///
/// This class bundles the last action and the previous state as well, which is
/// usually the information needed for figuring out which transition to show.
class StoreUpdate<StateType, ActionType> {
  final StateType state;
  final ActionType lastAction;
  final StateType previousState;

  const StoreUpdate(this.state, this.lastAction, this.previousState);

  @override
  String toString() {
    return '($state, $lastAction, $previousState)';
  }

  @override
  bool operator==(other) =>
    other is StoreUpdate
    && other.state == state
    && other.lastAction == lastAction
    && other.previousState == previousState;

  @override
  int get hashCode => hashValues(state, lastAction, previousState);
}

typedef void Dispatch<ActionType>(ActionType action);

typedef void OnStoreUpdate<ActionType>(StoreUpdate update, Dispatch<ActionType> dispatcher);

class _StoreState<StateType, ActionType> extends State<Store<StateType, ActionType>> {
  StoreUpdate<StateType, ActionType> update;

  void dispatch(ActionType action) {
    StateType newState = widget.reducer(update.state, action);
    update = new StoreUpdate<StateType, ActionType>(
        newState,
        action,
        update.state
        );
    setState(() {});
    new Future(() {
       widget.middleware.forEach((m) { m(update, dispatch); });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _StoreScope(this, child: widget.child);
  }

  @override
  void initState() {
    super.initState();
    update = new StoreUpdate(widget.initialState, null, null);
    new Future(() {
       widget.middleware.forEach((m) { m(update, dispatch); });
    });
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


