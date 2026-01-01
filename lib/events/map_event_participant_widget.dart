import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/core/services/storage_service.dart';

class MapEventParticipantWidget extends ConsumerStatefulWidget{

  final String displayName;
  final double profileAvatarRadius;
  final String participantID;

  MapEventParticipantWidget(this.displayName , this.profileAvatarRadius , this.participantID);



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
                        _userDisplayNameWidget(),
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
                      _userDisplayNameWidget(),
                    ]
                  );
                }

                return Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data!),
                      radius: widget.profileAvatarRadius,
                    ),
                    _userDisplayNameWidget(),
                  ]
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

  Widget _userDisplayNameWidget(){
    return Expanded(
      child: Center(
        child: Text(widget.displayName) ,
      ),
    );
  }
}