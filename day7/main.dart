import 'dart:collection';
import 'dart:io';

void main() {
  final File file = File('./input.txt');
  file.readAsLines().then((List<String> lines) {
    partOne(lines);
    partTwo(lines);
  });
}

void partOne(List<String> lines) {
  List<String> hands = [];
  List<int> bids = [];
  for (final String line in lines) {
    hands.add(line.split(' ')[0]);
    bids.add(int.parse(line.split(' ')[1]));
  }
  Map<String, int> handsBidsMap = Map.fromIterables(hands, bids);

  Map<String, SplayTreeMap<String, int>> sortedHands = {};
  for (final String hand in hands) {
    List<String> cards = hand.split('');
    Map<String, int> cardOccurrences = {};
    for (final String card in cards) {
      cardOccurrences[card] = (cardOccurrences[card] ?? 0) + 1;
      sortedHands[hand] = SplayTreeMap<String, int>.from(cardOccurrences, compareCards);
    }
  }

  SplayTreeMap<String, SplayTreeMap<String, int>> sortedGames = SplayTreeMap<String, SplayTreeMap<String, int>>.from(sortedHands, (a, b) {
    return compareGames(sortedHands[a]!, sortedHands[b]!, a, b);
  });

  var unsortedGame = Map.fromEntries(sortedGames.entries.toList().reversed);
  int sum = 0;
  int index = 0;
  unsortedGame.forEach((key, value) {
    index++;
    sum += handsBidsMap[key]! * index;
  });

  print('Part One: $sum');
}

void partTwo(List<String> lines) {
  List<String> hands = [];
  List<int> bids = [];
  for (final String line in lines) {
    hands.add(line.split(' ')[0]);
    bids.add(int.parse(line.split(' ')[1]));
  }
  Map<String, int> handsBidsMap = Map.fromIterables(hands, bids);

  Map<String, SplayTreeMap<String, int>> sortedHands = {};
  for (final String hand in hands) {
    List<String> cards = hand.split('');
    Map<String, int> cardOccurrences = {};
    for (final String card in cards) {
      cardOccurrences[card] = (cardOccurrences[card] ?? 0) + 1;
      sortedHands[hand] = SplayTreeMap<String, int>.from(cardOccurrences, compareCardsWithJoker);
    }
  }

  SplayTreeMap<String, SplayTreeMap<String, int>> sortedGames = SplayTreeMap<String, SplayTreeMap<String, int>>.from(sortedHands, (a, b) {
    return compareGamesWithJoker(sortedHands[a]!, sortedHands[b]!, a, b);
  });

  var unsortedGame = Map.fromEntries(sortedGames.entries.toList().reversed);
  int sum = 0;
  int index = 0;
  unsortedGame.forEach((key, value) {
    index++;
    sum += handsBidsMap[key]! * index;
  });

  print('Part Two: $sum');}

int compareGames(SplayTreeMap<String, int> a, SplayTreeMap<String, int> b, String cardA, String cardB) {
  int maxOccurrenceA = 0;
  int secondMaxOccurrenceA = 0;
  int maxOccurrenceB = 0;
  int secondMaxOccurrenceB = 0;

  a.forEach((card, occurrence) {
    if (maxOccurrenceA < occurrence) {
      if (maxOccurrenceA != 0) {
        secondMaxOccurrenceA = maxOccurrenceA;
      }
      maxOccurrenceA = occurrence;
    } else if (secondMaxOccurrenceA < occurrence) {
      secondMaxOccurrenceA = occurrence;
    }
  });
  b.forEach((card, occurrence) {
    if (maxOccurrenceB < occurrence) {
      if (maxOccurrenceB != 0) {
        secondMaxOccurrenceB = maxOccurrenceB;
      }
      maxOccurrenceB = occurrence;
    } else if (secondMaxOccurrenceB < occurrence) {
      secondMaxOccurrenceB = occurrence;
    }
  });
  // Full House
  if (maxOccurrenceA == 3 && secondMaxOccurrenceA == 2 && maxOccurrenceB < 4 && secondMaxOccurrenceB != 2) {
    return -1;
  }
  if (maxOccurrenceB == 3 && secondMaxOccurrenceB == 2 && maxOccurrenceA < 4 && secondMaxOccurrenceA != 2) {
    return 1;
  }
  if (maxOccurrenceA == 3 && maxOccurrenceB == 3 && secondMaxOccurrenceB == 2 && secondMaxOccurrenceA == 2) {
    return compareFirstHighestCardInHand(cardA, cardB);
  }

  // Two pair
  if (maxOccurrenceA == 2 && maxOccurrenceB == 2 && secondMaxOccurrenceB == 2 && secondMaxOccurrenceA == 2) {
    return compareFirstHighestCardInHand(cardA, cardB);
  }
  if (maxOccurrenceB == 2 && secondMaxOccurrenceB == 2 && maxOccurrenceA < 3) {
    return 1;
  }
  if (maxOccurrenceA == 2 && secondMaxOccurrenceA == 2 && maxOccurrenceB < 3) {
    return -1;
  }


  // Most big occurrence win
  if (maxOccurrenceA != maxOccurrenceB) {
    return maxOccurrenceA > maxOccurrenceB ? -1 : 1;
  }

  return compareFirstHighestCardInHand(cardA, cardB);
}

int compareFirstHighestCardInHand(String handA, String handB) {
  for (int index = 0 ; index < handA.length; index++) {
    int result = compareCards(handA.substring(index, index + 1), handB.substring(index, index + 1));
    if (result != 0) {
      return result;
    }
  }

  return 0;
}

