import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minesweepr/assets/bomb_icon.dart';
import 'package:minesweepr/data/Cell.dart';
import 'package:minesweepr/ui/colors.dart';
import 'package:vibration/vibration.dart';

class GridCell extends StatefulWidget {
  final Cell cell;
  final Function toggleBomb;
  final Function revealBombs;
  final Function revealNeighbors;
  final Function checkGameStatus;

  const GridCell({
    Key key,
    @required this.cell,
    @required this.toggleBomb,
    @required this.revealBombs,
    @required this.revealNeighbors,
    @required this.checkGameStatus
  }) : super(key: key);

  @override
  _GridCellState createState() => _GridCellState();
}

class _GridCellState extends State<GridCell> {
  Timer _toggleTimer;


  @override
  void dispose() {
    if (_toggleTimer != null) {
      _toggleTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Cell cell = widget.cell;

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Material(
              elevation: 0.0,
              color: cell.backgroundColor,
              child: Center(
                  child: cell.isBomb ?
                  Icon(
                      BombIcon.bomb,
                      color: cell.textColor
                  )
                      :
                  Text(
                    cell.toString(),
                    style: TextStyle(
                        fontSize: 18.0,
                        color: cell.textColor
                    ),
                  )
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: cell.isRevealed ? 0.0 : 1.0,
                curve: Curves.easeInOutBack,
                child: GestureDetector(
//                  onLongPress: !cell.isRevealed
//                      ? () => _toggleBomb(cell)
//                      : () => {},
                  onTapDown: (_) => _startTimer(cell),
                  onTapUp: (_) => _toggleTimer.cancel(),
                  onDoubleTap: !cell.isRevealed
                      ? () => _toggleBomb(cell)
                      : () => {},
                  child: MaterialButton(
                    elevation: 0.0,
                    color: colorConcealedCell,
                    disabledColor: colorConcealedCell,
                    onPressed: (!cell.isRevealed && !cell.isMarkedAsBomb)
                        ? () => _revealCell(cell)
                        : null,
                  ),
                )
            ),
          ),
          Positioned.fill(
            child: cell.isMarkedAsBomb ? Center(
              child: GestureDetector(
                onDoubleTap: () => _toggleBomb(cell),
                onLongPressStart: (_) => _toggleBomb(cell),
                child: Icon(
                  BombIcon.bomb,
                  semanticLabel: 'bomb',
                ),
              ),
            ) : Container(),
          )
        ],
      ),
    );
  }

  void _startTimer(Cell cell) {
    if (_toggleTimer != null) {
      _toggleTimer.cancel();
    }

    _toggleTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (timer.tick == 2) {
        setState(() {
          _toggleBomb(cell);
        });
        timer.cancel();
      }
    });
  }

  void _revealCell(Cell cell) {
    if (_toggleTimer == null || !_toggleTimer.isActive) {
      setState(() {
        cell.isRevealed = true;
      });

      if (cell.isBomb) {
        widget.revealBombs();
      } else if (cell.hasNoNeighboringBombs) {
        widget.revealNeighbors(cell);
      }
    }
  }

  void _toggleBomb(Cell cell) {
    widget.toggleBomb(cell);
    _vibrate();
  }

  void _vibrate() async {
    bool hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator) {
      Vibration.vibrate(duration: 50, amplitude: 50);
    }
  }

}
