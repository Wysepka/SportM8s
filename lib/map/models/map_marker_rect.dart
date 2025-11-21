import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sportm8s/map/icon/map_icon.dart';

class MapMarkerRect{
  String iconID;
  Rect rect;
  MapIcon mapIcon;

  MapMarkerRect(this.iconID , this.rect , this.mapIcon);
}