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
  List<List<int>> sequences = [];
  for (final line in lines) {
    sequences.add(line.split(' ').map((e) => int.parse(e)).toList());
  }

  for (final sequence in sequences) {
    List<int> currentSequence = sequence;
    final allSequencesForLine = [currentSequence];
    bool allZeros = false;
    List<int> sequenceBuffer = [];
    while (allZeros == false) {
      allZeros = true;
      sequenceBuffer = [];
      for (int index = 0 ; index < currentSequence.length - 1; index ++) {
        int difference = currentSequence[index + 1] - currentSequence[index];
        if (difference != 0) {
          allZeros = false;
        }
        sequenceBuffer.add(difference);
      }
      allSequencesForLine.add(sequenceBuffer);
      currentSequence = sequenceBuffer;
    }
    sum += allSequencesForLine.map((e) => e.last).toList().reduce((a, b) => a + b);
  }

  print('Part One: $sum');
}

void partTwo(List<String> lines) {
  int sum = 0;
  List<List<int>> sequences = [];
  for (final line in lines) {
    sequences.add(line.split(' ').map((e) => int.parse(e)).toList());
  }

  for (final sequence in sequences) {
    List<int> currentSequence = sequence;
    final allSequencesForLine = [currentSequence];
    bool allZeros = false;
    List<int> sequenceBuffer = [];
    while (allZeros == false) {
      allZeros = true;
      sequenceBuffer = [];
      for (int index = 0 ; index < currentSequence.length - 1; index ++) {
        int difference = currentSequence[index + 1] - currentSequence[index];
        if (difference != 0) {
          allZeros = false;
        }
        sequenceBuffer.add(difference);
      }
      allSequencesForLine.add(sequenceBuffer);
      currentSequence = sequenceBuffer;
    }
    final firstCharsForEachSequences = allSequencesForLine.map((e) => e.first).toList().reversed.toList();
    int buffer = 0;
    for (int index = 0 ; index < firstCharsForEachSequences.length - 1 ; index++) {
      buffer = firstCharsForEachSequences[index + 1] - buffer;
    }
    sum += buffer;
  }

  print('Part Two: $sum');}