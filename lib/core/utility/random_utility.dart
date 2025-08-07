import 'dart:math';

class RandomUtility{

  static final Random _random = Random();
  /// Generates a random integer between [min] (inclusive) and [max] (inclusive).
  ///
  /// Example:
  /// ```dart
  /// final value = RandomUtils.randomInt(1, 10);
  /// print(value); // e.g. 7
  /// ```
  static int randomInt(int min, int max) {
    assert(min <= max, 'min should be <= max');
    return min + _random.nextInt(max - min + 1);
  }

  /// Generates a random string of length between [minLength] and [maxLength].
  /// Uses alphanumeric characters (both upper- and lower-case) by default.
  ///
  /// Example:
  /// ```dart
  /// final str = RandomUtils.randomString(5, 12);
  /// print(str); // e.g. "aZ3fT9"
  /// ```
  static String randomString(int minLength, int maxLength) {
    assert(minLength >= 0 && maxLength >= minLength,
    'minLength should be >= 0 and <= maxLength');

    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        'abcdefghijklmnopqrstuvwxyz'
        '0123456789';

    final length = randomInt(minLength, maxLength);
    return List.generate(length, (_) => _chars[_random.nextInt(_chars.length)])
        .join();
  }
}