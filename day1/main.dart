import 'dart:io';

void main() {
  final File file = File('./input.txt');
  file.readAsLines().then((List<String> lines) {
    partOne(lines);
    partTwo(lines);
  });
}

void partOne(List<String> lines) {
  int sum = 0;
  for (final String line in lines) {
    String firstDigit = '';
    String? lastDigit = null;
    for (int char = 0; char < line.length ; char++) {
      int? digit = int.tryParse(line[char]);
      if (null != digit) {
        if ('' == firstDigit) {
          firstDigit = line[char];
        } else {
          lastDigit = line[char];
        }
      }
    }
    sum += int.parse(firstDigit + (lastDigit ?? firstDigit));
  }
  print('Part One: ${sum.toString()}');
}

void partTwo(List<String> lines) {
  final Map<String, int> digitToString = {
    'zero': 0,
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
  };
  int sum = 0;
  for (final String line in lines) {
    String firstDigit = '';
    String? lastDigit = null;
    for (int char = 0; char < line.length ; char++) {
      int? digit = int.tryParse(line[char]);
      if (null == digit) {
        digitToString.forEach((key, value) {
          if (line.length >= char + key.length && key == line.substring(char, char + key.length)) {
            if ('' == firstDigit) {
              firstDigit = value.toString();
            } else {
              lastDigit = value.toString();
            }
          }
        });
      }
      else {
        if ('' == firstDigit) {
          firstDigit = line[char];
        } else {
          lastDigit = line[char];
        }
      }
    }
    sum += int.parse(firstDigit + (lastDigit ?? firstDigit));
  }
  print('Part Two: ${sum.toString()}');
}