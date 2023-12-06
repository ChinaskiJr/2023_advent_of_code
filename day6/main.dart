import 'dart:io';

void main() {
  final File file = File('./input.txt');
  file.readAsLines().then((List<String> lines) {
    partOne(lines);
    partTwo(lines);
  });
}

void partOne(List<String> lines) {
  final List<int> times = extractLine(lines[0]);
  final List<int> distances = extractLine(lines[1]);
  int produce = 1;
  for(final (int raceId, int time) in times.indexed) {
    int possibleWinByRace = 0;
    for (int i = 0 ; i <= time ; i++) {
      int distance = (time - i) * i;
      if (distance > distances[raceId]) {
        possibleWinByRace++;
      }
    }
    produce *= possibleWinByRace;
  }

  print('Part one: $produce');
}

void partTwo(List<String> lines) {
  final int time = extractLineAsOneRace(lines[0]);
  final int totalDistance = extractLineAsOneRace(lines[1]);

  int possibleWinByRace = 0;
  for (int i = 0 ; i <= time ; i++) {
    int distance = (time - i) * i;
    if (distance > totalDistance) {
      possibleWinByRace++;
    }
  }

  print('Part Two: $possibleWinByRace');
}

List<int> extractLine(String line) {
  List<String> timesAsString = line.split(' ');
  timesAsString.removeAt(0);
  timesAsString = timesAsString.where((element) => element != '').toList();

  return  timesAsString.map((e) => int.parse(e)).toList();
}

int extractLineAsOneRace(String line) {
  List<String> timesAsString = line.split(' ');
  timesAsString.removeAt(0);
  timesAsString = timesAsString.where((element) => element != '').toList();

  return int.parse(timesAsString.join());
}