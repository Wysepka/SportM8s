import 'package:flutter/cupertino.dart';

import '../../core/enums/enums_container.dart';

class MapViewBottomPanelController extends ChangeNotifier{
  MapViewBottomPanelType bottomPanelType = MapViewBottomPanelType.CreatingEvent;

  void changeBottomPanelType(MapViewBottomPanelType type)
  {
    if(type != bottomPanelType) {
      bottomPanelType = type;
      notifyListeners();
    }
  }

}