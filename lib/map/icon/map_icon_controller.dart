import 'package:flutter/widgets.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/map/map_root_screen.dart';

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