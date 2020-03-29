import 'package:flutter/material.dart';
import 'package:minesweepr/ui/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameWonDialog extends StatelessWidget {
  final Function newGame;

  const GameWonDialog({Key key, this.newGame}) : super(key: key);

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
                "You Won!",
                style: TextStyle(
                    color: colorPrimaryDark,
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
//            Padding(
//              padding: const EdgeInsets.symmetric(vertical: 5.0),
//              child: _buildBestTime()
//            ),
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

  _buildBestTime() async {
    return Text(
      _getBestTime().toString(),
      style: TextStyle(
          color: colorPrimaryDark,
          fontSize: 24.0,
          fontWeight: FontWeight.w300
      ),
    );
  }

  _getBestTime() async {
    final prefs = await SharedPreferences.getInstance();
    final bestTime = prefs.getInt("") ?? 0;
    print("GameWonDialog read: $bestTime");
    return bestTime;
  }
}
