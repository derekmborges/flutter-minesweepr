import 'package:flutter/material.dart';
import 'package:minesweepr/colors.dart';
import 'package:minesweepr/data/Cell.dart';
import 'package:minesweepr/data/Coordinate.dart';
import 'package:minesweepr/data/Difficulty.dart';
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
  Difficulty selectedDifficulty;
  Grid grid;
  int bombsRemaining;

  @override
  void initState() {
    super.initState();
    selectedDifficulty = mediumDifficulty;
    grid = Grid(
        width: selectedDifficulty.width,
        height: selectedDifficulty.height,
        bombCount: selectedDifficulty.bombCount
    );
    bombsRemaining = selectedDifficulty.bombCount;
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
            child: grid.isInitialized ? _gameGrid() : _nullGrid(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                child: Text('NEW GAME'),
                onPressed: () {
                  setState(() {
                    newGame();
                  });
                },
              ),
              MaterialButton(
                child: Text(selectedDifficulty.label.toUpperCase()),
                onPressed: () {
                  // TODO: Open dialog to change difficulty
                },
              )
            ],
          )
        ],
      ),
    );
  }

  void newGame() {
    grid.reset();
    bombsRemaining = selectedDifficulty.bombCount;
  }

  Widget _nullGrid() {
    return GridView.builder(
      key: Key("NullGrid"),
      itemCount: selectedDifficulty.width * selectedDifficulty.height,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: selectedDifficulty.width),
      shrinkWrap: true,
      padding: EdgeInsets.all(10.0),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: MaterialButton(
            elevation: 0.0,
            color: colorConcealedCell,
            disabledColor: colorConcealedCell,
            onPressed: () {
              initGame(index);
            },
          ),
        );
      }
    );
  }

  void initGame(index) {
    Coordinate safeCoordinate = _getCoordinate(index);
    grid.generateGrid(safeCoordinate);
    if (grid.isInitialized) {
      Cell safeCell = _getCell(index);
      _revealCell(safeCell);
    }
  }

  Widget _gameGrid() {
    return GridView.builder(
      key: Key("GameGrid"),
      itemCount: grid.width * grid.height,
      itemBuilder: (context, index) {
        Cell cell = _getCell(index);
        return _buildCell(cell);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: grid.width),
      shrinkWrap: true,
      padding: EdgeInsets.all(10.0),
      physics: NeverScrollableScrollPhysics(),
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
      if (cell.hasNoNeighboringBombs) {
        _revealNeighbors(cell);
      }
    });
  }

  void _revealNeighbors(Cell cell) {
    List<Cell> neighbors = grid.getNeighbors(cell.locationX, cell.locationY);
    neighbors.retainWhere((Cell neighbor) => !neighbor.isRevealed);
    neighbors.forEach((Cell neighbor) => _revealCell(neighbor));
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


