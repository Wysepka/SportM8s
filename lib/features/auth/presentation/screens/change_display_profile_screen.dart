
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
  final TextEditingController nameTextController = TextEditingController();
  late TextField surnameTextField;
  final TextEditingController surnameTextController = TextEditingController();
  late TextField displayNameTextField;
  final TextEditingController displayNameTextController = TextEditingController();

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
                      storageServiceAsync.when(
                          data: (storageServiceData)  {
                            storageServiceData.setUserDisplayProfileParam(ref,nameTextController.text , ProfileDisplayPropertyType.Name);
                            storageServiceData.setUserDisplayProfileParam(ref,surnameTextController.text , ProfileDisplayPropertyType.Surname);
                            storageServiceData.setUserDisplayProfileParam(ref,displayNameTextController.text , ProfileDisplayPropertyType.DisplayName);
                          },
                          error: (err, stack) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              //TODO replace string value with loc key
                              SnackBar(
                                content: Text("Could not send ProfileDisplayData to server"),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              )
                            );
                          },
                          loading: () => CircularProgressIndicator(),
                      );
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

          late TextField widgetTextField;

          if(type == ProfileDisplayPropertyType.Name)
          {
            widgetTextField = TextField(
              decoration: InputDecoration(hintText: snapshot.data),
              controller: nameTextController,
            );
            nameTextField = widgetTextField;
          }
          else if(type == ProfileDisplayPropertyType.Surname)
          {
            widgetTextField = TextField(
              decoration: InputDecoration(hintText: snapshot.data),
              controller: surnameTextController,
            );
            surnameTextField = widgetTextField;
          }
          else if(type == ProfileDisplayPropertyType.DisplayName)
          {
            widgetTextField = TextField(
              decoration: InputDecoration(hintText: snapshot.data),
              controller: displayNameTextController,
            );
            displayNameTextField = widgetTextField;
          }
          return widgetTextField;
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text("Error: $err")),
    );
  }

}