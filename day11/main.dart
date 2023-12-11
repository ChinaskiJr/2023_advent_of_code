import 'dart:io';

class Coordinate implements Comparable {
  int x = 0;
  int y = 0;

  Coordinate(this.x, this.y);

  @override
  String toString() {
    return [x, y].toString();
  }

  @override
  int compareTo(other) {
    if (this.x == other.x && this.y == other.y) {
      return 0;
    }
    if (this.y > other.y) {
      return 1;
    } else if (this.y < other.y) {
      return -1;
    } else
    if (this.x > other.x) {
      return 1;
    }
    return -1;
  }

  int getDistanceWith(Coordinate coordinate) {
    return (this.x - coordinate.x).abs() + (this.y - coordinate.y).abs();
  }

  int getDistanceWithExpandedLines(Coordinate coordinate, List<List<int>> expandedLines, int expansion) {
    int expandedThisXCoordinate = this.x;
    for (final expandedRow in expandedLines[1]) {
      if (expandedRow < this.x) {
        expandedThisXCoordinate += expansion ;
      }
    }
    int expandedThisYCoordinate = this.y;
    for (final expandedLine in expandedLines[0]) {
      if (expandedLine < this.y) {
        expandedThisYCoordinate += expansion;
      }
    }
    int expandedXCoordinate = coordinate.x;
    for (final expandedRow in expandedLines[1]) {
      if (expandedRow < coordinate.x) {
        expandedXCoordinate += expansion;
      }
    }
    int expandedYCoordinate = coordinate.y;
    for (final expandedLine in expandedLines[0]) {
      if (expandedLine < coordinate.y) {
        expandedYCoordinate += expansion;
      }
    }

    return (expandedThisXCoordinate - expandedXCoordinate).abs() + (expandedThisYCoordinate - expandedYCoordinate).abs();
  }
}

void main() {
  final File file = File('./input.txt');
  file.readAsLines().then((List<String> lines) {
    partOne(lines);
    partTwo(lines);
  });
}

void partOne(List<String> universe) {
  List<List<int>> expandedLines = processExpandedUniverse(universe);
  final galaxiesCoordinates = getGalaxiesCoordinates(universe);
  // https://betterexplained.com/articles/techniques-for-adding-the-numbers-1-to-100/
  int nbPairs = (galaxiesCoordinates.length * (galaxiesCoordinates.length - 1)) ~/ 2;
  final pairs = getUniquePairs(galaxiesCoordinates);
  if (nbPairs != pairs.length) {
    throw new Exception('Invalid pair number');
  }
  int sum = 0;
  for(final pair in pairs) {
    sum += pair[0].getDistanceWithExpandedLines(pair[1], expandedLines, 1);
  }

  print('Part One: $sum');
}

void partTwo(List<String> universe) {
  List<List<int>> expandedLines = processExpandedUniverse(universe);
  final galaxiesCoordinates = getGalaxiesCoordinates(universe);
  // https://betterexplained.com/articles/techniques-for-adding-the-numbers-1-to-100/
  int nbPairs = (galaxiesCoordinates.length * (galaxiesCoordinates.length - 1)) ~/ 2;
  final pairs = getUniquePairs(galaxiesCoordinates);
  if (nbPairs != pairs.length) {
    throw new Exception('Invalid pair number');
  }
  int sum = 0;
  for(final pair in pairs) {
    sum += pair[0].getDistanceWithExpandedLines(pair[1], expandedLines, 1000000 - 1);
  }

  print('Part Two: $sum');
}

List<List<int>> processExpandedUniverse(List<String> lines) {
  List<int> linesToDuplicate = [];
  for (final (index, line) in lines.indexed) {
    bool hasGalaxy = false;
    line.runes.forEach((rune) {
      if (String.fromCharCode(rune) == '#') {
        hasGalaxy = true;
      }
    });
    if (!hasGalaxy) {
      linesToDuplicate.add(index);
    }
  }

  List<int> columnsToDuplicate = [];
  for (int x = 0 ; x < lines[0].length ; x++) {
    bool hasGalaxy = false;
    for (int y = 0 ; y < lines.length ; y++) {
      if (lines[y][x] == '#') {
        hasGalaxy = true;
      }
    }
    if (!hasGalaxy) {
      columnsToDuplicate.add(x);
    }
  }

  return [linesToDuplicate, columnsToDuplicate];
}

List<Coordinate> getGalaxiesCoordinates(List<String> universe) {
  List<Coordinate> galaxiesCoordinates = [];
  for (int y = 0 ; y < universe.length ; y++) {
    for (int x = 0 ; x < universe[y].length ; x++) {
      if (universe[y][x] == '#') {
        galaxiesCoordinates.add(Coordinate(x, y));
      }
    }
  }

  return galaxiesCoordinates;
}

List<List<Coordinate>> getUniquePairs(List<Coordinate> coordinates) {
  Map <String, List<Coordinate>> uniquePairs = {};

  for (int index = 0 ; index < coordinates.length ; index++) {
    for (int indexToCheck = 0 ; indexToCheck < coordinates.length ; indexToCheck++) {
      if (indexToCheck == index) {
        continue;
      }
      List<Coordinate> pair = [coordinates[index], coordinates[indexToCheck]];
      pair.sort();
      uniquePairs[pair.toString()] = pair;
    }
  }

  return uniquePairs.values.toList();
}