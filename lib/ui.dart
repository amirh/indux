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

    double toXPosition = lerpDouble(-1.0, 1.0, j.toDouble() / boardDimension.toDouble());
    double fromXPosition = lerpDouble(-1.0, 1.0, prevJ.toDouble() / boardDimension.toDouble());
    double toYPosition = lerpDouble(-1.0, 1.0, i.toDouble() / boardDimension.toDouble());
    double fromYPosition = lerpDouble(-1.0, 1.0, prevI.toDouble() / boardDimension.toDouble());

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
    return new AlignmentTransition(
      child: new FractionallySizedBox(
        widthFactor: sizeFraction,
        heightFactor: sizeFraction,
        child: new Padding(
          padding: new EdgeInsets.all(15.0),
          child: new FadeTransition(
            opacity: fadeAnimation,
            child: new Container(
              child: new Center(
                child: new Text(value.toString()),
              ),
              color: Colors.blue,
            ),
          ),
        ),
      ),
      alignment: alignment
    );
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


class AlignmentTransition extends AnimatedWidget {
  const AlignmentTransition({Animation<Alignment> alignment, this.child}) : super(listenable: alignment);

  final Widget child;
  Animation<Alignment> get alignment => listenable;

  @override
  Widget build(BuildContext context) {
    return new Align(alignment: alignment.value, child: child);
  }
}
