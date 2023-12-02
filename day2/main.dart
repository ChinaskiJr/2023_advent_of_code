import 'dart:io';

void main() {
  final File file = File('./input.txt');
  file.readAsLines().then((List<String> lines) {
    partOne(lines);
    partTwo(lines);
  });
}

int maxCubeFromColor(String color, String line) {
  final RegExp regExp = new RegExp(r'(\d+)\s' + color);
  final Iterable<RegExpMatch> matches = regExp.allMatches(line);
  final List<int> amount = matches.map((RegExpMatch match) => int.parse(match[0]!.split(' ').first)).toList();
  amount.sort();
  return amount.last;
}

void partOne(List<String> lines) {
  final int maxRedInBag = 12;
  final int maxGreenInBag = 13;
  final int maxBlueInBag = 14;

  int possibleIdSum = 0;
  for (final String line in lines) {
    final List<String> splitedline = line.split(' ');
    final int maxGreenGiven = maxCubeFromColor('green', line);
    final int maxRedGiven = maxCubeFromColor('red', line);
    final int maxBlueGiven = maxCubeFromColor('blue', line);

    if (maxGreenGiven <= maxGreenInBag && maxBlueGiven <= maxBlueInBag && maxRedGiven <= maxRedInBag) {
      possibleIdSum += int.parse(splitedline[1].substring(0, splitedline[1].length - 1));
    }
  }
  print('Part One: ${possibleIdSum.toString()}');
}

void partTwo(List<String> lines) {
  int powerSum = 0;
  for (final String line in lines) {
    final int maxGreenGiven = maxCubeFromColor('green', line);
    final int maxRedGiven = maxCubeFromColor('red', line);
    final int maxBlueGiven = maxCubeFromColor('blue', line);

    powerSum += maxGreenGiven * maxRedGiven * maxBlueGiven;
  }
  print('Part Two: $powerSum');
}