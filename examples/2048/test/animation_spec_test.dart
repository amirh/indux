import 'dart:math' show Point;

import 'package:test/test.dart';
import 'package:flutter_playground/state.dart';
import 'package:flutter_playground/redux.dart';
import 'package:flutter_playground/animation_spec.dart';

main() {
  test('move right', () {
    BoardState fromState = new BoardState([
      [0, 2, 0, 0],
      [0, 2, 0, 2],
      [8, 0, 4, 4],
      [2, 2, 0, 2],
    ]);

    BoardState toState = new BoardState(
      [
        [0, 2, 0, 2],
        [0, 0, 0, 4],
        [0, 0, 8, 8],
        [0, 0, 2, 4],
      ],
      lastTileAdded: new Point<int>(0,1),
    );

    List<TileMotionSpec> motionSpec =
      buildMotionSpec(fromState, new Action(ActionType.moveRight), toState);
    expect(motionSpec.toString(), [
      new TileMotionSpec(0, 1, 0, 3),
      new TileMotionSpec(1, 3, 1, 3),
      new TileMotionSpec(1, 1, 1, 3),
      new TileMotionSpec(1, 3, 1, 3, fadeIn: true),
      new TileMotionSpec(2, 3, 2, 3),
      new TileMotionSpec(2, 2, 2, 3),
      new TileMotionSpec(2, 3, 2, 3, fadeIn: true),
      new TileMotionSpec(2, 0, 2, 2),
      new TileMotionSpec(3, 3, 3, 3),
      new TileMotionSpec(3, 1, 3, 3),
      new TileMotionSpec(3, 3, 3, 3, fadeIn: true),
      new TileMotionSpec(3, 0, 3, 2),
    ].toString());
  });
}

