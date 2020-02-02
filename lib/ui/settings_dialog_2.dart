import 'package:flutter/material.dart';
import 'package:minesweepr/data/Difficulty.dart';

class MyDialog extends StatefulWidget {
  final Difficulty currentDifficulty;
  final Function updateDifficulty;

  const MyDialog({Key key, this.currentDifficulty, this.updateDifficulty}) : super(key: key);

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  Difficulty _difficultyController;

  @override
  Widget build(BuildContext context) {
    if (_difficultyController == null) {
      _difficultyController = widget.currentDifficulty;
    }

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Settings",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold
            ),
          ),
          DropdownButtonFormField<Difficulty>(
            value: _difficultyController,
            items: [easyDifficulty, mediumDifficulty, hardDifficulty]
                .map((difficulty) => DropdownMenuItem(
              child: Text(difficulty.label),
              value: difficulty,
            ))
                .toList(),
            hint: Text('Difficulty'),
            onChanged: (value) {
              setState(() {
                _difficultyController = value;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            widget.updateDifficulty(_difficultyController);
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        )
      ],
    );
  }
}