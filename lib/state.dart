class BoardState {
  final List<List<int>> tiles;
  final int dimension;

  BoardState(this.tiles) : dimension = tiles.length {
    tiles.forEach((row) { assert(row.length == dimension); });
  }

  BoardState moveRight() {
    List<List<int>> result = new List<List<int>>(dimension);
    for (int i = 0; i < dimension; i += 1) {
      List<int> row = tiles[i];
      List<int> newRow = new List<int>.filled(dimension, 0);
      result[i] = newRow;
      int rightMostModifable = dimension - 1;
      for (int j = dimension - 1; j >= 0; j--) {
        if (row[j] == 0)
          continue;

        if (row[j] == newRow[rightMostModifable]) {
          newRow[rightMostModifable] *= 2;
          rightMostModifable--;
          continue;
        }

        if (newRow[rightMostModifable] == 0) {
          newRow[rightMostModifable] = row[j];
          continue;
        }

        rightMostModifable -= 1;
        newRow[rightMostModifable] = row[j];
      }
    }
    return new BoardState(result);
  }

  BoardState moveUp() {
    return rotateClockWise()
      .moveRight()
      .rotateClockWise()
      .rotateClockWise()
      .rotateClockWise();
  }

  BoardState rotateClockWise() {
    List<List<int>> result = new List<List<int>>(dimension);
    for (int i = 0; i < dimension; i++) {
      result[i] = new List<int>(dimension);
      for (int j = 0; j < dimension; j++) {
        result[i][j] = tiles[dimension - 1 - j][i];
      }
    }
    return new BoardState(result);
  }
}
