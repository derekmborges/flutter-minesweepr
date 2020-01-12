class Coordinate {
  final int x;
  final int y;

  Coordinate(this.x, this.y);

  @override
  bool operator ==(other) {
    Coordinate otherCoord = other as Coordinate;
    return otherCoord.x == x && otherCoord.y == y;
  }

  @override
  String toString() => 'Coordinate[$x, $y]';
}