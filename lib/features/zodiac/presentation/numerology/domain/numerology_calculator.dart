import 'package:daily_tarot_focus/features/zodiac/presentation/numerology/domain/numerology_result_model.dart';

abstract class NumerologyCalculator {
  static const Set<int> masterNumbers = {11, 22, 33};

  static const Map<String, int> _pythagorean = {
    'A': 1, 'J': 1, 'S': 1,
    'B': 2, 'K': 2, 'T': 2,
    'C': 3, 'L': 3, 'U': 3,
    'D': 4, 'M': 4, 'V': 4,
    'E': 5, 'N': 5, 'W': 5,
    'F': 6, 'O': 6, 'X': 6,
    'G': 7, 'P': 7, 'Y': 7,
    'H': 8, 'Q': 8, 'Z': 8,
    'I': 9, 'R': 9,
    // Turkish letters
    'Ç': 3, 'Ğ': 7, 'İ': 9, 'Ö': 6, 'Ş': 1, 'Ü': 3,
  };

  static const Set<String> _vowels = {'A', 'E', 'I', 'İ', 'O', 'Ö', 'U', 'Ü'};

  /// Iteratively sums digits until the result is a single digit, preserving
  /// master numbers (11, 22, 33) at any step.
  static int reduce(int input) {
    var n = input.abs();
    while (n > 9 && !masterNumbers.contains(n)) {
      var sum = 0;
      while (n > 0) {
        sum += n % 10;
        n ~/= 10;
      }
      n = sum;
    }
    return n;
  }

  /// Reduces month/day/year separately so that an inner master number
  /// (e.g. month=11) is preserved before the final sum, then reduces once more.
  static int lifePath(DateTime birth) {
    final m = reduce(birth.month);
    final d = reduce(birth.day);
    final y = reduce(birth.year);
    return reduce(m + d + y);
  }

  static int birthdayNumber(int day) => reduce(day);

  /// All letters in the full name (Pythagorean).
  static int destiny(String fullName) {
    final sum = fullName.toUpperCase().split('').fold<int>(
      0,
      (acc, c) => acc + (_pythagorean[c] ?? 0),
    );
    return reduce(sum);
  }

  /// Only vowels in the full name.
  static int soulUrge(String fullName) {
    final sum = fullName.toUpperCase().split('').fold<int>(
      0,
      (acc, c) => _vowels.contains(c) ? acc + (_pythagorean[c] ?? 0) : acc,
    );
    return reduce(sum);
  }

  /// Only consonants in the full name.
  static int personality(String fullName) {
    final sum = fullName.toUpperCase().split('').fold<int>(
      0,
      (acc, c) =>
          (_pythagorean.containsKey(c) && !_vowels.contains(c)) ? acc + _pythagorean[c]! : acc,
    );
    return reduce(sum);
  }

  /// Life Path + Destiny.
  static int maturity(int lifePathNum, int destinyNum) => reduce(lifePathNum + destinyNum);

  static NumerologyResultModel compute(DateTime birth, String fullName) {
    final lp = lifePath(birth);
    final dst = destiny(fullName);
    return NumerologyResultModel(
      birthDate: birth,
      fullName: fullName,
      lifePath: lp,
      birthday: birthdayNumber(birth.day),
      destiny: dst,
      soulUrge: soulUrge(fullName),
      personality: personality(fullName),
      maturity: maturity(lp, dst),
    );
  }
}
