import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minesweepr/data/Difficulty.dart';
import 'package:minesweepr/data/Grid.dart';
import 'package:minesweepr/ui/colors.dart';
import 'package:minesweepr/ui/game_bar.dart';
import 'package:minesweepr/ui/game_grid.dart';
import 'package:minesweepr/ui/game_over_dialog.dart';
import 'package:minesweepr/ui/game_over_popup.dart';
import 'package:minesweepr/ui/game_won_dialog.dart';

class MinesweeprBoard extends StatefulWidget {
  @override
  _MinesweeprBoardState createState() => _MinesweeprBoardState();
}

class _MinesweeprBoardState extends State<MinesweeprBoard> with SingleTickerProviderStateMixin {
  Difficulty selectedDifficulty;
  Grid grid;

  final GlobalKey<GameBarState> _gameBarState = GlobalKey<GameBarState>();

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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
            color: appBarColor
          ),
        ),
        GameBar(
          key: _gameBarState,
          selectedDifficulty: selectedDifficulty,
          difficultyUpdated: _difficultyUpdated,
          newGame: _newGame,
        ),
        GameGrid(
          grid: grid,
          updateBombsRemaining: _updateBombsRemaining,
          initGame: _initGame,
          finishGame: _finishGame,
        ),
      ],
    );
  }

  void _initGame() {
    _gameBarState.currentState.startTimer();
  }

  void _finishGame({bool won = false}) {
    if (won) {
      showGameOverPopup(context, GameWonDialog(newGame: _newGame), "Congrats");
    } else {
      showGameOverPopup(context, GameOverDialog(newGame: _newGame), "Uh Oh!");
    }
  }

  void _updateBombsRemaining(int delta) {
    _gameBarState.currentState.updateBombsRemaining(delta);
  }

  void _difficultyUpdated(Difficulty newDifficulty) {
    setState(() {
      print("new difficulty: ${newDifficulty.label}");
      selectedDifficulty = newDifficulty;
      _initGrid();
    });
  }

  void _newGame() {
    setState(() {
      grid.reset();
    });
    _gameBarState.currentState.newGame();
  }

}
