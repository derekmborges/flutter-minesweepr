import 'package:flutter/material.dart';

const colorPrimary = const Color(0xFF008535);
const colorPrimaryDark = const Color(0xFF00574B);

const colorAccent = const Color(0xFFD81B60);
const colorConcealedCell = const Color(0xFF878787);

const colorMineCellBackground = const Color(0xFFA20000);
const colorMineCell = const Color(0xFFFFFFFF);

const colorRevealedCellBackground = const Color(0xFFcccccc);

const colorOneNeighbor = const Color(0xFF00B800);
const colorTwoNeighbor = const Color(0xFFfff700);
const colorThreeNeighbor = const Color(0xFFFF7110);
const colorFourNeighbor = const Color(0xFFFF3300);
const colorFiveNeighbor = const Color(0xFFFF0000);
const colorSixNeighbor = const Color(0xFFA20000);
const colorSevenNeighbor = Colors.black;
const colorEightNeighbor = Colors.black;


const Map<int, Color> color = {
  50: Color(0xFFFAFAFA),
  100: Color(0xFFF5F5F5),
  200: Color(0xFFEEEEEE),
  300: Color(0xFFE0E0E0),
  350: Color(0xFFD6D6D6), // only for raised button while pressed in light theme
  400: Color(0xFFBDBDBD),
  500: Color(0xFF9E9E9E),
  600: Color(0xFF757575),
  700: Color(0xFF616161),
  800: Color(0xFF424242),
  850: Color(0xFF303030), // only for background color in dark theme
  900: Color(0xFF212121),
};

const MaterialColor appBarColor = const MaterialColor(0xFF9E9E9E, color);