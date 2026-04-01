import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/calendar/widgets/calendar_events_tile.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/utility/event_utility.dart';
import 'package:sportm8s/core/utility/time_utility.dart';
import 'package:sportm8s/map/engine/sport_event_repository.dart';
import 'package:sportm8s/map/models/map_event_data.dart';
import 'package:sportm8s/services/server_user_service.dart';

import '../../map/models/map_sport_event_marker.dart';

class CalendarEventsGrid extends ConsumerStatefulWidget{

  final MainSportEventRepository mainSportEventRepository;
  final Function(CalendarEventsTile) calendarEventsTileClicked;

  const CalendarEventsGrid(this.mainSportEventRepository,this.calendarEventsTileClicked, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalendarEventsGrid();
}

class _CalendarEventsGrid extends ConsumerState<CalendarEventsGrid>{
  @override
  Widget build(BuildContext context) {
    final serverUserService = ref.watch(serverUserServiceProvider);

    List<MapSportEventData> eventDatas = widget.mainSportEventRepository.getMapSportEventDatas();
    List<EventDateTimeContainer> sortedEventDatasByDate = EventUtility.sortMapEventDatasByDay(eventDatas);

    return FutureBuilder(
      future: serverUserService.getUserID(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(),
            ),
          );
        }

        if(snapshot.hasError){
          return Center(
            child: Text("Error ${snapshot.error!}"),
          );
        }

        if(!snapshot.hasData){
          return Center(
            child: Text("Could not fetch data"),
          );
        }

        String userID = snapshot.data!;

        List<EventDateTimeContainer> pastParticipatedEvents = EventUtility.getEventDateTimeContainerWithUserID(sortedEventDatasByDate, userID, EventDataTimeType.Past);
        List<EventDateTimeContainer> upcomingParticipatingEvents = EventUtility.getEventDateTimeContainerWithUserID(sortedEventDatasByDate, userID , EventDataTimeType.Upcoming);
        List<EventDateTimeContainer> upcomingNonParticipatingEvents = sortedEventDatasByDate.where((x) => !upcomingParticipatingEvents.contains(x)).
                                                                      where((y) => y.eventDataTimeType == EventDataTimeType.Upcoming).toList();

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Past Participated Events", style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(),
              ),
            ),
            if(pastParticipatedEvents.isNotEmpty)... {
              for(int i = 0; i < pastParticipatedEvents.length; i++)...{
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(TimeUtility.getRelativeDayLabel(
                            pastParticipatedEvents[i].eventDateTime))
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                          CalendarEventsTile(
                              widget.calendarEventsTileClicked,
                              pastParticipatedEvents[i].mapEventData[index]),
                      childCount: pastParticipatedEvents[i].mapEventData.length,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Divider(),
                  ),
                ),
              },
            } else...{
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text("Past events participations not found"),
                ),
              )
            },
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Participating Events", style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(),
              ),
            ),
            if(upcomingParticipatingEvents.isNotEmpty)...{
              for(int i = 0; i < upcomingParticipatingEvents.length; i++)...{
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(TimeUtility.getRelativeDayLabel(
                            upcomingParticipatingEvents[i].eventDateTime))
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                          CalendarEventsTile(
                              widget.calendarEventsTileClicked,
                              upcomingParticipatingEvents[i]
                                  .mapEventData[index]),
                      childCount: upcomingParticipatingEvents[i].mapEventData
                          .length,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Divider(),
                  ),
                ),
              },
            } else...{
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text("Upcoming event participations not found"),
                ),
              )
            },
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Upcoming Events", style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(),
              ),
            ),
            if(upcomingNonParticipatingEvents.isNotEmpty)...{
              for(int i = 0; i < upcomingNonParticipatingEvents.length; i++)...{
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text(TimeUtility.getRelativeDayLabel(
                                upcomingNonParticipatingEvents[i]
                                    .eventDateTime))
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                          CalendarEventsTile(
                            widget.calendarEventsTileClicked,
                            upcomingNonParticipatingEvents[i]
                                .mapEventData[index],
                          ),
                      childCount: upcomingNonParticipatingEvents[i].mapEventData
                          .length,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Divider(),
                  ),
                ),
              },
            }
            else...{
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text("Upcoming events not found"),
                ),
              )
            },
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(),
              ),
            ),
          ],
        );
      }
    );

    /*
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8
        ),
        itemCount: eventDatas.length,
        itemBuilder: (context, index) {
          return CalendarEventsTile(widget.calendarEventsTileClicked , eventDatas[index]);
        }
    );

     */
  }

}