import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/core/services/storage_service.dart';
import 'package:sportm8s/events/map_event_widget_container.dart';

class MapEventParticipantWidget extends ConsumerStatefulWidget{

  final String displayName;
  final double profileAvatarRadius;
  final String participantID;
  final int participantIndex;

  MapEventParticipantWidget(this.displayName , this.profileAvatarRadius , this.participantID , this.participantIndex);



  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapEventParticipantWidget();
  
}

class _MapEventParticipantWidget extends ConsumerState<MapEventParticipantWidget>{

  LoggerService logger = LoggerService();

  @override
  Widget build(BuildContext context) {
    final storageServiceAsync = ref.read(storageServiceInitializerProvider);
    return storageServiceAsync.when(
        data: (storageService){
          return FutureBuilder(
              future: storageService.getOtherUserPictureURL(ref, widget.participantID),
              builder: (context , snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Row(
                      children: [
                        CircularProgressIndicator(),
                        _userDisplayNameWidget(widget.participantIndex + 1),
                      ]
                  );
                }
                if(snapshot.hasError || !snapshot.hasData){
                  return Row(
                    children: [
                      CircleAvatar(
                        child: Text("Could not load Avatar for UserID: ${widget.participantID}"),
                        radius: widget.profileAvatarRadius,
                      ),
                      _userDisplayNameWidget(widget.participantIndex + 1),
                    ]
                  );
                }

                return MapEventWidgetContainer(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 5 ,
                          top: 5,
                          right: 0,
                          bottom: 5
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data!),
                          radius: widget.profileAvatarRadius,
                        ),
                      ),
                      _userDisplayNameWidget(widget.participantIndex + 1),
                    ]
                  ),
                );
              });
        },
        error: (error, stacktrace){
          logger.error("Could not Load Storage Service in ${stacktrace} , | Error: ${error}");
          return Center(
            child: Text("Could not load Storage Service"),
          );
        },
        loading: () {
          return CircularProgressIndicator();
        }
    );
  }

  Widget _userDisplayNameWidget(int participantIndex){
    return Center(
      child: Text("$participantIndex. ${widget.displayName}") ,
    );
  }
}