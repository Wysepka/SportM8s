import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sportm8s/gen/assets.gen.dart';

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

  static SportEventType parseIntToSportEventType(int value){
    if (value < 0 || value >= SportEventType.values.length) {
      return SportEventType.Invalid;
    }
    return SportEventType.values[value];
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

  static Image getTransparentIconBasedOnSportEventType(SportEventType type , double width, double height) {
    switch (type) {
      case SportEventType.Soccer:
        return Image.asset(Assets.icons.sportIconsFixedTransparentV2.iconSoccer.path , width: width , height: height);

      case SportEventType.Basketball:
        return Image.asset(Assets.icons.sportIconsFixedTransparentV2.iconBasketball.path, width: width , height: height);

      case SportEventType.Tennis:
        return Image.asset(Assets.icons.sportIconsFixedTransparentV2.iconTennis.path, width: width , height: height);

      case SportEventType.Volleyball:
        return Image.asset(Assets.icons.sportIconsFixedTransparentV2.iconVoleyball.path, width: width , height: height);

      case SportEventType.Running:
        return Image.asset(Assets.icons.sportIconsFixedTransparentV2.iconRunning.path, width: width , height: height);

      case SportEventType.Cycling:
        return Image.asset(Assets.icons.sportIconsFixedTransparentV2.iconCycling.path, width: width , height: height);

      default:
        return Image.asset(Assets.icons.sportIconsFixedTransparentV2.iconSports.path, width: width , height: height);
    }
  }

  static String getSportNameLocalisedBasedOnSportEventType(SportEventType sportEventType){
    switch (sportEventType) {
      case SportEventType.Soccer:
        return "Soccer";

      case SportEventType.Basketball:
        return "Basketball";

      case SportEventType.Tennis:
        return "Tennis";

      case SportEventType.Volleyball:
        return "Volleyball";

      case SportEventType.Running:
        return "Running";

      case SportEventType.Cycling:
        return "Cycling";

      default:
        return "NotFound!";
    }
  }

  static Color getSportEventColor(SportEventType type) {
    switch (type) {
      case SportEventType.Soccer:
      // football pitch green
        return const Color(0xFF2E7D32); // green[800]

      case SportEventType.Volleyball:
      // bright, energetic yellow
        return const Color(0xFFFFB300); // amber[600]

      case SportEventType.Basketball:
      // classic orange ball
        return const Color(0xFFF4511E); // deepOrange[600]

      case SportEventType.Tennis:
      // tennis ball / lime-ish
        return const Color(0xFFC0CA33); // lime[600-700 vibe]

      case SportEventType.Running:
      // dynamic, fast blue
        return const Color(0xFF1E88E5); // blue[600]

      case SportEventType.Cycling:
      // fresh teal/cyan for outdoors
        return const Color(0xFF00897B); // teal[600]

      case SportEventType.Invalid:
      default:
      // fallback / unknown
        return const Color(0xFFBDBDBD); // grey[400]
    }
  }

  static Color getSportEventBackgroundColor(SportEventType type) {
    switch (type) {
      case SportEventType.Soccer:
        return const Color(0xFFE8F5E9); // very light green

      case SportEventType.Volleyball:
        return const Color(0xFFFFF8E1); // very light amber/yellow

      case SportEventType.Basketball:
        return const Color(0xFFFBE9E7); // very light orange

      case SportEventType.Tennis:
        return const Color(0xFFF0F4C3); // very light lime

      case SportEventType.Running:
        return const Color(0xFFE3F2FD); // very light blue

      case SportEventType.Cycling:
        return const Color(0xFFE0F2F1); // very light teal

      case SportEventType.Invalid:
      default:
        return const Color(0xFFF5F5F5); // near white
    }
  }

  //TODO Add localisation
  static DropdownButton<String> getSportTypeDropdownButton(Function(String?)? onChanged){
    return DropdownButton<String>(
      items: [
        DropdownMenuItem(
            value: "Soccer",
            child: Row(
              children: [
                getTransparentIconBasedOnSportEventType(SportEventType.Soccer , 10, 10),
                Text("Soccer")
              ],
            )
        ),
        DropdownMenuItem(
            value: "Volleyball",
            child: Row(
              children: [
                getTransparentIconBasedOnSportEventType(SportEventType.Volleyball , 10, 10),
                Text("Volleyball")
              ],
            )
        ),
        DropdownMenuItem(
            value: "Basketball",
            child: Row(
              children: [
                getTransparentIconBasedOnSportEventType(SportEventType.Basketball , 10, 10),
                Text("Basketball")
              ],
            )
        ),
      ], onChanged: (x) => onChanged!(x),
    );
  }
}