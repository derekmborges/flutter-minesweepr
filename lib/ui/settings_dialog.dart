import 'package:flutter/material.dart';
import 'package:minesweepr/data/Difficulty.dart';
import 'package:minesweepr/ui/dropdown_formfield.dart';

class SettingsDialog extends StatelessWidget {
  final Difficulty selectedDifficulty;
  final Function difficultyUpdated;

  const SettingsDialog({Key key, this.selectedDifficulty, this.difficultyUpdated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Form(
          key: GlobalKey<FormState>(),
          child: Column(
            children: <Widget>[
              Text(
                "Settings",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: DropDownFormField(
                  titleText: 'Difficulty',
                  hintText: 'Select one',
                  value: selectedDifficulty,
                  onSaved: (value) {
                    difficultyUpdated(value);
                  },
                  onChanged: (value) {},
                  dataSource: [
                    {"display": easyDifficulty.label, "value": easyDifficulty},
                    {"display": mediumDifficulty.label, "value": mediumDifficulty},
                    {"display": hardDifficulty.label, "value": hardDifficulty}
                  ],
                  textField: 'display',
                  valueField: 'value',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

