import 'dart:math';

abstract class KGameHelper {
  static List<String> generateRandomCharacters(
      String wordInclueded, int maxNumber, bool isUnique) {
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
    final vowelCharacters = <String>['A', 'E', 'I', 'O', 'U'];
    final randomCharacters = isUnique ? Set<String>.from(wordInclueded.toUpperCase().split('')).toList() : wordInclueded.toUpperCase().split('').toList();
    final random = Random();
    vowelCharacters.forEach((element) {
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
