import 'dart:io';
import 'dart:math';

class Coordinate {
    int x = 0;
    int y = 0;
    Direction? lastDirection;
    Direction? nextDirection;

    Coordinate(this.x, this.y);

    String getValue(List<List<String>> matrice) {
      return matrice[y][x];
    }

    @override
  String toString() {
    return [x, y].toString();
  }
}

enum Direction {
  north,
  south,
  west,
  east,
}

void main() {
  final File file = File('./input.txt');
  file.readAsLines().then((List<String> lines) {
    partOne(lines);
    partTwo(lines);
  });
}

Map<String, List<int>> generateDirectionMap() {
  return {
    '.': [0, 0],
    '|': [1, 0],
    '-': [0, 1],
  };
}

void partOne(List<String> lines) {
  final matrice = getMatrice(lines);
  final startPoint = findStartPoint(lines);
  startPoint.nextDirection = getFirstNextDirection(startPoint, matrice);
  final currentPoint = startPoint;
  int step = 0;
  do {
      switch(getNextDirection(currentPoint, matrice)) {
        case Direction.north:
          currentPoint.y--;
          currentPoint.nextDirection = Direction.north;
          currentPoint.lastDirection = currentPoint.nextDirection;
        case Direction.east:
          currentPoint.x++;
          currentPoint.nextDirection = Direction.east;
          currentPoint.lastDirection = currentPoint.nextDirection;
        case Direction.south:
          currentPoint.y++;
          currentPoint.nextDirection = Direction.south;
          currentPoint.lastDirection = currentPoint.nextDirection;
        case Direction.west:
          currentPoint.x--;
          currentPoint.nextDirection = Direction.west;
          currentPoint.lastDirection = currentPoint.nextDirection;
      }
      step++;
  } while (currentPoint.getValue(matrice) != 'S');
  print('Part One: ${step ~/ 2}');
}

void partTwo(List<String> lines) {
  final matrice = getMatrice(lines);
  final loopMap = getMatrice(lines);
  final emptyLeftPoints = getMatrice(lines);
  final emptyRightsPoints = getMatrice(lines);
  for (int x = 0 ; x < matrice.length; x++) {
    for (int y = 0 ; y < matrice[x].length ; y++) {
      loopMap[x][y] = ' ';
      emptyLeftPoints[x][y] = ' ';
      emptyRightsPoints[x][y] = ' ';
    }
  }


  final startPoint = findStartPoint(lines);
  startPoint.nextDirection = getFirstNextDirection(startPoint, matrice);
  final currentPoint = startPoint;

  do {
    loopMap[currentPoint.y][currentPoint.x] = 'X';
    switch(getNextDirection(currentPoint, matrice)) {
      case Direction.north:
        if (currentPoint.x != 0) {
          emptyLeftPoints[currentPoint.y][currentPoint.x - 1] = '1';
        }
        if (currentPoint.x != emptyRightsPoints[currentPoint.y].length - 1) {
          emptyRightsPoints[currentPoint.y][currentPoint.x + 1] = '1';
        }

        if (currentPoint.getValue(matrice) == 'L' && currentPoint.y != emptyLeftPoints.length - 1) {
          emptyLeftPoints[currentPoint.y + 1][currentPoint.x] = '1';
        }
        currentPoint.y--;
        currentPoint.nextDirection = Direction.north;
        currentPoint.lastDirection = currentPoint.nextDirection;
      case Direction.east:
        if (currentPoint.y != 0) {
          emptyLeftPoints[currentPoint.y - 1][currentPoint.x] = '1';
        }
        if (currentPoint.y != emptyRightsPoints.length - 1) {
          emptyRightsPoints[currentPoint.y + 1][currentPoint.x] = '1';
        }

        if (currentPoint.x != 0 && currentPoint.getValue(matrice) == 'F' || currentPoint.getValue(matrice) == 'S') {
          emptyLeftPoints[currentPoint.y][currentPoint.x - 1] = '1';
        }
        currentPoint.x++;
        currentPoint.nextDirection = Direction.east;
        currentPoint.lastDirection = currentPoint.nextDirection;
      case Direction.south:
        if (currentPoint.x != emptyLeftPoints[currentPoint.y].length - 1) {
          emptyLeftPoints[currentPoint.y][currentPoint.x + 1] = '1';
        }
        if (currentPoint.x != 0) {
          emptyRightsPoints[currentPoint.y][currentPoint.x - 1] = '1';
        }
        if (currentPoint.y != 0 && currentPoint.getValue(matrice) == '7' && currentPoint.y != 0) {
          emptyLeftPoints[currentPoint.y - 1][currentPoint.x] = '1';
        }
        currentPoint.y++;
        currentPoint.nextDirection = Direction.south;
        currentPoint.lastDirection = currentPoint.nextDirection;
      case Direction.west:
        if (currentPoint.y != emptyLeftPoints.length - 1) {
          emptyLeftPoints[currentPoint.y + 1][currentPoint.x] = '1';
        }
        if (currentPoint.y != 0) {
          emptyRightsPoints[currentPoint.y - 1][currentPoint.x] = '1';
        }
        if (currentPoint.getValue(matrice) == 'J' && currentPoint.x != emptyLeftPoints[currentPoint.y].length - 1) {
          emptyLeftPoints[currentPoint.y][currentPoint.x + 1] = '1';
        }
        currentPoint.x--;
        currentPoint.nextDirection = Direction.west;
        currentPoint.lastDirection = currentPoint.nextDirection;
    }
  } while (currentPoint.getValue(matrice) != 'S');


  cleanEmptyPointsMap(emptyLeftPoints, loopMap);
  cleanEmptyPointsMap(emptyRightsPoints, loopMap);
  fillEmptyPointsMap(emptyLeftPoints, loopMap);
  fillEmptyPointsMap(emptyRightsPoints, loopMap);
  int emptyRightsSum = sumEmptyPointsMap(emptyRightsPoints, loopMap);
  int emptyLeftSum = sumEmptyPointsMap(emptyLeftPoints, loopMap);
  printLoopMap(lines, emptyRightsPoints);
  printLoopMap(lines, emptyLeftPoints);
  printLoopMap(lines, loopMap);
  int sum = min(emptyLeftSum, emptyRightsSum);
  print('Part Two: $sum');
  }