int compareFirstHighestCardInHandWithJoker(String handA, String handB) {
  for (int index = 0 ; index < handA.length; index++) {
    int result = compareCardsWithJoker(handA.substring(index, index + 1), handB.substring(index, index + 1));
    if (result != 0) {
      return result;
    }
  }

  return 0;
}

int compareCards(String a, String b) {
  if (a == b) {
    return 0;
  }
  if (a == 'A') {
    return -1;
  }
  if (b == 'A') {
    return 1;
  }
  if (a == 'K') {
    return -1;
  }
  if (b == 'K') {
    return 1;
  }
  if (a == 'Q') {
    return -1;
  }
  if (b == 'Q') {
    return 1;
  }
  if (a == 'J') {
    return -1;
  }
  if (b == 'J') {
    return 1;
  }
  if (a == 'T') {
    return -1;
  }
  if (b == 'T') {
    return 1;
  }
  return b.compareTo(a);
}


int compareCardsWithJoker(String a, String b) {
  if (a == b) {
    return 0;
  }
  if (a == 'J') {
    return 1;
  }
  if (b == 'J') {
    return -1;
  }
  if (a == 'A') {
    return -1;
  }
  if (b == 'A') {
    return 1;
  }
  if (a == 'K') {
    return -1;
  }
  if (b == 'K') {
    return 1;
  }
  if (a == 'Q') {
    return -1;
  }
  if (b == 'Q') {
    return 1;
  }
  if (a == 'T') {
    return -1;
  }
  if (b == 'T') {
    return 1;
  }
  return b.compareTo(a);
}

int compareGamesWithJoker(SplayTreeMap<String, int> a, SplayTreeMap<String, int> b, String cardA, String cardB) {
  int maxOccurrenceA = 0;
  int secondMaxOccurrenceA = 0;
  int maxOccurrenceB = 0;
  int secondMaxOccurrenceB = 0;
  a.forEach((card, occurrence) {
    if (maxOccurrenceA < occurrence && card != 'J') {
      if (maxOccurrenceA != 0) {
        secondMaxOccurrenceA = maxOccurrenceA;
      }
      maxOccurrenceA = occurrence;
    } else if (secondMaxOccurrenceA < occurrence && card != 'J') {
      secondMaxOccurrenceA = occurrence;
    }
  });
  b.forEach((card, occurrence) {
    if (maxOccurrenceB < occurrence && card != 'J') {
      if (maxOccurrenceB != 0) {
        secondMaxOccurrenceB = maxOccurrenceB;
      }
      maxOccurrenceB = occurrence;
    } else if (secondMaxOccurrenceB < occurrence && card != 'J') {
      secondMaxOccurrenceB = occurrence;
    }
  });
  int nbJokerA = a['J'] ?? 0;
  int nbJokerB = b['J'] ?? 0;

  // Full House
  if (!(maxOccurrenceB + nbJokerB >= 4) && ((maxOccurrenceA == 3 && secondMaxOccurrenceA == 2) || (maxOccurrenceA == 2 && secondMaxOccurrenceA == 2 && nbJokerA == 1)) && ! ((maxOccurrenceB == 3 && secondMaxOccurrenceB == 2) || (maxOccurrenceB == 2 && secondMaxOccurrenceB == 2 && nbJokerB == 1))) {
    return -1;
  }
  if (!(maxOccurrenceA + nbJokerA >= 4) && ((maxOccurrenceB == 3 && secondMaxOccurrenceB == 2) || (maxOccurrenceB == 2 && secondMaxOccurrenceB == 2 && nbJokerB == 1)) && ! ((maxOccurrenceA == 3 && secondMaxOccurrenceA == 2) || (maxOccurrenceA == 2 && secondMaxOccurrenceA == 2 && nbJokerA == 1))) {
    return 1;
  }
  if (maxOccurrenceA == 3 && maxOccurrenceB == 3 && secondMaxOccurrenceB == 2 && secondMaxOccurrenceA == 2) {
    return compareFirstHighestCardInHandWithJoker(cardA, cardB);
  }

  // Two pair
  if (maxOccurrenceA == 2 && maxOccurrenceB == 2 && secondMaxOccurrenceB == 2 && secondMaxOccurrenceA == 2) {
    return compareFirstHighestCardInHandWithJoker(cardA, cardB);
  }
  if (!(maxOccurrenceA + nbJokerA >= 3) && (maxOccurrenceB == 2 && secondMaxOccurrenceB == 2 && nbJokerB == 0) && !(maxOccurrenceA == 2 && secondMaxOccurrenceA == 2 && nbJokerA == 0)) {
    return 1;
  }
  if (!(maxOccurrenceB + nbJokerB >= 3) && (maxOccurrenceA == 2 && secondMaxOccurrenceA == 2 && nbJokerA == 0) && !(maxOccurrenceB == 2 && secondMaxOccurrenceB == 2 && nbJokerB == 0)) {
    return -1;
  }

  if (nbJokerA == 5 || nbJokerB == 5) {
    if (nbJokerB == 5) {
      maxOccurrenceB = 5;
      maxOccurrenceA += nbJokerA;
    }
    if (nbJokerA == 5) {
      maxOccurrenceA = 5;
      maxOccurrenceB += nbJokerB;
    }
  } else {
    maxOccurrenceA += nbJokerA;
    maxOccurrenceB += nbJokerB;
  }

  // Most big occurrence win
  if (maxOccurrenceA != maxOccurrenceB) {
    return maxOccurrenceA > maxOccurrenceB ? -1 : 1;
  }

  return compareFirstHighestCardInHandWithJoker(cardA, cardB);
}