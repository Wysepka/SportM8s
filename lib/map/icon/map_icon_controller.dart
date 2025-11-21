import 'package:flutter/widgets.dart';

class MapIconController extends ChangeNotifier{
  bool _isColliding = false;

  bool get isColliding => _isColliding;

  void setColliding(bool value) {
    if(value != _isColliding) {
      _isColliding = value;
      notifyListeners();
    }
  }

  void recalculateRects(){
    notifyListeners();
  }
}