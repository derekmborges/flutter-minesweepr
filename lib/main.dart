import 'package:flutter/material.dart';
import 'package:minesweepr/colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
  int bombsRemaining = 30;
  List<bool> cellsRevealed = List.generate(32, (_) => false);
  List<bool> cellsMarked = List.generate(32, (_) => false);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

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
          crossAxisCount: 4,
          children: _buildGrid(cellsRevealed.length),
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }

  List<Widget> _buildGrid(int count) {
    List<Widget> buttons = List.generate(
      count,
      (int index) => Padding(
        padding: const EdgeInsets.all(1.0),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Material(
                elevation: 0.0,
                color: colorRevealedCellBackground,
                child: Center(child: Text('$index')),
              ),
            ),
            Positioned.fill(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: isCellRevealed(index) ? 0.0 : 1.0,
                curve: Curves.easeOut,
                child: GestureDetector(
                  onLongPress: !isCellRevealed(index)
                      ? () => _toggleBomb(index)
                      : () => {},
                  onDoubleTap: !isCellRevealed(index)
                      ? () => _toggleBomb(index)
                      : () => {},
                  child: MaterialButton(
                    elevation: 0.0,
                    color: colorConcealedCell,
                    disabledColor: colorConcealedCell,
                    onPressed: (!isCellRevealed(index) && !isCellMarked(index))
                        ? () => _revealCell(index)
                        : null,
                  ),
                )
              ),
            ),
            Positioned.fill(
              child: isCellMarked(index) ? Center(
                child: GestureDetector(
                  onDoubleTap: () => _toggleBomb(index),
                  onLongPress: () => _toggleBomb(index),
                  child: Icon(
                    Icons.bug_report,
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

  bool isCellRevealed(int index) => cellsRevealed[index];
  bool isCellMarked(int index) => cellsMarked[index];

  void _revealCell(int index) {
    setState(() {
      cellsRevealed[index] = !cellsRevealed[index];
    });
  }

  void _toggleBomb(int index) {
    setState(() {
      cellsMarked[index] = !cellsMarked[index];
      bombsRemaining += (cellsMarked[index] ? -1 : 1);
    });
  }
}


