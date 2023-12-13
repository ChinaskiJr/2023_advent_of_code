import 'dart:io';
import 'dart:math';

void main() {
  final File file = File('./input.txt');
  file.readAsLines().then((List<String> lines) {
    partOne(lines);
    partTwo(lines);
  });
}

void partOne(List<String> lines) {
  final patterns = getPatterns(lines);
  List<int> spacesBefore = [];
  int spaceAbove = 0;
  int spaceLeft = 0;
  int spaceBefore = 0;
  for (final pattern in patterns) {
    int horizontalSize = 0;
    int rowAbove = 0;
    for (final (index, line) in pattern.indexed) {
      if (index != pattern.length - 1 && line == pattern[index + 1]) {
        horizontalSize = 1;
        while (index + horizontalSize + 1 != pattern.length && index - horizontalSize >= 0 && pattern[index - horizontalSize] == pattern[index + horizontalSize + 1]) {
          horizontalSize++;
          if (index + 1 - horizontalSize == 0 || index + horizontalSize + 1 == pattern.length) {
            break;
          }
        }
        if (index + 1 - horizontalSize == 0 || index + horizontalSize + 1 == pattern.length) {
          rowAbove = index + 1;
          break;
        }
      }
    }
    spacesBefore.add(rowAbove);
  }
  List<List<String>> reversePatterns = [];
  for (final pattern in patterns) {
    List<String> reversePattern = [];

    for (int x = 0; x < pattern[0].length; x++) {
      String verticalLine = '';
      for (int y = 0; y < pattern.length; y++) {
        verticalLine += pattern[y][x];
      }
      reversePattern.add(verticalLine);
    }
    reversePatterns.add(reversePattern);
  }
  for (final (indexPattern, pattern) in reversePatterns.indexed) {
    int verticalSize = 0;
    int lineBefore = 0;
    for (final (index, line) in pattern.indexed) {
      if (index != pattern.length - 1 && line == pattern[index + 1]) {
        verticalSize = 1;
        while (index + verticalSize + 1 != pattern.length && index - verticalSize >= 0 && pattern[index - verticalSize] == pattern[index + verticalSize + 1]) {
          verticalSize++;
          if (index + 1 - verticalSize == 0 || index + verticalSize + 1 == pattern.length) {
            break;
          }
        }
        if (index + 1 - verticalSize == 0 || index + verticalSize + 1 == pattern.length) {
          lineBefore += index + 1;
          break;
        }
      }
    }
    print(lineBefore.toString() + ' ' + spacesBefore[indexPattern].toString());
    if (lineBefore > spacesBefore[indexPattern]) {
      spacesBefore[indexPattern] = lineBefore;
      spaceLeft += lineBefore;
    } else {
      spaceAbove += spacesBefore[indexPattern];
    }
  }

  int sum = spaceLeft + spaceAbove * 100;

  print('Part One: $sum');
}

List<List<String>> getPatterns(List<String> lines) {
  List<List<String>> patterns = [];
  List<String> pattern = [];
  for (final (index, line) in lines.indexed) {
    if (line == '' || index == lines.length - 1) {
      if (index == lines.length - 1) {
        pattern.add(line);
      }
      patterns.add([...pattern]);
      pattern = [];
      continue;
    }
    pattern.add(line);
  }

  return patterns;
}

int onlyOneCharDiffers(String string1, String string2) {
  int difference = 0;
  for (int index = 0 ; index < string1.length ; index++) {
    if (string1[index] != string2[index]) {
      if (difference++ > 1) {
        return 2;
      }
    }
  }

  return difference;
}


void partTwo(List<String> lines) {
  final patterns = getPatterns(lines);
  List<int> spacesBefore = [];
  int spaceAbove = 0;
  int spaceLeft = 0;
  int spaceBefore = 0;
  int sum = 0;
  for (final pattern in patterns) {
    int horizontalSize = 0;
    int rowAbove = 0;
    int test = 0;
    for (final (index, line) in pattern.indexed) {
      bool diffOne = false;
      horizontalSize = 0;
      if (index != pattern.length - 1 && onlyOneCharDiffers(line, pattern[index + 1]) <= 1) {
        if (horizontalSize == 0 && onlyOneCharDiffers(pattern[index - horizontalSize], pattern[index + horizontalSize + 1]) == 1) {
            test = (index + 1) * 100;
            break;
          diffOne = true;
        }
        horizontalSize = 1;
        while (index + horizontalSize + 1 != pattern.length && index - horizontalSize >= 0 && onlyOneCharDiffers(pattern[index - horizontalSize], pattern[index + horizontalSize + 1]) <= 1) {
          if (onlyOneCharDiffers(pattern[index - horizontalSize], pattern[index + horizontalSize + 1]) == 1) {
            diffOne = true;
          }
          horizontalSize++;
          if (index + 1 - horizontalSize == 0 || index + horizontalSize + 1 == pattern.length) {
            break;
          }
        }
        if (index + 1 - horizontalSize == 0 || index + horizontalSize + 1 == pattern.length) {
          if (!diffOne && onlyOneCharDiffers(lines[index], lines[index + 1]) != 1) {
            continue;
          }
          test += (index + 1) * 100;

          break;
        }
      }
    }
    spacesBefore.add(test);
    sum += test;
  }
  List<List<String>> reversePatterns = [];
  for (final pattern in patterns) {
    List<String> reversePattern = [];

    for (int x = 0; x < pattern[0].length; x++) {
      String verticalLine = '';
      for (int y = 0; y < pattern.length; y++) {
        verticalLine += pattern[y][x];
      }
      reversePattern.add(verticalLine);
    }
    reversePatterns.add(reversePattern);
  }
  final rowBefore = [];
  for (final (patternIndex, pattern) in reversePatterns.indexed) {
    if (spacesBefore[patternIndex] > 0) {
      rowBefore.add(0);
      continue;
    }
    int horizontalSize = 0;
    int rowAbove = 0;
    int test = 0;
    for (final (index, line) in pattern.indexed) {
      bool diffOne = false;
      if (index != pattern.length - 1 && onlyOneCharDiffers(line, pattern[index + 1]) <= 1) {
        if (horizontalSize == 0 && onlyOneCharDiffers(pattern[index - horizontalSize], pattern[index + horizontalSize + 1]) == 1) {
          test = (index + 1);
          break;
          diffOne = true;
        }
        horizontalSize = 1;
        while (index + horizontalSize + 1 != pattern.length && index - horizontalSize >= 0 && onlyOneCharDiffers(pattern[index - horizontalSize], pattern[index + horizontalSize + 1]) <= 1) {
          if (onlyOneCharDiffers(pattern[index - horizontalSize], pattern[index + horizontalSize + 1]) == 1) {
            diffOne = true;
          }
          horizontalSize++;
          if (index + 1 - horizontalSize == 0 || index + horizontalSize + 1 == pattern.length) {
            break;
          }
        }
        if (index + 1 - horizontalSize == 0 || index + horizontalSize + 1 == pattern.length) {
          test += (index + 1);

          break;
        }
      }
    }
    rowBefore.add(test);
    sum += test;
  }

  for(int x = 0 ; x < spacesBefore.length ; x++) {
    print(spacesBefore[x].toString() + ' ' + rowBefore[x].toString());
  }
  print('Part One: $sum');
}


