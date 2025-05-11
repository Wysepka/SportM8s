
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/services/storage_service.dart';

import '../../../../core/logger/logger_service.dart';

class ProfilePictureWidget extends ConsumerStatefulWidget
{
  final double pictureRadius;

  const ProfilePictureWidget({
    super.key ,
    this.pictureRadius = 30,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePictureWidget();
}

final LoggerService _logger = LoggerService();

class _ProfilePictureWidget extends ConsumerState<ProfilePictureWidget>
{
  @override
  Widget build(BuildContext context) {
    final storageServiceAsync = ref.read(storageServiceInitializerProvider);
    try {
      return storageServiceAsync.when(
          data: (storageService) {
            return FutureBuilder<String>(
                future: storageService.getUserPictureURL(ref),
                builder: (context, snapshot) {
                  final pictureRadius = widget.pictureRadius;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if (snapshot.hasError || !snapshot.hasData) {
                    return Center(child: CircleAvatar(
                      radius: pictureRadius,
                      child: Text("Could not load Picture URL"),));
                  }
                  return Center(child:
                      CircleAvatar(backgroundImage:
                        NetworkImage(snapshot.data!),
                        radius: pictureRadius,
                      )
                    );
                }
            );
          },
          error: (error, stacktrace) {
          return Center(child:
          CircleAvatar(
            radius: widget.pictureRadius,
            child:
              Text("Error while loading StorageData")));
          },
          loading: () {
            return const Center(child: CircularProgressIndicator());
          }
      );
    }
    catch(e) {
      _logger.error('Error Loading Storage Service Async !: ', e);
      //return const Scaffold(body: Center(
      //    child: Text("Error while loading storageServiceAsync"))
      //);

      return const Center(
          child: Text("Error while loading storageServiceAsync"));
    }
  }
  
}