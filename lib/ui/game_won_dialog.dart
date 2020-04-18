import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:minesweepr/data/data_repository.dart';
import 'package:minesweepr/data/models/difficulty.dart';
import 'package:minesweepr/data/models/high_score.dart';
import 'package:minesweepr/ui/colors.dart';

class GameWonDialog extends StatelessWidget {
  final Function newGame;
  final int completionTime;
  final bool newBestTime;

  const GameWonDialog({
    Key key,
    @required this.newGame,
    @required this.completionTime,
    @required this.newBestTime
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                newBestTime ? "NEW BEST TIME!" : "Go faster!",
                style: TextStyle(
                    color: colorPrimaryDark,
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.timer, size: 24.0),
                    Text(
                      "$completionTime s",
                      style: TextStyle(
                          color: colorPrimaryDark,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w300
                      ),
                    ),
                  ]
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.star, size: 24.0),
                    FutureBuilder<dynamic>(
                      future: _getBestTime(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        return Text(
                          "${snapshot.data} s",
                          style: TextStyle(
                              color: colorPrimaryDark,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w300
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 60,
                color: colorOneNeighbor,
                child: Text("NEW GAME", style: TextStyle(fontSize: 18.0)),
                onPressed: () {
                  newGame();
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        )
    );
  }

  _getBestTime() async {
    DataRepository dataRepo = DataRepository.instance;

    Difficulty difficulty = await dataRepo.getSelectedDifficulty();
    HighScore highScore = await dataRepo.getHighScore(difficulty.name);
    print("GameWonDialog retrieved bestTime: ${highScore.bestTime}");
    return highScore.bestTime;
  }
}
