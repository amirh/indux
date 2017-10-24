import 'package:test/test.dart';
import 'package:flutter_playground/state.dart';

main () {
  test('move Right', () {
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

  test('move Up', () {
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

}
