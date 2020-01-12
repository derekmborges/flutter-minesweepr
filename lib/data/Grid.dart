
import 'dart:math';

import 'package:minesweepr/data/Cell.dart';
import 'package:minesweepr/data/Coordinate.dart';

class Grid {
  final int width;
  final int height;
  final int bombCount;

  Grid(this.width, this.height, this.bombCount);

  List<List<Cell>> _grid;

  bool get isInitialized => _grid.isNotEmpty;

  bool get isClean => _allBombsMarked || _allNonBombsRevealed;

  bool get _allBombsMarked {
    return !_grid.any((List<Cell> row) => !_allBombsInRowMarked(row));
  }

  bool _allBombsInRowMarked(List<Cell> row) {
    List<Cell> cells = row;
    cells.retainWhere((Cell cell) => cell.isBomb);
    return !cells.any((Cell cell) => !cell.isMarkedAsBomb);
  }

  bool get _allNonBombsRevealed {
    return !_grid.any((List<Cell> row) => !_allNonBombsInRowRevealed(row));
  }

  bool _allNonBombsInRowRevealed(List<Cell> row) {
    List<Cell> cells = row;
    cells.retainWhere((Cell cell) => !cell.isBomb);
    return !cells.any((Cell cell) => !cell.isRevealed);
  }

  int get markedBombs {
    int total = 0;
    for (List<Cell> row in _grid) {
      for (Cell cell in row) {
        if (cell.isMarkedAsBomb) {
          total++;
        }
      }
    }
    return total;
  }

  void reset() {
    _grid = [];
  }

  void generateGrid(int safeX, int safeY) {
    _initializeGrid(width, height);
//    fill grid with bombs
//  fill neighbor bomb counts
  }

  void _initializeGrid(int width, int height) {
    _grid = List.generate(width, (int x) =>
      List.generate(height, (int y) => Cell(x, y))
    );
  }

  void _fillGridWithBombs(int count, Coordinate safeCoordinate) {
    int bombsRemaining = count;
    while (bombsRemaining > 0) {
      int randomX = Random().nextInt(width - 1);
      int randomY = Random().nextInt(height - 1);

//      if (!_grid[randomX][randomY].isBomb && //is bomb near safe coordinate)
    }
  }

//  bool _isBombNearSafeCoordinate(Coordinate bombCoordinate, Coordinate safeCoordinate) {
//    range(1, start: -1).forEach((int xPrime) => {
//      range(1, start: -1).forEach((int yPrime) => {
//        if (Pair(safeCoordinate.x + xPrime, safeCoordinate.y + yPrime) == bombCoordinate)
//          return true;
//      })
//    });
//  }

  range(int stop, {int start: 0, int step: 1}) => start < stop == step> 0
      ? List<int>.generate(((start-stop)/step).abs().ceil(), (int i) => start + (i * step))
      : [];
}