import 'dart:io';

void main() {
  final File file = File('./input.txt');
  file.readAsLines().then((List<String> lines) {
    partOne(lines);
    partTwo(lines);
  });
}

void partOne(List<String> lines) {
  int total = 0;
  for (final String line in lines) {
    int sum = 0;
    List<String> numbers = line.split(':')[1].split('|');
    List<String> winningNumbers = numbers[0].trim().split(RegExp(r'\s+'));
    List<String> playingNumbers = numbers[1].trim().split(RegExp(r'\s+'));

    for (final String playingNumber in playingNumbers) {
      if (winningNumbers.contains(playingNumber)) {
        sum = (sum == 0) ? 1 : sum * 2;
      }
    }
    total += sum;
  }
  print('Part One: $total');
}

void partTwo(List<String> lines) {
  int cardId = 1;
  Map<int, int> wonCards = {};
  for (final String line in lines) {
    // Add the original card
    if(!wonCards.containsKey(cardId)) {
      wonCards[cardId] = 1;
    } else {
      wonCards[cardId] = wonCards[cardId]! + 1;
    }
    int wonCardIndex = 1;
    List<String> numbers = line.split(':')[1].split('|');
    List<String> winningNumbers = numbers[0].trim().split(RegExp(r'\s+'));
    List<String> playingNumbers = numbers[1].trim().split(RegExp(r'\s+'));

    for (final String playingNumber in playingNumbers) {
      if (winningNumbers.contains(playingNumber)) {
        if (wonCards.containsKey(cardId + wonCardIndex)) {
          wonCards[cardId + wonCardIndex] = wonCards[cardId + wonCardIndex]! + wonCards[cardId]!;
        } else {
          wonCards[cardId + wonCardIndex] = wonCards[cardId]!;
        }
        wonCardIndex++;
      }
    }
    cardId++;
  }

  print('Part Two: ${wonCards.values.reduce((value, element) => value + element)}');
}
