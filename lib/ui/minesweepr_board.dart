import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minesweepr/data/Difficulty.dart';
import 'package:minesweepr/data/Grid.dart';
import 'package:minesweepr/data/selected_difficulty_repository.dart';
import 'package:minesweepr/ui/colors.dart';
import 'package:minesweepr/ui/game_bar.dart';
import 'package:minesweepr/ui/game_grid.dart';
import 'package:minesweepr/ui/game_over_dialog.dart';
import 'package:minesweepr/ui/game_over_popup.dart';
import 'package:minesweepr/ui/game_won_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MinesweeprBoard extends StatefulWidget {
  @override
  _MinesweeprBoardState createState() => _MinesweeprBoardState();
}

class _MinesweeprBoardState extends State<MinesweeprBoard> with SingleTickerProviderStateMixin {
  SelectedDifficultyRepository selectedDifficultyRepo;
  DifficultyDB selectedDifficulty;
  Grid grid;

  final GlobalKey<GameBarState> _gameBarState = GlobalKey<GameBarState>();
  final GlobalKey<GameGridState> _gameGridState = GlobalKey<GameGridState>();

  @override
  void initState() {
    super.initState();

    selectedDifficultyRepo = SelectedDifficultyRepository.instance;
    _getSelectedDifficulty().then((difficulty) {
      if (difficulty == null) {
        selectedDifficultyRepo.setSelectedDifficulty(DifficultyDB.easy());
      } else {
        setState(() {
          selectedDifficulty = difficulty;
        });
        _initGrid();
      }
    });
  }

  _getSelectedDifficulty() async {
    DifficultyDB difficulty = await selectedDifficultyRepo.getSelectedDifficulty();
    print('Read difficulty: ${difficulty.name}');
    return difficulty;
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
    if (selectedDifficulty != null) {
      print("Selected difficulty:");
      print("Name: ${selectedDifficulty.name}");
      print("Width: ${selectedDifficulty.width}");
      print("Height: ${selectedDifficulty.height}");
      print("Bomb count: ${selectedDifficulty.bombCount}");
    } else {
      print("selectedDifficulty is null");
    }
    if (grid == null) print ("grid is null");
    else print("Grid bomb count: ${grid.bombCount}");

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
    ) : Container(child: Text("Loading"));
  }

  void _initGame() {
    _gameBarState.currentState.startTimer();
  }

  void _finishGame({bool won = false}) {
    if (won) {
//      int time = _gameBarState.currentState.gameTimer.tick;
//      _saveBestTime(time);
      showGameOverPopup(context, GameWonDialog(newGame: _newGame), "Congrats");
    } else {
      showGameOverPopup(context, GameOverDialog(newGame: _newGame), "Uh Oh!");
    }
  }

//  _saveBestTime(int completionTime) async {
//    final prefs = await SharedPreferences.getInstance();
//    final currentBest = prefs.getInt(selectedDifficulty.bestTimeKey) ?? 0;
//    if (completionTime > currentBest) {
//      print("NEW BEST TIME! $completionTime in $selectedDifficulty");
//      prefs.setInt("best_time_medium", completionTime);
//    } else {
//      print("The completion time $completionTime did not beat $currentBest for $selectedDifficulty");
//    }
//  }

  void _updateBombsRemaining(int delta) {
    _gameBarState.currentState.updateBombsRemaining(delta);
  }

  void _difficultyUpdated() {
    _getSelectedDifficulty().then((difficulty) {
      print("Getting updated difficulty: $difficulty");
      setState(() {
        selectedDifficulty = difficulty;
      });
      _initGrid();
    });
    _newGame();
  }

  void _newGame() {
    _gameGridState.currentState.newGame();
    _gameBarState.currentState.newGame();
  }

}
