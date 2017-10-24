import 'package:flutter_playground/state.dart';
import 'package:flutter_playground/redux.dart';

class TileMotionSpec {
  final int fromI;
  final int fromJ;
  final int toI;
  final int toJ;
  final bool fadeIn;

  TileMotionSpec(this.fromI, this.fromJ, this.toI, this.toJ, {this.fadeIn = false});

  @override
  String toString() {
    return 'MotionSpec: from ($fromI, $fromJ) to ($toI, $toJ) fadeIn: $fadeIn';
  }

}

List<TileMotionSpec> buildMotionSpec(BoardState fromState, BoardState toState, Action action) {
    if (action?.type == ActionType.moveRight) {
      return _buildMoveRightSpec(fromState, toState, action);
    }

    return _buildFixedMotionSpec(toState);
}

List<TileMotionSpec> _buildMoveRightSpec(BoardState fromState, BoardState toState, Action action) {
  int dimen = toState.dimension;
  List<TileMotionSpec> motionSpec = new List<TileMotionSpec>();
  for (int i = 0; i < dimen; i += 1) {
    int prevJ = dimen - 1;
    for (int j = dimen -1 ; j >= 0; j -= 1) {
      if(toState.tiles[i][j] == 0)
        continue;

      while (prevJ > 0 && fromState.tiles[i][prevJ] == 0) {
        prevJ -= 1;
      }

      if (i == toState.lastTileAdded?.x && j == toState.lastTileAdded?.y) {
        continue;
      }

      motionSpec.add(new TileMotionSpec(i, prevJ, i, j));

      if (toState.tiles[i][j] != fromState.tiles[i][prevJ]) {
        prevJ -= 1;
        while (prevJ > 0 && fromState.tiles[i][prevJ] == 0) {
          prevJ -= 1;
        }
        motionSpec.add(new TileMotionSpec(i, prevJ, i, j));
        motionSpec.add(new TileMotionSpec(i, j, i, j, fadeIn: true));
      }

      prevJ -= 1;
    }
  }

  return motionSpec;
}

List<TileMotionSpec> _buildFixedMotionSpec(BoardState toState) {
  List<TileMotionSpec> motionSpec = new List<TileMotionSpec>();
  for (int i = 0; i < toState.dimension; i += 1) {
    for (int j = 0; j < toState.dimension; j++) {
      if (toState.tiles[i][j] != 0)
        motionSpec.add(new TileMotionSpec(i, j, i, j));
    }
  }
  return motionSpec;
}
