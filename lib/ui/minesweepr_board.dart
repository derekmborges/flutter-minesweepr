import 'dart:async';
import 'package:flutter/material.dart';
import 'package:minesweepr/data/Cell.dart';
import 'package:minesweepr/data/Coordinate.dart';
import 'package:minesweepr/data/Difficulty.dart';
import 'package:minesweepr/data/Grid.dart';
import 'package:minesweepr/ui/colors.dart';
import 'package:minesweepr/ui/game_over_dialog.dart';
import 'package:minesweepr/ui/game_over_popup.dart';
import 'package:minesweepr/ui/game_won_dialog.dart';
import 'package:minesweepr/ui/grid_cell.dart';
import 'package:minesweepr/ui/settings_dialog.dart';

class MinesweeprBoard extends StatefulWidget {
  @override
  _MinesweeprBoardState createState() => _MinesweeprBoardState();
}

class _MinesweeprBoardState extends State<MinesweeprBoard> {
  Difficulty selectedDifficulty;
  Grid grid;
  int bombsRemaining;

  @override
  void initState() {
    super.initState();
    selectedDifficulty = mediumDifficulty;
    _initGrid();
  }

  void _initGrid() {
    grid = Grid(
        width: selectedDifficulty.width,
        height: selectedDifficulty.height,
        bombCount: selectedDifficulty.bombCount
    );
    bombsRemaining = selectedDifficulty.bombCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bombs left: $bombsRemaining'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              semanticLabel: 'newgame',
            ),
            onPressed: () {
              setState(() {
                _newGame();
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              semanticLabel: 'settings',
            ),
            onPressed: () {
              _openDifficultyBottomSheet();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.info_outline,
              semanticLabel: 'info',
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: grid.isInitialized ? _gameGrid() : _nullGrid(),
          ),
        ],
      ),
    );
  }

  void _openDifficultyBottomSheet() {
    showModalBottomSheet(context: context, builder: (builder) {
      return SettingsDialog(
        selectedDifficulty: selectedDifficulty,
        difficultyUpdated: _difficultyUpdated,
      );
    });
  }

  void _difficultyUpdated(Difficulty newDifficulty) {
    setState(() {
      selectedDifficulty = newDifficulty;
    });
    _newGame();
  }

  void _newGame() {
    setState(() {
      grid.reset();
      bombsRemaining = selectedDifficulty.bombCount;
    });
  }

  Widget _nullGrid() {
    return GridView.builder(
        key: Key("NullGrid"),
        itemCount: selectedDifficulty.width * selectedDifficulty.height,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: selectedDifficulty.width),
        shrinkWrap: true,
        padding: EdgeInsets.all(10.0),
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: MaterialButton(
              elevation: 0.0,
              color: colorConcealedCell,
              disabledColor: colorConcealedCell,
              onPressed: () {
                _initGame(index);
              },
            ),
          );
        }
    );
  }

  void _initGame(index) {
    _initGrid();
    Coordinate safeCoordinate = _getCoordinate(index);
    grid.generateGrid(safeCoordinate);
    if (grid.isInitialized) {
      Cell safeCell = _getCell(index);
      _revealCell(safeCell);
    }
  }

  Widget _gameGrid() {
    return GridView.builder(
      key: Key("GameGrid"),
      itemCount: grid.cellCount,
      itemBuilder: (context, index) {
        Cell cell = _getCell(index);
        return GridCell(
          cell: cell,
          toggleBomb: _toggleBomb,
          revealBombs: _revealBombs,
          revealNeighbors: _revealNeighbors,
          isClean: grid.isClean,
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: grid.width),
      shrinkWrap: true,
      padding: EdgeInsets.all(10.0),
      physics: ClampingScrollPhysics(),
    );
  }


  void _revealBombs({bool won = false}) {
    int index = 0;
    Timer.periodic(Duration(microseconds: 2000), (Timer t) {
      if (index < (grid.width*grid.height)) {
        Cell cell = _getCell(index);
        if (cell.isBomb && !cell.isRevealed) {
          setState(() {
            cell.isRevealed = true;
          });
        }
        index++;
      } else {
        if (won) {
          showGameOverPopup(context, GameWonDialog(newGame: _newGame), "Congrats");
        } else {
          showGameOverPopup(context, GameOverDialog(newGame: _newGame), "Uh Oh!");
        }
        t.cancel();
      }
    });
  }

  void _toggleBomb(Cell cell) {
    setState(() {
      cell.toggleMarkAsBomb();
      grid.updateGameStatus(cell);
      bombsRemaining += (cell.isMarkedAsBomb ? -1 : 1);
    });
    if (grid.isClean) {
      _revealBombs(won: true);
    }
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

  Cell _getCell(int index) {
    Coordinate coordinate = _getCoordinate(index);
    return grid.cell(coordinate);
  }

  Coordinate _getCoordinate(int index) {
    int x = index % grid.width;
    int y = index ~/ grid.width;
    return Coordinate(x, y);
  }
}
