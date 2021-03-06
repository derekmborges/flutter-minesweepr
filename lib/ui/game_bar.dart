import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minesweepr/assets/bomb_icon.dart';
import 'package:minesweepr/data/models/difficulty.dart';
import 'package:minesweepr/ui/colors.dart';
import 'package:minesweepr/ui/settings_dialog.dart';
import 'package:minesweepr/ui/styles.dart';

class GameBar extends StatefulWidget {
  final int bombsRemaining;
  final Difficulty selectedDifficulty;
  final Function difficultyUpdated;
  final Function newGame;

  const GameBar({
    Key key,
    @required this.bombsRemaining,
    @required this.selectedDifficulty,
    @required this.difficultyUpdated,
    @required this.newGame
  }) : super(key: key);

  @override
  GameBarState createState() => GameBarState();
}

class GameBarState extends State<GameBar> with SingleTickerProviderStateMixin {
  int bombsRemaining;
  int gameTimerLabel;
  Timer gameTimer;

  @override
  void initState() {
    super.initState();
    gameTimerLabel = 0;
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            color: appBarColor
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(BombIcon.bomb),
                SizedBox(width: 5),
                Text(
                    widget.bombsRemaining.toString(),
                  style: appBarTextStyle
                ),
                SizedBox(width: 15),
                Icon(Icons.timer),
                SizedBox(width: 5),
                Text(
                  gameTimerLabel.toString(),
                  style: appBarTextStyle,
                )
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    semanticLabel: 'newgame',
                  ),
                  onPressed: () {
                    setState(() {
                      widget.newGame();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    semanticLabel: 'settings',
                  ),
                  onPressed: () {
                    _openSettingsDialog();
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    semanticLabel: 'info',
                  ),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _openSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SettingsDialog(
          currentDifficulty: widget.selectedDifficulty,
          difficultyUpdated: widget.difficultyUpdated,
        );
    });
  }

  void startTimer() {
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        gameTimerLabel = timer.tick;
      });
    });
  }

  void cancelTimer() {
    if (gameTimer != null && gameTimer.isActive) gameTimer.cancel();
  }

  void newGame() {
    setState(() {
      bombsRemaining = widget.bombsRemaining;
      gameTimerLabel = 0;
      if (gameTimer != null && gameTimer.isActive) gameTimer.cancel();
    });
  }
}
