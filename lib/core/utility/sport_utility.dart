import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sportm8s/gen/assets.gen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../graphics/sportm8s_themes.dart';
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
    } else if (lowerTitle.contains('climbing') && lowerTitle.contains("bouldering")) {
      return SportEventType.ClimbingBouldering;
    } else if (lowerTitle.contains('climbing') && lowerTitle.contains("leading")) {
      return SportEventType.ClimbingLeading;
    } else if (lowerTitle.contains('climbing') && lowerTitle.contains("toprope")) {
      return SportEventType.ClimbingTopRope;
    } else if (lowerTitle.contains('skiing') && lowerTitle.contains("crosscountry")) {
      return SportEventType.ClimbingTopRope;
    } else if (lowerTitle.contains('other')) {
      return SportEventType.Other;
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
      case SportEventType.ClimbingBouldering:
        return (random.nextInt(2) + 1, random.nextInt(20) + 10);   // 2–3 min, 5–24 max
      case SportEventType.ClimbingLeading:
        return (random.nextInt(1) + 1, random.nextInt(1) + 1);   // 1 min, 2 max
      case SportEventType.ClimbingTopRope:
        return (random.nextInt(1) + 1, random.nextInt(1) + 1);   // 1 min, 2 max
      case SportEventType.CrossCountrySkiing:
        return (random.nextInt(2) + 2, random.nextInt(20) + 5);   // 2–3 min, 5–24 max
      case SportEventType.Other:
        return (random.nextInt(1) + 1, random.nextInt(50) + 30); // 1-2 min, 30–79 max
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

      case SportEventType.ClimbingBouldering:
        return Image.asset(Assets.icons.sportIconsFixedTransparentV2.iconSportClimbingBouldering.path , width: width, height: height,);

      case SportEventType.ClimbingLeading:
        return Image.asset(Assets.icons.sportIconsFixedTransparentV2.iconSportClimbingLeading.path , width: width, height: height,);

      case SportEventType.ClimbingTopRope:
        return Image.asset(Assets.icons.sportIconsFixedTransparentV2.iconSportClimbingTopRope.path , width: width, height: height,);

      case SportEventType.CrossCountrySkiing:
        return Image.asset(Assets.icons.sportIconsFixedTransparentV2.iconSportSkiingCrossCountry.path , width: width, height: height,);

      case SportEventType.Other:
        return Image.asset(Assets.icons.sportIconsFixedTransparentV2.iconSportOther.path , width: width, height: height,);

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

      case SportEventType.ClimbingBouldering:
        return "Climbing Bouldering";

      case SportEventType.ClimbingLeading:
        return "Climbing Leading";

      case SportEventType.ClimbingTopRope:
        return "Climbing Top Rope";

      case SportEventType.CrossCountrySkiing:
        return "Cross-Country Skiing";

      case SportEventType.Other:
        return "Other";

      default:
        return "NotFound!";
    }
  }

  static Color getSportEventColor(SportEventType type) {
    switch (type) {
      case SportEventType.Soccer:
        return const Color(0xFF2E7D32);

      case SportEventType.Volleyball:
        return const Color(0xFFFFB300);

      case SportEventType.Basketball:
        return const Color(0xFFF4511E);

      case SportEventType.Tennis:
        return const Color(0xFFC0CA33);

      case SportEventType.Running:
        return const Color(0xFF1E88E5);

      case SportEventType.Cycling:
        return const Color(0xFF00897B);

    // Give each climbing type its own “sporty” accent:
      case SportEventType.ClimbingBouldering:
        return const Color(0xFFFF7043); // warm chalk/rock

      case SportEventType.ClimbingLeading:
        return const Color(0xFF7E57C2); // rope/purple

      case SportEventType.ClimbingTopRope:
        return const Color(0xFF26A69A); // teal

      case SportEventType.CrossCountrySkiing:
        return const Color(0xFF90CAF9); // icy blue

      case SportEventType.Other:
        return Colors.white;

      case SportEventType.Invalid:
      default:
        return const Color(0xFFBDBDBD);
    }
  }

  static Color getSportEventBackgroundColor({required SportEventType type}) {
    final accent = getSportEventColor(type);

    // Light neutral base that works with black text
    const base = Color(0xFFF7F9FC);

    // Tint lightly with sport color
    return Color.alphaBlend(
      accent.withOpacity(0.20),
      base,
    );
  }

  //TODO Add localisation
  static DropdownButton<String> getSportTypeDropdownButton_CreateEvent(Function(String?)? onChanged , String Function() getValue , double iconSize , FocusNode focusNode , BuildContext context , {bool isExpanded = false}){
    final l10n = AppLocalizations.of(context);
    return DropdownButton<String>(
      focusNode: focusNode,
      value: getValue(),
      alignment: Alignment.center,
      items: getSportEventDropdownButtons_CreateEvent(context , iconSize),
      onChanged: (x) => onChanged!(x),
    );
  }

  static DropdownButton<String> getSportTypeDropdownButton_Sorter(Function(String?)? onChanged , String Function() getValue , double iconSize , FocusNode focusNode , BuildContext context){
    final l10n = AppLocalizations.of(context);
    return DropdownButton<String>(
      focusNode: focusNode,
      isExpanded: true,
      value: getValue(),
      alignment: Alignment.center,
      items: getSportEventDropdownButtons_Sorter(context , iconSize),
      onChanged: (x) => onChanged!(x),
    );
  }

  static List<DropdownMenuItem<String>> getSportEventDropdownButtons_Sorter(BuildContext context, double iconSize){
    final l10n = AppLocalizations.of(context);

    TextStyle? textStyleDefault = Theme.of(context).textTheme.labelSmall;
    TextStyle? textStyleOption = Theme.of(context).textTheme.labelSmall;

    List<DropdownMenuItem<String>> buttons =
    [
      DropdownMenuItem(
        value: "All",
        child: Text(l10n?.sportEventType_Dropdown_AllSports ?? "Sport Type" ,style: textStyleDefault),
      ),
    ];

    buttons.addAll(getSportEventDropdownButtons_Base(context, iconSize , textStyleOption , true , TextOverflow.fade));

    return buttons;
  }

  static List<DropdownMenuItem<String>> getSportEventDropdownButtons_CreateEvent(BuildContext context, double iconSize){
    final l10n = AppLocalizations.of(context);

    TextStyle? textStyleDefault = Theme.of(context).textTheme.labelSmall;
    TextStyle? textStyleOption = Theme.of(context).textTheme.labelMedium;

    List<DropdownMenuItem<String>> buttons =
    [
      DropdownMenuItem(
        value: "Invalid",
        child: Text(l10n?.sportEventType_Dropdown_SelectSport ?? "Select sport"),
      ),
    ];

    buttons.addAll(getSportEventDropdownButtons_Base(context, iconSize , textStyleOption , false , TextOverflow.visible));

    return buttons;
  }

  static List<DropdownMenuItem<String>> getSportEventDropdownButtons_Base(BuildContext context, double iconSize , TextStyle? textStyle , bool shortLocName , TextOverflow textOverflow){
    final l10n = AppLocalizations.of(context);

    List<DropdownMenuItem<String>> buttons =
    [
      DropdownMenuItem(
          value: "Soccer",
          child: Row(
            children: [
              getTransparentIconBasedOnSportEventType(SportEventType.Soccer , iconSize, iconSize),
              Text(
                  shortLocName ? l10n?.sportEventType_Name_Short_Soccer ?? "Soccer" : l10n?.sportEventType_Name_Soccer ?? "Soccer" ,
                  style: textStyle,
                  overflow: textOverflow,
              )
            ],
          )
      ),
      DropdownMenuItem(
          value: "Volleyball",
          child: Row(
            children: [
              getTransparentIconBasedOnSportEventType(SportEventType.Volleyball , iconSize, iconSize),
              Text(
                  shortLocName ? l10n?.sportEventType_Name_Short_Volleyball ?? "Volleyball" : l10n?.sportEventType_Name_Volleyball ?? "Volleyball" ,
                  style: textStyle,
                  overflow: textOverflow,
              )
            ],
          )
      ),
      DropdownMenuItem(
          value: "Basketball",
          child: Row(
            children: [
              getTransparentIconBasedOnSportEventType(SportEventType.Basketball , iconSize, iconSize),
              Text(
                  shortLocName ? l10n?.sportEventType_Name_Short_Basketball ?? "Basketball" : l10n?.sportEventType_Name_Basketball ?? "Basketball" ,
                  style: textStyle,
                  overflow: textOverflow,
              )
            ],
          )
      ),
      DropdownMenuItem(
          value: "Tennis",
          child: Row(
            children: [
              getTransparentIconBasedOnSportEventType(SportEventType.Tennis , iconSize, iconSize),
              Text(
                  shortLocName ? l10n?.sportEventType_Name_Short_Tennis ?? "Tennis" : l10n?.sportEventType_Name_Tennis ?? "Tennis" ,
                  style: textStyle,
                  overflow: textOverflow,
              )
            ],
          )
      ),
      DropdownMenuItem(
          value: "Running",
          child: Row(
            children: [
              getTransparentIconBasedOnSportEventType(SportEventType.Running , iconSize, iconSize),
              Text(
                  shortLocName ? l10n?.sportEventType_Name_Short_Running ?? "Bieganie" : l10n?.sportEventType_Name_Running ?? "Running" ,
                  style: textStyle,
                  overflow: textOverflow,
              )
            ],
          )
      ),
      DropdownMenuItem(
          value: "Cycling",
          child: Row(
            children: [
              getTransparentIconBasedOnSportEventType(SportEventType.Cycling, iconSize, iconSize),
              Text(
                  shortLocName ? l10n?.sportEventType_Name_Short_Cycling ?? "Rower" : l10n?.sportEventType_Name_Cycling ?? "Cycling" ,
                  style: textStyle,
                  overflow: textOverflow,
              )
            ],
          )
      ),
      DropdownMenuItem(
          value: "ClimbingBouldering",
          child: Row(
            children: [
              getTransparentIconBasedOnSportEventType(SportEventType.ClimbingBouldering, iconSize, iconSize),
              Text(
                  shortLocName ? l10n?.sportEventType_Name_Short_Climbing_Bouldering ?? "Bouldering" : l10n?.sportEventType_Name_Climbing_Bouldering ?? "Climbing Bouldering" ,
                  style: textStyle,
                  overflow: textOverflow,
              )
            ],
          )
      ),
      DropdownMenuItem(
          value: "ClimbingLeading",
          child: Row(
            children: [
              getTransparentIconBasedOnSportEventType(SportEventType.ClimbingLeading, iconSize, iconSize),
              Text(
                  shortLocName ? l10n?.sportEventType_Name_Short_Climbing_Leading ?? "Leading" : l10n?.sportEventType_Name_Climbing_Leading ?? "Climbing Leading" ,
                  style: textStyle,
                  overflow: textOverflow,
              )
            ],
          )
      ),
      DropdownMenuItem(
          value: "ClimbingTopRope",
          child: Row(
            children: [
              getTransparentIconBasedOnSportEventType(SportEventType.ClimbingTopRope, iconSize, iconSize),
              Text(
                  shortLocName ? l10n?.sportEventType_Name_Short_Climbing_TopRope ?? "Top Rope" : l10n?.sportEventType_Name_Climbing_TopRope ?? "Climbing Top Rope" ,
                  style: textStyle,
                  overflow: textOverflow,
              )
            ],
          )
      ),
      DropdownMenuItem(
          value: "CrossCountrySkiing",
          child: Row(
            children: [
              getTransparentIconBasedOnSportEventType(SportEventType.CrossCountrySkiing, iconSize, iconSize),
              Text(
                  shortLocName ? l10n?.sportEventType_Name_Short_CrossCountrySkiing ?? "Skiing" : l10n?.sportEventType_Name_CrossCountrySkiing ?? "Cross-Country Skiing" ,
                  style: textStyle,
                  overflow: textOverflow,
              )
            ],
          )
      ),
      DropdownMenuItem(
          value: "Other",
          child: Row(
            children: [
              getTransparentIconBasedOnSportEventType(SportEventType.Other, iconSize, iconSize),
              Text(
                  shortLocName ? l10n?.sportEventType_Name_Short_Other ?? "Other" : l10n?.sportEventType_Name_Other ?? "Cross-Country Skiing" ,
                  style: textStyle,
                  overflow: textOverflow,)
            ],
          )
      ),
    ];

    return buttons;
  }

  static String getSportEventTypeToLocValue(SportEventType sportEventType , AppLocalizations? l10n){
    switch(sportEventType){
      case SportEventType.Invalid:
        return l10n?.sportEventType_Name_Other ?? "Other";
      case SportEventType.Soccer:
        return l10n?.sportEventType_Name_Soccer ?? "Soccer";
      case SportEventType.Volleyball:
        return l10n?.sportEventType_Name_Volleyball ?? "Volleyball";
      case SportEventType.Basketball:
        return l10n?.sportEventType_Name_Basketball ?? "Basketball";
      case SportEventType.Tennis:
        return l10n?.sportEventType_Name_Tennis ?? "Tennis";
      case SportEventType.Running:
        return l10n?.sportEventType_Name_Running ?? "Running";
      case SportEventType.Cycling:
        return l10n?.sportEventType_Name_Cycling ?? "Cycling";
      case SportEventType.ClimbingBouldering:
        return l10n?.sportEventType_Name_Climbing_Bouldering ?? "ClimbingBouldering";
      case SportEventType.ClimbingLeading:
        return l10n?.sportEventType_Name_Climbing_Leading ?? "ClimbingLeading";
      case SportEventType.ClimbingTopRope:
        return l10n?.sportEventType_Name_Climbing_TopRope ?? "ClimbingTopRope";
      case SportEventType.CrossCountrySkiing:
        return l10n?.sportEventType_Name_CrossCountrySkiing ?? "CrossCountrySkiing";
      case SportEventType.Other:
        return l10n?.sportEventType_Name_Other ?? "Other";
    }
  }

  static String getSportEventTypeToShortLocValue(
      SportEventType sportEventType,
      AppLocalizations? l10n,
      ) {
    switch (sportEventType) {
      case SportEventType.Invalid:
        return l10n?.sportEventType_Name_Short_Other ?? "Other";
      case SportEventType.Soccer:
        return l10n?.sportEventType_Name_Short_Soccer ?? "Soccer";
      case SportEventType.Volleyball:
        return l10n?.sportEventType_Name_Short_Volleyball ?? "Volleyball";
      case SportEventType.Basketball:
        return l10n?.sportEventType_Name_Short_Basketball ?? "Basketball";
      case SportEventType.Tennis:
        return l10n?.sportEventType_Name_Short_Tennis ?? "Tennis";
      case SportEventType.Running:
        return l10n?.sportEventType_Name_Short_Running ?? "Running";
      case SportEventType.Cycling:
        return l10n?.sportEventType_Name_Short_Cycling ?? "Cycling";
      case SportEventType.ClimbingBouldering:
        return l10n?.sportEventType_Name_Short_Climbing_Bouldering ?? "Bouldering";
      case SportEventType.ClimbingLeading:
        return l10n?.sportEventType_Name_Short_Climbing_Leading ?? "Rope Leading";
      case SportEventType.ClimbingTopRope:
        return l10n?.sportEventType_Name_Short_Climbing_TopRope ?? "Top Rope";
      case SportEventType.CrossCountrySkiing:
        return l10n?.sportEventType_Name_Short_CrossCountrySkiing ?? "Skiing";
      case SportEventType.Other:
        return l10n?.sportEventType_Name_Short_Other ?? "Other";
    }
  }
}