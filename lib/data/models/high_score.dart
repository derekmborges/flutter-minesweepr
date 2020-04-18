final String tableHighScore = 'highScore';
final highScoreId = '_id';
final highScoreDifficultyName = 'difficultyName';
final highScoreBestTime = 'bestTime';

class HighScore {
  int id;
  String difficultyName;
  int bestTime;

  HighScore(this.difficultyName, this.bestTime);

  HighScore.fromMap(Map<String, dynamic> map) {
    id = map[highScoreId];
    difficultyName = map[highScoreDifficultyName];
    bestTime = map[highScoreBestTime];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      highScoreDifficultyName: difficultyName,
      highScoreBestTime: bestTime
    };
    if (id != null) {
      map[highScoreId] = id;
    }
    return map;
  }

  @override
  String toString() => "$difficultyName - $bestTime seconds";
}