import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:minesweepr/data/Cell.dart';
import 'package:minesweepr/data/Coordinate.dart';

class Grid {
  final int width;
  final int height;
  final int bombCount;

  Grid({
    @required this.width,
    @required this.height,
    @required this.bombCount,
  })  : assert(width != null),
        assert(height != null),
        assert(bombCount != null);

  List<List<Cell>> _grid = [];

  int _cellCount = 0;
  int get cellCount => _cellCount;

  bool get isInitialized => _grid.isNotEmpty;

  bool get isClean => _allBombsMarked; // || _allNonBombsRevealed;

  bool get _allBombsMarked {
//    return !_grid.any((List<Cell> row) => !_allBombsInRowMarked(row));
    return !_grid.any((List<Cell> row) => _rowHasUnmarkedBombs(row));
  }

  bool _allBombsInRowMarked(List<Cell> row) {
    List<Cell> bombs = row;
    bombs.retainWhere((Cell cell) => cell.isBomb);
    return !bombs.any((Cell cell) => !cell.isMarkedAsBomb);
  }

  bool _rowHasUnmarkedBombs(List<Cell> row) {
    List<Cell> bombsInRow = row;
    bombsInRow.retainWhere((Cell cell) => cell.isBomb);
    return bombsInRow.any((Cell bomb) => !bomb.isMarkedAsBomb);
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

  void generateGrid(Coordinate safeCoordinate) {
    _initializeGrid(width, height);
    _fillGridWithBombs(bombCount, safeCoordinate);
    _fillNeighborBombCounts();
  }

  void _initializeGrid(int width, int height) {
    _grid = List.generate(width, (int x) =>
      List.generate(height, (int y) => Cell(x, y))
    );
    _cellCount = width * height;
  }

  void _fillGridWithBombs(int count, Coordinate safeCoordinate) {
    int bombsRemaining = count;
    while (bombsRemaining > 0) {
      int randomX = Random().nextInt(width - 1);
      int randomY = Random().nextInt(height - 1);

      if (!_grid[randomX][randomY].isBomb && !_isBombNearSafeCoordinate(Coordinate(randomX, randomY), safeCoordinate)) {
        _grid[randomX][randomY].setBomb();
        bombsRemaining--;
      }
    }
  }

  bool _isBombNearSafeCoordinate(Coordinate bombCoordinate, Coordinate safeCoordinate) {
    for (int xPrime=-1; xPrime<=1; xPrime++) {
      for (int yPrime=-1; yPrime<=1; yPrime++) {
        if (Coordinate(safeCoordinate.x + xPrime,  safeCoordinate.y + yPrime) == bombCoordinate)
          return true;
      }
    }
    return false;
  }

  void _fillNeighborBombCounts() {
    for (int x=0; x<width; x++) {
      for (int y=0; y<height; y++) {
        if (!_grid[x][y].isBomb) {
          List<Cell> neighbors = getNeighbors(x, y);
          neighbors.retainWhere((Cell neighbor) => neighbor.isBomb);
          _grid[x][y].value = neighbors.length;
        }
      }
    }
  }

  List<Cell> getNeighbors(int x, int y) {
    List<Cell> neighbors = [];
    for (int xPrime = -1; xPrime <= 1; xPrime++) {
      for (int yPrime = -1; yPrime <= 1; yPrime++) {
        if (!(xPrime == 0 && yPrime == 0) && _cellExists(x + xPrime, y + yPrime)) {
          neighbors.add(_grid[x + xPrime][y + yPrime]);
        }
      }
    }
    return neighbors;
  }

  bool _cellExists(int x, int y) =>
      x >= 0 && x < width &&
      y >= 0 && y < height;

  Cell cell(Coordinate coordinate) => _grid[coordinate.x][coordinate.y];

  void _print() {
    print("----- PRINTING GENERATED GRID -----");
    String line;
    for (int y=0; y<height; y++) {
      line = "|";
      for (int x=0; x<width; x++) {
        line += _grid[x][y].toString().padLeft(3).padRight(5);
      }
      line += "|";
      print(line);
    }
    print("------------ END GRID -------------");
  }
}
