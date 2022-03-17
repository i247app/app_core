import 'dart:math';

abstract class KGameHelper {
  static List<String> generateRandomCharacters(
      String wordInclueded, int maxNumber) {
    const alphabet = [
      'B',
      'C',
      'D',
      'F',
      'G',
      'H',
      'J',
      'K',
      'L',
      'M',
      'N',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'V',
      'W',
      'X',
      'Y',
      'Z'
    ];
    final randomCharacters = <String>['A', 'E', 'I', 'O', 'U'];
    final random = Random();
    final wordIncluededSet = Set.from(wordInclueded.toUpperCase().split(''));
    wordIncluededSet.forEach((element) {
      if (!randomCharacters.contains(element)) {
        randomCharacters.add(element);
      }
    });

    while (randomCharacters.length < maxNumber) {
      final randomCharacter = alphabet[random.nextInt(alphabet.length)];
      if (!randomCharacters.contains(randomCharacter)) {
        randomCharacters.add(randomCharacter);
      }
    }
    randomCharacters.shuffle();
    return randomCharacters;
  }
}
