import 'package:flutter/material.dart';
import 'package:minesweepr/data/data_repository.dart';
import 'package:minesweepr/data/models/difficulty.dart';

class SettingsDialog extends StatefulWidget {
  final Difficulty currentDifficulty;
  final Function difficultyUpdated;

  const SettingsDialog({Key key, this.currentDifficulty, this.difficultyUpdated}) : super(key: key);

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
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
            items: difficulties.map((difficulty) => DropdownMenuItem(
              child: Text(difficulty.name),
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
            print("Checking if difficulty was changed from ${widget.currentDifficulty} to $_difficultyController");
            if (_difficultyController != widget.currentDifficulty) {
              _save().then((_) => widget.difficultyUpdated());
            }
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

  _save() async {
    DataRepository helper = DataRepository.instance;
    await helper.setSelectedDifficulty(_difficultyController);
  }
}