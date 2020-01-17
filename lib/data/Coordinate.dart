class Coordinate {
  final int x;
  final int y;

  Coordinate(this.x, this.y);

  @override
  // ignore: hash_and_equals
  bool operator ==(other) => x == other.x && y == other.y;

  @override
  String toString() => 'Coordinate[$x, $y]';
}