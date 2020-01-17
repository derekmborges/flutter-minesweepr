class Difficulty {
  final int width;
  final int height;
  final int bombCount;
  final String label;

  Difficulty(this.width, this.height, this.bombCount, this.label);
}

Difficulty easyDifficulty = Difficulty(6, 12, 10, "Easy");
Difficulty mediumDifficulty = Difficulty(8, 16, 20, "Medium");
Difficulty hardDifficulty = Difficulty(10, 22, 40, "Hard");