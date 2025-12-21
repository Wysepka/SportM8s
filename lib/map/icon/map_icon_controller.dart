import 'package:flutter/widgets.dart';

class MapIconController extends ChangeNotifier{
  bool _isColliding = false;
  bool _isRendered = false;

  bool get isColliding => _isColliding;
  bool get isRendered => _isRendered;

  void setColliding(bool value) {
    if(value != _isColliding) {
      _isColliding = value;
      notifyListeners();
    }
  }

  void setRendered(bool value){
    if(value != _isRendered){
      _isRendered = value;
      notifyListeners();
    }
  }

  void recalculateRects(){
    notifyListeners();
  }
}