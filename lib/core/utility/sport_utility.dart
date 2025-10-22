import 'dart:math';

import '../enums/enums_container.dart';

class SportEventUtils {
  static SportEventType getTypeBasedOnRandomTitle(String sportTitle) {
    final lowerTitle = sportTitle.toLowerCase();

    if (lowerTitle.contains('football') || lowerTitle.contains('soccer')) {
      return SportEventType.Soccer;
    } else if (lowerTitle.contains('basketball')) {
      return SportEventType.Basketball;
    } else if (lowerTitle.contains('tennis')) {
      return SportEventType.Tennis;
    } else if (lowerTitle.contains('volleyball')) {
      return SportEventType.Volleyball;
    } else if (lowerTitle.contains('running') || lowerTitle.contains('marathon')) {
      return SportEventType.Running;
    } else {
      return SportEventType.Invalid;
    }
  }

  /// Generates a random pair (min, max) of participants for the given sport.
  static (int min, int max) getRandomParticipants(SportEventType type) {
    final random = Random(0);

    switch (type) {
      case SportEventType.Soccer:
        return (random.nextInt(5) + 10, random.nextInt(5) + 20); // 10–14 min, 20–24 max
      case SportEventType.Basketball:
        return (random.nextInt(3) + 5, random.nextInt(5) + 10);  // 5–7 min, 10–14 max
      case SportEventType.Tennis:
        return (2, random.nextInt(3) + 2);                       // 2 min, 2–4 max
      case SportEventType.Volleyball:
        return (random.nextInt(3) + 6, random.nextInt(5) + 10);  // 6–8 min, 10–14 max
      case SportEventType.Running:
        return (random.nextInt(10) + 10, random.nextInt(50) + 30); // 10–19 min, 30–79 max
      case SportEventType.Cycling:
        return (random.nextInt(1) + 1, random.nextInt(50) + 30); // 1-2 min, 30–79 max
      case SportEventType.Invalid:
        return (random.nextInt(2) + 2, random.nextInt(20) + 5);   // 2–3 min, 5–24 max
    }
  }
}