import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minesweepr/data/Cell.dart';
import 'package:minesweepr/data/Coordinate.dart';
import 'package:minesweepr/data/Grid.dart';
import 'package:minesweepr/ui/colors.dart';
import 'package:minesweepr/ui/grid_cell.dart';

class GameGrid extends StatefulWidget {
  final Grid grid;
  final Function updateBombsRemaining;
  final Function initGame;
  final Function finishGame;

  const GameGrid({
    Key key,
    @required this.grid,
    @required this.initGame,
    @required this.updateBombsRemaining,
    @required this.finishGame
  }) : super(key: key);

  @override
  GameGridState createState() => GameGridState();
}

class GameGridState extends State<GameGrid> with SingleTickerProviderStateMixin {
  Grid grid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    grid = widget.grid;

    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.black
      ),
      child: Column(
        children: List.generate(
          grid.height,
          (y) => _buildRow(context, y)
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, int y) {
    double cellSize = (MediaQuery.of(context).size.width - 28) / grid.width;

    return Row(
      children: List.generate(
        grid.width,
        (x) => _buildCell(x, y, cellSize)),
    );
  }

  Widget _buildCell(int x, int y, double size) {
    Cell cell = _getCell(x, y);

    return cell != null
      ? GridCell(
        cell: cell,
        size: size,
        toggleBomb: _toggleBomb,
        revealBombs: _revealBombs,
        revealNeighbors: _revealNeighbors,
        isClean: grid.isClean,
      )
      : Container(
          padding: const EdgeInsets.all(0.5),
          width: size,
          height: size,
          child: MaterialButton(
            elevation: 0.0,
            color: colorConcealedCell,
            disabledColor: colorConcealedCell,
            onPressed: () {
              _initGame(x, y);
            },
          ),
      );
  }

  void newGame() {
    setState(() {
      grid.reset();
    });
  }

  void _initGame(int x, int y) {
    Coordinate safeCoordinate = Coordinate(x, y);
    grid.generateGrid(safeCoordinate);
    if (grid.isInitialized) {
      Cell safeCell = grid.cell(safeCoordinate);
      _revealCell(safeCell);
    }

    widget.initGame();
  }

  void _revealBombs({bool won = false}) {
    int index = 0;
    Timer.periodic(Duration(microseconds: 2000), (Timer t) {
      if (index < (grid.width*grid.height)) {
        Cell cell = grid.cell(_getCoordinate(index));
        if (cell.isBomb && !cell.isRevealed) {
          setState(() {
            cell.isRevealed = true;
          });
        }
        index++;
      } else {
        widget.finishGame(won: won);
        t.cancel();
      }
    });
  }

  void _revealNeighbors(Cell cell) {
    List<Cell> neighbors = grid.getNeighbors(cell.locationX, cell.locationY);
    neighbors.retainWhere((Cell neighbor) => !neighbor.isRevealed);
    neighbors.forEach((Cell neighbor) => _revealCell(neighbor));
  }

  void _revealCell(Cell cell) {
    setState(() {
      cell.isRevealed = true;
    });

    if (cell.isBomb) {
      _revealBombs();
    } else if (cell.hasNoNeighboringBombs) {
      _revealNeighbors(cell);
    }
  }

  void _toggleBomb(Cell cell) {
    setState(() {
      cell.toggleMarkAsBomb();
      grid.updateGameStatus(cell);
      widget.updateBombsRemaining(cell.isMarkedAsBomb ? -1 : 1);
    });
    if (grid.isClean) {
      _revealBombs(won: true);
    }
  }

  Cell _getCell(int row, int col) {
    Coordinate coordinate = Coordinate(row, col);
    return grid.cell(coordinate);
  }

  Coordinate _getCoordinate(int index) {
    int x = index % grid.width;
    int y = index ~/ grid.width;
    return Coordinate(x, y);
  }
}
