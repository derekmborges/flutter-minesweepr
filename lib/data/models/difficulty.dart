final String tableSelectedDifficulty = 'selectedDifficulty';
final String difficultyId = '_id';
final String difficultyName = 'name';
final String difficultyWidth = 'width';
final String difficultyHeight = 'height';
final String difficultyBombCount = 'bombCount';

class Difficulty {
  int id;
  String name;
  int width;
  int height;
  int bombCount;

  @override
  bool operator ==(other) => other is Difficulty && other.name == name;

  @override
  String toString() => name;

  Difficulty();

  Difficulty.easy() {
    name = "Easy";
    width = 6;
    height = 12;
    bombCount = 10;
  }

  Difficulty.medium() {
    name = "Medium";
    width = 8;
    height = 16;
    bombCount = 20;
  }

  Difficulty.hard() {
    name = "Hard";
    width = 10;
    height = 20;
    bombCount = 40;
  }

  Difficulty.fromMap(Map<String, dynamic> map) {
    id = map[difficultyId];
    name = map[difficultyName];
    width = map[difficultyWidth];
    height = map[difficultyHeight];
    bombCount = map[difficultyBombCount];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      difficultyName: name,
      difficultyWidth: width,
      difficultyHeight: height,
      difficultyBombCount: bombCount
    };
    if (id != null) {
      map[difficultyId] = id;
    }
    return map;
  }
}

List<Difficulty> difficulties = <Difficulty>[
  Difficulty.easy(),
  Difficulty.medium(),
  Difficulty.hard()
];