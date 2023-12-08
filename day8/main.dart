import 'dart:io';

void main() {
  final File file = File('./input.txt');
  file.readAsLines().then((List<String> lines) {
    partOne(lines);
    partTwo(lines);
  });
}

void partOne(List<String> lines) {
  String direction = lines[0];
  List<String> directions = [];
  direction.runes.forEach((rune) {
    directions.add(String.fromCharCode(rune));
  });
  Map<String, List<String>> elements = {};

  for (final String line in lines) {
    if (line.split(' ').length < 2) {
      continue;
    }
    var lineSplit = line.split(' ');
    elements[lineSplit[0]] = [lineSplit[2].substring(1, lineSplit[2].length - 1), lineSplit[3].substring(0, lineSplit[3].length - 1)];
  }

  bool finished = false;
  String currentElement = 'AAA';
  int step = 0;
  while (!finished) {
    for (String currentDirection in directions) {
      step++;
      var directionChoices = elements[currentElement];
      if (currentDirection == 'L') {
        currentElement = directionChoices![0];
      } else {
        currentElement = directionChoices![1];
      }
      if (currentElement == 'ZZZ') {
        finished = true;
        break;
      }
    }
  }

  print('Part One: $step');
}

void partTwo(List<String> lines) {
  String direction = lines[0];
  List<String> directions = [];
  direction.runes.forEach((rune) {
    directions.add(String.fromCharCode(rune));
  });
  Map<String, List<String>> elements = {};

  for (final String line in lines) {
    if (line.split(' ').length < 2) {
      continue;
    }
    var lineSplit = line.split(' ');
    elements[lineSplit[0]] = [lineSplit[2].substring(1, lineSplit[2].length - 1), lineSplit[3].substring(0, lineSplit[3].length - 1)];
  }

  List<String> currentElements = elements.keys.where((e) => e.endsWith('A')).toList();

  List<int> steps = [];
  for (final currentElementLoop in currentElements) {
    int step = 0;
    String currentElement = currentElementLoop;
    bool finished = false;
    while (!finished) {
      for (String currentDirection in directions) {
        step++;
        var directionChoices = elements[currentElement];
        if (currentDirection == 'L') {
          currentElement = directionChoices![0];
        } else {
          currentElement = directionChoices![1];
        }
        if (currentElement.endsWith('Z')) {
          finished = true;
          break;
        }
      }
    }
    steps.add(step);
  }

  print('Part Two: ${findLCMOfList(steps)}');
}


int findLCM(int a, int b) {
  int gcd = 1;
  for (int i = 1; i <= a && i <= b; i++) {
    if (a % i == 0 && b % i == 0) {
      gcd = i;
    }
  }

  return (a * b) ~/ gcd;
}

int findLCMOfList(List<int> numbers) {
  int lcm = numbers[0];

  for (int i = 1; i < numbers.length; i++) {
    lcm = findLCM(lcm, numbers[i]);
  }

  return lcm;
}