import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/map/models/map_event_data.dart';
import 'package:sportm8s/services/server_user_service.dart';

import '../../graphics/sportm8s_themes.dart';

class CalendarOverlappingAvatars extends StatelessWidget {
  final List<String> imageUrls;
  final int currentCount;
  final int maxCount;
  final List<Participant> participants;

  const CalendarOverlappingAvatars({
    super.key,
    required this.imageUrls,
    required this.currentCount,
    required this.maxCount,
    required this.participants
  });

  int visibleParticipantsAvatars(int participantsCount){
    if(participantsCount > 5){
      return 5;
    }
    else{
      return participantsCount;
    }
  }

  @override
  Widget build(BuildContext context) {
    const double avatarSize = 28;
    const double overlapOffset = 16;

    final int visibleCount = imageUrls.length;
    final double avatarsWidth =
    visibleCount > 0 ? avatarSize + (visibleCount - 1) * overlapOffset : 0;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: avatarsWidth,
          height: avatarSize,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (int i = 0; i < visibleParticipantsAvatars(participants.length); i++)
                Positioned(
                  left: i * overlapOffset,
                  child: Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Consumer(
                      builder: (BuildContext context, WidgetRef ref, Widget? child) {
                        final serverUserService = ref.read(serverUserServiceProvider);
                        return FutureBuilder<String>(
                          future: serverUserService.getOtherUserProfileURL(participants[i].participantID),
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot){
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
                                child: Text("Err"),
                              );
                            }
                            
                            if(!snapshot.hasData){
                              return Center(
                                child: Text("NoData"),
                              );
                            }

                            return CircleAvatar(
                              radius: avatarSize / 2,
                              backgroundImage: NetworkImage(snapshot.data!),
                            );
                          }
                        );
                      },//child:
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: SportM8sColors.tertiaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$currentCount / $maxCount',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: SportM8sColors.accent
            ),
          ),
        ),
      ],
    );
  }
}