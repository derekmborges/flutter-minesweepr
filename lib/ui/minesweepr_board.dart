import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minesweepr/data/Grid.dart';
import 'package:minesweepr/data/data_repository.dart';
import 'package:minesweepr/data/models/difficulty.dart';
import 'package:minesweepr/data/models/high_score.dart';
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
  DataRepository dataRepo;
  Difficulty selectedDifficulty;
  int bombsRemaining;
  HighScore highScore;
  Grid grid;

  final GlobalKey<GameBarState> _gameBarState = GlobalKey<GameBarState>();
  final GlobalKey<GameGridState> _gameGridState = GlobalKey<GameGridState>();

  @override
  void initState() {
    super.initState();
    dataRepo = DataRepository.instance;

    _getSelectedDifficulty().then((difficulty) {
      if (difficulty == null) {
        difficulty = Difficulty.easy();
        dataRepo.setSelectedDifficulty(difficulty);
      }

      setState(() {
        selectedDifficulty = difficulty;
        bombsRemaining = selectedDifficulty.bombCount;
      });

      _initGrid();

      _getHighScore().then((currentHighScore) {
        highScore = currentHighScore;
      });
    });
  }

  _getSelectedDifficulty() async {
    Difficulty difficulty = await dataRepo.getSelectedDifficulty();
    print('Read difficulty: $difficulty');
    return difficulty;
  }

  _getHighScore() async {
    HighScore highScore = await dataRepo.getHighScore(selectedDifficulty.name);
    print("Read highScore: $highScore");
    return highScore;
  }

  void _initGrid() {
    setState(() {
      grid = Grid(
          width: selectedDifficulty.width,
          height: selectedDifficulty.height,
          bombCount: selectedDifficulty.bombCount
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return grid != null ? Column(
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
          bombsRemaining: bombsRemaining,
          selectedDifficulty: selectedDifficulty,
          difficultyUpdated: _difficultyUpdated,
          newGame: _newGame,
        ),
        GameGrid(
          key: _gameGridState,
          grid: grid,
          updateBombsRemaining: _updateBombsRemaining,
          initGame: _initGame,
          finishGame: _finishGame,
        ),
      ],
    ) : Container(child: Text("Loading")); // TODO: Make loading screen
  }

  void _initGame() {
    _gameBarState.currentState.startTimer();
  }

  void _finishGame({bool won = false}) {
    if (won) {
      int time = _gameBarState.currentState.gameTimer.tick;
      print("GAME WON! Time: $time");
      _gameBarState.currentState.cancelTimer();
      _saveBestTime(time);
      showGameOverPopup(context, GameWonDialog(
          newGame: _newGame,
          completionTime: time,
          newBestTime: time == highScore.bestTime
      ), "You won!");
    } else {
      showGameOverPopup(context, GameOverDialog(newGame: _newGame), "Game over!");
    }
  }

  _saveBestTime(int completionTime) async {
    if (highScore == null || completionTime < highScore.bestTime) {
      print("NEW BEST TIME! $completionTime in $selectedDifficulty");
      dataRepo.setHighScore(selectedDifficulty.name, completionTime);
      _getHighScore().then((currentHighScore) {
        highScore = currentHighScore;
      });
    } else {
      print("The completion time $completionTime did not beat ${highScore.bestTime} for $selectedDifficulty");
    }
  }

  void _updateBombsRemaining(int delta) {
    setState(() {
      bombsRemaining += delta;
    });
  }

  void _difficultyUpdated() {
    _getSelectedDifficulty().then((difficulty) {
      print("Getting updated difficulty: $difficulty");
      setState(() {
        selectedDifficulty = difficulty;
        bombsRemaining = selectedDifficulty.bombCount;
      });
      _initGrid();
    });
    _newGame();
  }

  void _newGame() {
    setState(() {
      bombsRemaining = selectedDifficulty.bombCount;
    });
    _gameGridState.currentState.newGame();
    _gameBarState.currentState.newGame();
  }

}
