import 'package:test/test.dart';
import 'package:flutter_playground/state.dart';

main () {
  test('move right', () {
    BoardState bs = new BoardState([
      [0, 2, 0, 0],
      [0, 2, 0, 2],
      [8, 0, 4, 4],
      [2, 2, 0, 2],
    ]);

    expect(bs.moveRight().tiles, [
      [0, 0, 0, 2],
      [0, 0, 0, 4],
      [0, 0, 8, 8],
      [0, 0, 2, 4],
    ]);
  });

  test('move up', () {
    BoardState bs = new BoardState([
      [0, 2, 0, 0],
      [0, 2, 0, 2],
      [8, 0, 4, 4],
      [2, 2, 0, 2],
    ]);

    expect(bs.moveUp().tiles, [
      [8, 4, 4, 2],
      [2, 2, 0, 4],
      [0, 0, 0, 2],
      [0, 0, 0, 0],
    ]);
  });

  test('move left', () {
    BoardState bs = new BoardState([
      [0, 2, 0, 0],
      [0, 2, 0, 2],
      [8, 0, 4, 4],
      [2, 2, 0, 2],
    ]);

    expect(bs.moveLeft().tiles, [
      [2, 0, 0, 0],
      [4, 0, 0, 0],
      [8, 8, 0, 0],
      [4, 2, 0, 0],
    ]);
  });
  
  test('move down', () {
    BoardState bs = new BoardState([
      [0, 2, 0, 0],
      [0, 2, 0, 2],
      [8, 0, 4, 4],
      [2, 2, 0, 2],
    ]);

    expect(bs.moveDown().tiles, [
      [0, 0, 0, 0],
      [0, 0, 0, 2],
      [8, 2, 0, 4],
      [2, 4, 4, 2],
    ]);
  });
}
