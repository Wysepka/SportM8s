import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sportm8s/calendar/container/CalendarStaticValues.dart';
import 'package:sportm8s/calendar/widgets/calendar_overlapping_avatars.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/core/utility/location_utility.dart';
import 'package:sportm8s/core/utility/sport_utility.dart';
import 'package:sportm8s/core/utility/time_utility.dart';
import 'package:sportm8s/graphics/sportm8s_themes.dart';
import 'package:sportm8s/map/models/map_sport_event_marker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';

class CalendarEventsTile extends StatefulWidget{
  final Function(CalendarEventsTile) calendarEventsTileClicked;
  final MapSportEventData mapSportEventData;

  const CalendarEventsTile(this.calendarEventsTileClicked,this.mapSportEventData, {super.key});

  @override
  State<StatefulWidget> createState() => _CalendarEventsTile();

}

class _CalendarEventsTile extends State<CalendarEventsTile>{
  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context);

    return Card(
      child: GestureDetector(
        onTap: onTileTapped,
        child: Column(
          children: [
            getTileTopBarWidget(l10n),
            SizedBox(height: 4,),
            FutureBuilder<Widget>(
              future: getTileMiddlePanelWidget(),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(),
                  );
                }

                if(snapshot.hasError){
                  return SizedBox(
                      height: 10,
                      child: Text("Err")
                  );
                }

                if(!snapshot.hasData){
                  return SizedBox(
                      height: 10,
                      child: Text("NoData")
                  );
                }

                return snapshot.data!;
              }
            ),
            Spacer(),
            getTileBottomPanelWidget(),
          ],
        ),
      ),
    );
  }

  void onTileTapped(){
    widget.calendarEventsTileClicked(widget);
  }

  Widget getTileTopBarWidget(AppLocalizations? appLocalisations){
    return Row(
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Container(
                width: CalendarStaticValues.eventTileSportIconSize,
                height: CalendarStaticValues.eventTileSportIconSize,
                decoration: BoxDecoration(
                  color: SportEventUtils.getSportEventBackgroundColor(type: widget.mapSportEventData.eventData.sportEventType),
                  borderRadius: BorderRadius.circular(7)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: SportEventUtils.getTransparentIconBasedOnSportEventType(widget.mapSportEventData.eventData.sportEventType, CalendarStaticValues.eventTileSportIconSize * 0.8, CalendarStaticValues.eventTileSportIconSize * 0.8),
                )
            )
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(4, 10, 4, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  SportEventUtils.getSportEventTypeToShortLocValue(widget.mapSportEventData.eventData.sportEventType, appLocalisations) ,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: true,
                ),
                //SizedBox(height: 2,),
                Text(
                    widget.mapSportEventData.eventData.eventName ,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    softWrap: true,
                ),
              ],
            ),
          ),
        ),
        //Spacer(),
        Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              color: SportM8sColors.tertiaryContainer,
            ),
            child:
              Row(
                children: [
                  SizedBox(width: 2,),
                  Icon(Icons.location_on ,size: 10,),
                  SizedBox(width: 2,),
                  FutureBuilder<String>(
                    future: getDistanceInKilometersStringToEvent(),
                    builder: (context , snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(),
                        );
                      }

                      if(snapshot.hasError){
                        return Text("Err");
                      }

                      if(!snapshot.hasData){
                        return Text("NoData");
                      }

                      return Text(snapshot.data! , style: Theme.of(context).textTheme.bodySmall,);
                    }
                  ),
                  SizedBox(width: 2,),
                ],
              ),
          ),
        )
      ],
    );
  }

  Future<Widget> getTileMiddlePanelWidget() async {

    String timeLocationFormated = TimeUtility.getRelativeDayLabel(widget.mapSportEventData.eventData.eventStartDate);
    timeLocationFormated += " ${TimeUtility.formatHourMinute(widget.mapSportEventData.eventData.eventStartDate)}";
    String locationShortname = await LocationUtility.getShortPlaceNameFromLatLng(widget.mapSportEventData.eventData.position);
    timeLocationFormated += " $locationShortname";

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_month , size: CalendarStaticValues.eventTileCalendarIconSize),
              Expanded(
                child: Text(
                  timeLocationFormated ,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 8),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            ],
          ),
          SizedBox(height: 2,),
          Text(widget.mapSportEventData.eventData.eventDescription)
        ],
      ),
    );
  }

  Widget getTileBottomPanelWidget(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CalendarOverlappingAvatars(
        participants: widget.mapSportEventData.eventData.participantsIDs.values.toList(),
        imageUrls: [
          'https://i.pravatar.cc/100?img=1',
          'https://i.pravatar.cc/100?img=2',
          'https://i.pravatar.cc/100?img=3',
        ],
        currentCount: widget.mapSportEventData.eventData.capacity.currentParticipants,
        maxCount: widget.mapSportEventData.eventData.capacity.maxParticipants,
      ),
    );
  }

  Future<String> getDistanceInKilometersStringToEvent() async {
    final currentPosition = await LocationUtility.loadCurrentUserLocation(LoggerService() , LatLng(52, 11));
    return LocationUtility.getDistanceKmText(currentPosition, widget.mapSportEventData.eventData.position);
  }
}