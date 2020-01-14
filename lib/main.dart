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
      width: 6,
      height: 12,
      bombCount: 10
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              itemCount: grid.width * grid.height,
              itemBuilder: (context, index) {
                Cell cell = _getCell(index);
                return _buildCell(cell);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: grid.width),
              shrinkWrap: true,
              padding: EdgeInsets.all(10.0),
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                child: Text('NEW GAME'),
                onPressed: () {},
              ),
              MaterialButton(
                child: Text('DIFFICULTY'),
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCell(Cell cell) =>
    Padding(
      padding: const EdgeInsets.all(1.0),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Material(
              elevation: 0.0,
              color: colorRevealedCellBackground,
              child: Center(
                child: cell.isBomb ?
                  Icon(
                    BombIcon.bomb,
                    color: colorMineCellBackground
                  )
                    :
                  Text(
                    '${cell.value}',
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
              curve: Curves.easeOut,
              child: GestureDetector(
                onLongPress: !cell.isRevealed
                    ? () => _toggleBomb(cell)
                    : () => {},
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
                onLongPress: () => _toggleBomb(cell),
                child: Icon(
                  BombIcon.bomb,
                  semanticLabel: 'bomb',
                  size: grid.height * 2.0,
                ),
              ),
            ) : Container(),
          )
        ],
      ),
    );

  void _revealCell(Cell cell) {
    setState(() {
      cell.isRevealed = true;
    });
  }

  void _toggleBomb(Cell cell) {
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


