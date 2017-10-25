import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_playground/animation_spec.dart';
import 'package:flutter_playground/redux.dart';
import 'package:flutter_playground/state.dart';
import 'package:flutter_playground/store/store.dart';

class GameGrid extends StatefulWidget {
  @override
  State createState() => new GameGridState();
}

class GameGridState extends State<GameGrid> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    CurrentStoreState<BoardState, Action> storeState =
      GameRedux.stateOf(context);
    BoardState state = GameRedux.stateOf(context).currentState;

    List<TileMotionSpec> motionSpec = buildMotionSpec(
      storeState.previousState,
      storeState.currentState,
      storeState.lastAction
    );

    List<Tile> tiles = new List<Tile>();
    var prevTiles = storeState?.previousState?.tiles ?? state.tiles;
    for (int i = 0; i < motionSpec.length; i += 1) { 
      TileMotionSpec spec = motionSpec[i];
      int value;
      if (spec.fadeIn)
        value = storeState.currentState.tiles[spec.toI][spec.toJ];
      else
        value = prevTiles[spec.fromI][spec.fromJ];
      tiles.add(new Tile(
          spec.fromI,
          spec.fromJ,
          spec.toI,
          spec.toJ,
          value,
          storeState.currentState.dimension,
          vsync: this,
          fadeIn: spec.fadeIn,
      ));
    }
    if (state.lastTileAdded != null) {
      tiles.add(new Tile(
          state.lastTileAdded.x,
          state.lastTileAdded.y,
          state.lastTileAdded.x,
          state.lastTileAdded.y,
          state.tiles[state.lastTileAdded.x][state.lastTileAdded.y],
          storeState.currentState.dimension,
          vsync: this,
          fadeIn: true
      ));
    }

    return new AspectRatio(
      aspectRatio: 1.0,
      child: new Stack(
        children: tiles
      )
    );
  }

}

class Tile extends StatelessWidget {
  final int prevI;
  final int prevJ;
  final int i;
  final int j;
  final int value;
  final int boardDimension;
  final bool fadeIn;
  final TickerProvider vsync;

  Tile(this.prevI, this.prevJ, this.i, this.j, this.value, this.boardDimension, {
    this.vsync,
    this.fadeIn = false,
  });

  @override
  Widget build(BuildContext context) {
    double sizeFraction = 1.0 / boardDimension.toDouble();

    double maxTileIndex = (boardDimension -1 ).toDouble();
    double toXPosition = lerpDouble(-1.0, 1.0, j.toDouble() / maxTileIndex);
    double fromXPosition = lerpDouble(-1.0, 1.0, prevJ.toDouble() / maxTileIndex);
    double toYPosition = lerpDouble(-1.0, 1.0, i.toDouble() / maxTileIndex);
    double fromYPosition = lerpDouble(-1.0, 1.0, prevI.toDouble() / maxTileIndex);

    Animation<Alignment> alignment = new AlignmentTween(
      begin: new Alignment(fromXPosition, fromYPosition),
      end: new Alignment(toXPosition, toYPosition)
    ) .animate(
    new CurvedAnimation(
      curve: Curves.easeOut,
      parent: new AnimationController(
        duration: new Duration(milliseconds: 150),
        vsync: vsync,
      )..forward(),
    )
    );


    Animation<double> fadeAnimation;
    if (fadeIn) {
      AnimationController controller = new AnimationController(
        duration: new Duration(milliseconds: 300),
        vsync: vsync,
      );
      fadeAnimation =
        new CurvedAnimation(parent: controller, curve: Curves.easeOut);
      controller.forward();
    } else {
      fadeAnimation = new AlwaysStoppedAnimation(1.0);
    }
    return new AlignTransition(
      child: new FractionallySizedBox(
        widthFactor: sizeFraction,
        heightFactor: sizeFraction,
        child: new Padding(
          padding: new EdgeInsets.all(4.0),
          child: new FadeTransition(
            opacity: fadeAnimation,
            child: new Container(
              child: new Center(
                child: new Text(value.toString()),
              ),
              color: _colorForValue(value),
            ),
          ),
        ),
      ),
      alignment: alignment
    );
  }

  static Color _colorForValue(int value) {
    var color;
    switch(value) {
      case 2:
        color = Colors.yellow;
        break;
      case 4:
        color = Colors.lightGreen;
        break;
      case 8:
        color = Colors.blue;
        break;
      case 16:
        color = Colors.amber;
        break;
      case 32:
        color = Colors.cyan;
        break;
      case 64:
        color = Colors.orange;
        break;
      case 128:
        color = Colors.deepOrange;
        break;
      case 256:
        color = Colors.brown;
        break;
      case 512:
        color = Colors.blueGrey;
        break;
      case 1024:
        color = Colors.pink;
        break;
      case 2048:
        color = Colors.green;
        break;
      default:
        color = Colors.red;
    }
    return color;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(new DiagnosticsProperty<int>('value', value));
    description.add(new DiagnosticsProperty<int>('prevI', prevI));
    description.add(new DiagnosticsProperty<int>('prevJ', prevJ));
    description.add(new DiagnosticsProperty<int>('i', i));
    description.add(new DiagnosticsProperty<int>('j', j));
  }

}

