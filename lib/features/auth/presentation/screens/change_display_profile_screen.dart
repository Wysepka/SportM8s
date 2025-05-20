
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/core/services/storage_service.dart';
import 'package:sportm8s/features/auth/presentation/widgets/profile_picture_widget.dart';
import "package:sportm8s/core/enums/enums_container.dart";
import 'package:sportm8s/services/server_user_service.dart';

class ChangeDisplayProfileScreen extends ConsumerStatefulWidget
{
  const ChangeDisplayProfileScreen({super.key});

  @override
  ConsumerState<ChangeDisplayProfileScreen> createState() => _ChangeDisplayProfileScreen();

}

class _ChangeDisplayProfileScreen extends ConsumerState<ChangeDisplayProfileScreen> {
  final LoggerService _logger = LoggerService();
  late final StorageService _serverUserService;

  late TextField nameTextField;
  late TextField surnameTextField;
  late TextField displayNameTextField;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var storageServiceAsync = ref.read(storageServiceInitializerProvider);
    return Scaffold(
        body: Padding(padding: EdgeInsets.fromLTRB(20 , 70, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ProfilePictureWidget(pictureRadius: 60),
                _buildUserPropTypeWidget(storageServiceAsync, ProfileDisplayPropertyType.Name),
                _buildUserPropTypeWidget(storageServiceAsync, ProfileDisplayPropertyType.Surname),
                _buildUserPropTypeWidget(storageServiceAsync, ProfileDisplayPropertyType.DisplayName),
                TextButton(
                    onPressed: ()
                    {

                    },
                    child: Text("Apply"))
              ],
            )
        )
    );
  }

  Future<String> _getUserTypeFomService(StorageService service , ProfileDisplayPropertyType type) {
    if(type == ProfileDisplayPropertyType.Name) 
    {
      return service.getUserUserName(ref);
    }
    else if(type == ProfileDisplayPropertyType.Surname){
      return service.getUserSurname(ref);
    }
    else if(type == ProfileDisplayPropertyType.DisplayName){
      return service.getUserDisplayName(ref);
    }
    return service.getUserUserName(ref);
  }

  Widget _buildUserPropTypeWidget(AsyncValue<StorageService> storageServiceAsync , ProfileDisplayPropertyType type) {
    return storageServiceAsync.when(
      data: (service) => FutureBuilder<String>(
        future: _getUserTypeFomService(service , type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Error loading user name"));
          }
          var widget = TextField(decoration: InputDecoration(hintText: snapshot.data));

          if(type == ProfileDisplayPropertyType.Name)
          {
            nameTextField = widget;
          }
          else if(type == ProfileDisplayPropertyType.Surname)
          {
            surnameTextField = widget;
          }
          else if(type == ProfileDisplayPropertyType.DisplayName)
          {
            displayNameTextField = widget;
          }
          return widget;
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text("Error: $err")),
    );
  }

}