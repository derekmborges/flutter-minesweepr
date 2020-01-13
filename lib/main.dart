import 'package:flutter/material.dart';
import 'package:minesweepr/colors.dart';
import 'package:minesweepr/data/Cell.dart';
import 'package:minesweepr/data/Coordinate.dart';
import 'package:minesweepr/data/Grid.dart';
import 'package:minesweepr/assets/bomb_icon.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minesweepr',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Minesweepr(),
    );
  }
}

class Minesweepr extends StatefulWidget {
  @override
  _MinesweeprState createState() => _MinesweeprState();
}

class _MinesweeprState extends State<Minesweepr> {
  Grid grid;
  int bombsRemaining;

  @override
  void initState() {
    super.initState();
    grid = Grid(
      width: 8,
      height: 16,
      bombCount: 20
    );
    Coordinate safeCoordinate = Coordinate(0, 0);
    grid.generateGrid(safeCoordinate);
    bombsRemaining = grid.bombCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bombs left: $bombsRemaining'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.info_outline,
              semanticLabel: 'info',
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: grid.width,
          children: _buildGrid(grid),
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }

  List<Widget> _buildGrid(Grid grid) {
    List<Widget> buttons = List.generate(
      grid.width * grid.height,
      (int index) => Padding(
        padding: const EdgeInsets.all(1.0),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Material(
                elevation: 0.0,
                color: colorRevealedCellBackground,
                child: Center(child: Text('${_getCell(index).value}')),
              ),
            ),
            Positioned.fill(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: _getCell(index).isRevealed ? 0.0 : 1.0,
                curve: Curves.easeOut,
                child: GestureDetector(
                  onLongPress: !_getCell(index).isRevealed
                      ? () => _toggleBomb(index)
                      : () => {},
                  onDoubleTap: !_getCell(index).isRevealed
                      ? () => _toggleBomb(index)
                      : () => {},
                  child: MaterialButton(
                    elevation: 0.0,
                    color: colorConcealedCell,
                    disabledColor: colorConcealedCell,
                    onPressed: (!_getCell(index).isRevealed && !_getCell(index).isMarkedAsBomb)
                        ? () => _revealCell(index)
                        : null,
                  ),
                )
              ),
            ),
            Positioned.fill(
              child: _getCell(index).isMarkedAsBomb ? Center(
                child: GestureDetector(
                  onDoubleTap: () => _toggleBomb(index),
                  onLongPress: () => _toggleBomb(index),
                  child: Icon(
                    BombIcon.bomb,
                    semanticLabel: 'bomb',
                    size: 36.0,
                  ),
                ),
              ) : Container(),
            )
          ],
        ),
      )
    );
    return buttons;
  }

  void _revealCell(int index) {
    Cell cell = _getCell(index);
    setState(() {
      cell.isRevealed = true;
    });
  }

  void _toggleBomb(int index) {
    Cell cell = _getCell(index);
    setState(() {
      cell.toggleMarkAsBomb();
      bombsRemaining += (cell.isMarkedAsBomb ? -1 : 1);
    });
  }

  Cell _getCell(int index) {
    Coordinate coordinate = _getCoordinate(index);
    return grid.cell(coordinate);
  }

  Coordinate _getCoordinate(int index) {
    int x = index % grid.width;
    int y = index ~/ grid.width;
    return Coordinate(x, y);
  }
}


