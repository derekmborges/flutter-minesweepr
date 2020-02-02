import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minesweepr/ui/colors.dart';
import 'package:minesweepr/ui/minesweepr_board.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minesweepr',
      theme: ThemeData(
        primarySwatch: appBarColor,
      ),
      home: MinesweeprBoard(),
    );
  }
}