void printLoopMap(List<String> lines, List<List<String>> loopMap) {
  for (int x = 0 ; x < loopMap.length; x++) {
    for (int y = 0 ; y < loopMap[x].length ; y++) {
      stdout.write(loopMap[x][y]);
    }
    stdout.writeln('');
  }
}

void cleanEmptyPointsMap(List<List<String>> emptyPointsMap, List<List<String>> loopMap) {
  for (int x = 0 ; x < loopMap.length; x++) {
    for (int y = 0 ; y < loopMap[x].length ; y++) {
      if (emptyPointsMap[x][y] == '1' && loopMap[x][y] == 'X') {
        emptyPointsMap[x][y] = ' ';
      }
    }
  }
}

void fillEmptyPointsMap(List<List<String>> emptyPointsMap, List<List<String>> loopMap) {
  for (int x = 0 ; x < loopMap.length; x++) {
    for (int y = 1 ; y < loopMap[x].length - 1 ; y++) {
      if (emptyPointsMap[x][y] == '1') {
        if (emptyPointsMap[x][y - 1] != '1' && loopMap[x][y - 1] != 'X') {
          emptyPointsMap[x][y - 1] = '1';
        }
        int i = 1;
        while (i != loopMap[x].length - y - 1 && loopMap[x][y + i] != 'X') {
          emptyPointsMap[x][y + i] = '1';
          i++;
        }
      }
    }
  }
}

int sumEmptyPointsMap(List<List<String>> emptyPointsMap, List<List<String>> loopMap) {
  int sum = 0;
  for (int x = 0 ; x < loopMap.length; x++) {
    for (int y = 0 ; y < loopMap[x].length ; y++) {
      if (emptyPointsMap[x][y] == '1') {
        sum++;
      }
    }
  }
  return sum;
}

Coordinate findStartPoint(List<String> lines) {
  for(final (yCoord, line) in lines.indexed) {
    for (int xCoord = 0 ; xCoord < line.length ; xCoord++) {
      if (line[xCoord] == 'S') {
        return Coordinate(xCoord, yCoord);
      }
    }
  }

  final startPoint = Coordinate(0, 0);
  return startPoint;
}

Direction getFirstNextDirection(Coordinate coordinate, List<List<String>> matrice) {
  List<String> northPipes = ['|', '7', 'F'];
  List<String> eastPipes = ['-', '7', 'J'];
  List<String> southPipes = ['|', 'J', 'L'];
  List<String> westPipes = ['-', 'F', 'L'];

  if (coordinate.y != 0 && northPipes.contains(matrice[coordinate.y - 1][coordinate.x])) {
    return Direction.north;
  }
  if (coordinate.x != matrice.length -1 && eastPipes.contains(matrice[coordinate.y][coordinate.x + 1])) {
    return Direction.east;
  }
  if (coordinate.y != matrice[coordinate.y].length - 1 && southPipes.contains(matrice[coordinate.y + 1][coordinate.x])) {
    return Direction.south;
  }
  if (coordinate.x != 0 && westPipes.contains(matrice[coordinate.y][coordinate.x - 1])) {
    return Direction.west;
  }

  throw Exception('NO FIRST DIRECTION FOUND' + ' ' + coordinate.toString());
}

Direction getNextDirection(Coordinate coordinate, List<List<String>> matrice) {
  switch(coordinate.getValue(matrice)) {
    case 'S':
      return coordinate.nextDirection!;
    case '|':
      return coordinate.lastDirection == Direction.north ? Direction.north : Direction.south;
    case '-':
      return coordinate.lastDirection == Direction.east ? Direction.east : Direction.west;
    case '7':
      return coordinate.lastDirection == Direction.east ? Direction.south : Direction.west;
    case 'F':
      return coordinate.lastDirection == Direction.north ? Direction.east : Direction.south;
    case 'J':
      return coordinate.lastDirection == Direction.east ? Direction.north : Direction.west;
    case 'L':
      return coordinate.lastDirection == Direction.south ? Direction.east : Direction.north;
  }

  throw Exception('NO DIRECTION FOUND' + ' ' + coordinate.toString());
}

List<List<String>> getMatrice(List<String> lines) {
  List<List<String>> map = [];
  for(final (yCoord, line) in lines.indexed) {
    List<String> lineMap = [];
    for (int xCoord = 0 ; xCoord < line.length ; xCoord++) {
      lineMap.add(line[xCoord]);
    }
    map.add(lineMap);
  }

  return map;
}
