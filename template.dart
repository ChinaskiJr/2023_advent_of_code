import 'dart:io';

void main() async {
  File file = File('./input.txt');
  file.readAsLines().then((List<String> lines) {
    partOne(lines);
    partTwo(lines);
  });
}

void partOne(List<String> lines) {
  print('Part One: ');
}

void partTwo(List<String> lines) {
  print('Part Two: ');
}