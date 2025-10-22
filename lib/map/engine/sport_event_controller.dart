import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sportEventController = Provider((ref){
  return SportEventController();
});

class SportEventController extends ChangeNotifier
{
  void onSportEventChanged(){
    notifyListeners();
  }
}