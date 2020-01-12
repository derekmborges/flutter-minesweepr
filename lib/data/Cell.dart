import 'dart:ui';
import 'package:minesweepr/colors.dart';

import 'Constants.dart';

class Cell {
  int value = 0;
  bool isRevealed = false;
  bool isMarkedAsBomb = false;

  final int locationX;
  final int locationY;

  Cell(this.locationX, this.locationY);

  Color get textColor {
    Color color;
    switch (value) {
      case BOMB:
        color = colorMineCell;
        break;
      case 1:
        color = colorOneNeighbor;
        break;
      case 2:
        color = colorTwoNeighbor;
        break;
      case 3:
        color = colorThreeNeighbor;
        break;
      case 4:
        color = colorFourNeighbor;
        break;
      case 5:
        color = colorFiveNeighbor;
        break;
      case 6:
        color = colorSixNeighbor;
        break;
      case 7:
        color = colorSevenNeighbor;
        break;
      case 8:
        color = colorEightNeighbor;
        break;
      default:
        color = colorConcealedCell;
        break;
    }
    return color;
  }

  Color get backgroundColor =>
      isBomb ? colorMineCellBackground : colorRevealedCellBackground;

  bool get isBomb => value == BOMB;

  bool get hasNoNeighboringBombs => value == 0;

  void setBomb() {
    value = BOMB;
  }

  void unMarkBomb() {
    isMarkedAsBomb = false;
  }

  void markAsBomb() {
    isMarkedAsBomb = true;
  }

  @override
  String toString() {
    String string;
    switch(value) {
      case BOMB:
        string = "X";
        break;
      case 0:
        string = "";
        break;
      default:
        string = value.toString();
        break;
    }
    return string;
  }

}