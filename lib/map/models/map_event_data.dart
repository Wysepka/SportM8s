import 'package:latlong2/latlong.dart';

import '../../core/enums/enums_container.dart';

class MapEventData
{
  final String eventName;
  final String eventDescription;
  final SportEventType sportEventType;
  final LatLng position;
  final int maxParticipants;
  final int currentParticipants;

  const MapEventData(this.eventName, this.eventDescription , this.sportEventType, this.position ,
      this.maxParticipants , this.currentParticipants);
}