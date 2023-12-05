import 'dart:io';

void main() {
  final File file = File('./input.txt');
  file.readAsLines().then((List<String> lines) {
    List<String> seeds = [];
    List<List<String>> seedToSoil = [];
    List<List<String>> soilToFertilizer = [];
    List<List<String>> fertilizerToWater = [];
    List<List<String>> waterToLight = [];
    List<List<String>> lightToTemperature = [];
    List<List<String>> temperatureToHumidity = [];
    List<List<String>> humidityToLocation = [];

    for (final (int index, String line) in lines.indexed) {
      if (line.contains(':')) {
        if (line.substring(0, 5) == 'seeds') {
          seeds = line.split(': ')[1].split(' ');
        }
        if (seedToSoil.isEmpty) {
          seedToSoil = getMap('seed-to-soil map:', index, lines);
        }
        if (soilToFertilizer.isEmpty) {
          soilToFertilizer = getMap('soil-to-fertilizer map:', index, lines);
        }
        if (fertilizerToWater.isEmpty) {
          fertilizerToWater = getMap('fertilizer-to-water map:', index, lines);
        }
        if (waterToLight.isEmpty) {
          waterToLight = getMap('water-to-light map:', index, lines);
        }
        if (lightToTemperature.isEmpty) {
          lightToTemperature = getMap('light-to-temperature map:', index, lines);
        }
        if (temperatureToHumidity.isEmpty) {
          temperatureToHumidity = getMap('temperature-to-humidity map:', index, lines);
        }
        if (humidityToLocation.isEmpty) {
          humidityToLocation = getMap('humidity-to-location map:', index, lines);
        }
      }
    }

    int minimumLocation = 0;
    for (final seed in seeds) {
      int seedAsInt = int.parse(seed);
      seedAsInt = calculateLocation(seedAsInt, seedToSoil);
      seedAsInt = calculateLocation(seedAsInt, soilToFertilizer);
      seedAsInt = calculateLocation(seedAsInt, fertilizerToWater);
      seedAsInt = calculateLocation(seedAsInt, waterToLight);
      seedAsInt = calculateLocation(seedAsInt, lightToTemperature);
      seedAsInt = calculateLocation(seedAsInt, temperatureToHumidity);
      seedAsInt = calculateLocation(seedAsInt, humidityToLocation);
      if (0 == minimumLocation) {
        minimumLocation = seedAsInt;
      } else if (seedAsInt < minimumLocation) {
        minimumLocation = seedAsInt;
      }
    }

    print('Part One: $minimumLocation');

    minimumLocation = 0;
    int locationAsInt = 0;
    while(!isNumberFromSeed(minimumLocation, seeds)) {
      minimumLocation = calculateSeed(locationAsInt, humidityToLocation);
      minimumLocation = calculateSeed(minimumLocation, temperatureToHumidity);
      minimumLocation = calculateSeed(minimumLocation, lightToTemperature);
      minimumLocation = calculateSeed(minimumLocation, waterToLight);
      minimumLocation = calculateSeed(minimumLocation, fertilizerToWater);
      minimumLocation = calculateSeed(minimumLocation, soilToFertilizer);
      minimumLocation = calculateSeed(minimumLocation, seedToSoil);
      locationAsInt++;
    }

    print('Part Two: ${locationAsInt - 1}');
  });
}

int calculateLocation(int seedAsInt, List<List<String>> map) {
  for (final values in map) {
    int destinationRangeStart = int.parse(values[0]);
    int sourceRangeStart = int.parse(values[1]);
    int rangeLength = int.parse(values[2]);
    if (seedAsInt >= sourceRangeStart && seedAsInt <= sourceRangeStart + rangeLength) {
      seedAsInt = seedAsInt - sourceRangeStart + destinationRangeStart;
      break;
    }
  }

  return seedAsInt;
}

int calculateSeed(int locationAsInt, List<List<String>> map) {
  for (final values in map) {
    int sourceRangeStart = int.parse(values[0]);
    int destinationRangeStart = int.parse(values[1]);
    int rangeLength = int.parse(values[2]);
    if (locationAsInt >= sourceRangeStart && locationAsInt <= sourceRangeStart + rangeLength) {
      locationAsInt = locationAsInt - sourceRangeStart + destinationRangeStart;
      break;
    }
  }

  return locationAsInt;
}

bool isNumberFromSeed(int number, List<String> seeds) {
  for (int index = 0 ; index < seeds.length ; index += 2) {
    if (number >= int.parse(seeds[index]) && number <= int.parse(seeds[index]) + int.parse(seeds[index + 1])) {
      return true;
    }
  }

  return false;
}

List<List<String>> getMap(String needle, int index, List<String> lines) {
  List<List<String>> map = [];
  if (lines[index] == needle) {
    int i = index + 1;
    while (i != lines.length && lines[i] != '') {
      map.add(lines[i].split(' '));
      i++;
    }
  }

  return map;
}