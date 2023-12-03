import 'dart:io';

void main() {
  final File file = File('./input.txt');
  file.readAsLines().then((List<String> lines) {
    partOne(lines);
    partTwo(lines);
  });
}

List<List<String>> createMatrice(List<String> lines) {
  List<List<String>> matrice = [];
  for (final String line in lines) {
    List<String> matriceLine = [];
    line.runes.forEach((rune) {
      matriceLine.add(new String.fromCharCode(rune));
    });
    matrice.add(matriceLine);
  }

  return matrice;
}

void partOne(List<String> lines) {
  List<List<String>> matrice = createMatrice(lines);
  int sum = 0;
  for (int lineIndex = 0; lineIndex < matrice.length; lineIndex++) {
    for (int colIndex = 0; colIndex < matrice[lineIndex].length; colIndex++) {
      String char = matrice[lineIndex][colIndex];
      if ('.' != char && !char.contains(new RegExp(r'[0-9]'))) {
        // Get all height chars around the symbol, with the appropriate coordinates as keys.
        Map<List<int>, String> charToCheck = {};
        List<String> alreadyCheckedCoordinates = [];
        charToCheck[[lineIndex - 1, colIndex - 1]] = matrice[lineIndex - 1][colIndex - 1];
        charToCheck[[lineIndex - 1, colIndex]] = matrice[lineIndex - 1][colIndex];
        charToCheck[[lineIndex - 1, colIndex + 1]] = matrice[lineIndex - 1][colIndex + 1];
        charToCheck[[lineIndex, colIndex - 1]] = matrice[lineIndex ][colIndex - 1];
        charToCheck[[lineIndex, colIndex + 1]] = matrice[lineIndex][colIndex + 1];
        charToCheck[[lineIndex + 1, colIndex - 1]] = matrice[lineIndex + 1][colIndex - 1];
        charToCheck[[lineIndex + 1, colIndex]] = matrice[lineIndex + 1][colIndex];
        charToCheck[[lineIndex + 1, colIndex + 1]] = matrice[lineIndex + 1][colIndex + 1];
        charToCheck.forEach((coordinates, symbol) {
          if (null != int.tryParse(symbol) && !alreadyCheckedCoordinates.contains(coordinates.toString())) {
            // Go back over the line to get the first digit.
            int colCoordinate = coordinates[1];
            while(colCoordinate != 0 && null != int.tryParse(matrice[coordinates[0]][colCoordinate - 1])) {
              colCoordinate--;
            }
            String numberToGet = matrice[coordinates[0]][colCoordinate];
            alreadyCheckedCoordinates.add([coordinates[0], colCoordinate].toString());
            while(colCoordinate != matrice[coordinates[0]].length - 1 && null != int.tryParse(matrice[coordinates[0]][colCoordinate + 1])) {
              colCoordinate++;
              numberToGet += matrice[coordinates[0]][colCoordinate];
              // Don't check for these coordinates again.
              alreadyCheckedCoordinates.add([coordinates[0], colCoordinate].toString());
            }
            sum += int.parse(numberToGet);
          }
        });
      }
    }
  }

  print('Part One: $sum');
}

void partTwo(List<String> lines) {
  List<List<String>> matrice = createMatrice(lines);
  int sum = 0;
  for (int lineIndex = 0; lineIndex < matrice.length; lineIndex++) {
    for (int colIndex = 0; colIndex < matrice[lineIndex].length; colIndex++) {
      String char = matrice[lineIndex][colIndex];
      if ('*' == char) {
        // Get all height chars around the symbol, with the appropriate coordinates as keys.
        Map<List<int>, String> charToCheck = {};
        List<String> alreadyCheckedCoordinates = [];
        List<int> gearRatioElements = [];
        charToCheck[[lineIndex - 1, colIndex - 1]] = matrice[lineIndex - 1][colIndex - 1];
        charToCheck[[lineIndex - 1, colIndex]] = matrice[lineIndex - 1][colIndex];
        charToCheck[[lineIndex - 1, colIndex + 1]] = matrice[lineIndex - 1][colIndex + 1];
        charToCheck[[lineIndex, colIndex - 1]] = matrice[lineIndex ][colIndex - 1];
        charToCheck[[lineIndex, colIndex + 1]] = matrice[lineIndex][colIndex + 1];
        charToCheck[[lineIndex + 1, colIndex - 1]] = matrice[lineIndex + 1][colIndex - 1];
        charToCheck[[lineIndex + 1, colIndex]] = matrice[lineIndex + 1][colIndex];
        charToCheck[[lineIndex + 1, colIndex + 1]] = matrice[lineIndex + 1][colIndex + 1];
        charToCheck.forEach((coordinates, symbol) {
          if (null != int.tryParse(symbol) && !alreadyCheckedCoordinates.contains(coordinates.toString())) {
            // Go back over the line to get the first digit.
            int colCoordinate = coordinates[1];
            while(colCoordinate != 0 && null != int.tryParse(matrice[coordinates[0]][colCoordinate - 1])) {
              colCoordinate--;
            }
            String numberToGet = matrice[coordinates[0]][colCoordinate];
            alreadyCheckedCoordinates.add([coordinates[0], colCoordinate].toString());
            while(colCoordinate != matrice[coordinates[0]].length - 1 && null != int.tryParse(matrice[coordinates[0]][colCoordinate + 1])) {
              colCoordinate++;
              numberToGet += matrice[coordinates[0]][colCoordinate];
              // Don't check for these coordinates again.
              alreadyCheckedCoordinates.add([coordinates[0], colCoordinate].toString());
            }
            gearRatioElements.add(int.parse(numberToGet));
          }
        });
        if (gearRatioElements.length >= 2) {
          sum += gearRatioElements.reduce((value, element) => value * element);
        }
      }
    }
  }
  print('Part Two: $sum');
}