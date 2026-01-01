
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

  late TextFormField nameTextField;
  final TextEditingController nameTextController = TextEditingController();
  late TextFormField surnameTextField;
  final TextEditingController surnameTextController = TextEditingController();
  late TextFormField displayNameTextField;
  final TextEditingController displayNameTextController = TextEditingController();

  bool _hasChangedNameField = false;
  bool _hasChangedSurnameField = false;
  bool _hasChangedDisplayNameField = false;

  String? _nameFieldLoadedValue = "";
  String? _surnameFieldLoadedValue = "";
  String? _displayNameFieldLoadedValue ="";

  bool _isSendingValuesOverNetwork = false;
  bool _canSendValues = true;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var storageServiceAsync = ref.read(storageServiceInitializerProvider);
    return Scaffold(
        appBar: AppBar(title: Text("Edit Profile"),),
        body: SafeArea(
          child: Padding(padding: EdgeInsets.fromLTRB(20 , 70, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProfilePictureWidget(pictureRadius: 60),
                  SizedBox(height: 10,),
                  Text(
                    "Public Info",
                    style: Theme.of(context).textTheme.titleMedium,),
                  SizedBox(height: 5,),
                  Text(
                    "Update your name , surname, and display name shown for other users",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant
                    ),
                  ),
                  SizedBox(height: 20,),
                  Card(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
                    child: Form(
                      child: Column(
                        children: [
                          _buildUserPropTypeWidget(storageServiceAsync, ProfileDisplayPropertyType.Name),
                          SizedBox(height: 8,),
                          _buildUserPropTypeWidget(storageServiceAsync, ProfileDisplayPropertyType.Surname),
                          SizedBox(height: 8,),
                          _buildUserPropTypeWidget(storageServiceAsync, ProfileDisplayPropertyType.DisplayName),
                      ],),
                    ) ,),
                  SizedBox(height: 10),
                  _getEndResultButton(storageServiceAsync),
                ],
              )
          ),
        )
    );
  }

  Widget _getEndResultButton(AsyncValue<StorageService> storageServiceAsync){
    bool _hasChangedAnything = _hasChangedNameField || _hasChangedSurnameField || _hasChangedDisplayNameField;

    return SizedBox(
      height: 48,
      child: FilledButton.icon(
          onPressed: () {
            if (_hasChangedAnything) {
              storageServiceAsync.when(
                data: (storageServiceData) async {
                  setState(() {
                    _isSendingValuesOverNetwork = true;
                  });
                  final resultName = storageServiceData
                      .setUserDisplayProfileParam(ref, nameTextController.text,
                      ProfileDisplayPropertyType.Name);
                  final resultSurname = storageServiceData
                      .setUserDisplayProfileParam(ref, surnameTextController.text,
                      ProfileDisplayPropertyType.Surname);
                  final resultDisplayName = storageServiceData
                      .setUserDisplayProfileParam(
                      ref, displayNameTextController.text,
                      ProfileDisplayPropertyType.DisplayName);

                  await Future.wait(
                      [resultName, resultSurname, resultDisplayName]);

                  setState(() {
                    _isSendingValuesOverNetwork = false;
                  });

                  //TODO ADD SOME SNACKBAR INFO ABOUT NOT ALL RESULTS SENT
                  if (context.mounted) {
                    _logger.info(
                        'All Profile Params sent ! Navigating to MapRootScreen');
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacementNamed(context, '/map-root-screen');
                    });
                  }
                },
                error: (err, stack) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    //TODO replace string value with loc key
                      SnackBar(
                        content: Text(
                            "Could not send ProfileDisplayData to server"),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      )
                  );
                },
                loading: () => CircularProgressIndicator(),
              );
            }
          },
          label: Text(
              _canSendValues ? _hasChangedAnything ? "Save" : "Continue" : "Data Malformed",
          ),
          icon: _isSendingValuesOverNetwork ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
          : const Icon(Icons.check),
      ),
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
            return const Center(child: Text("Error loading user profile data"));
          }

          late TextFormField widgetTextField;

          if(type == ProfileDisplayPropertyType.Name)
          {
            _nameFieldLoadedValue = snapshot.data;
            nameTextController.text = snapshot.data!;
            widgetTextField = TextFormField(
              decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "e.g. Jacob",
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              controller: nameTextController,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              validator: (v) => _fieldNameValidator(v),
              onFieldSubmitted: (v) => _onNameSumbited(v),
            );
            nameTextField = widgetTextField;
          }
          else if(type == ProfileDisplayPropertyType.Surname)
          {
            _surnameFieldLoadedValue = snapshot.data;
            surnameTextController.text = snapshot.data!;
            widgetTextField = TextFormField(
              decoration: InputDecoration(
                  labelText: "Surname",
                  hintText: "e.g. Smith",
                  prefixIcon: Icon(Icons.badge_outlined),
              ),
              controller: surnameTextController,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.familyName],
              validator: (v) => _fieldSurnameValidator(v),
              onFieldSubmitted: (v) => _onSurnameSumbited(v),
            );
            surnameTextField = widgetTextField;
          }
          else if(type == ProfileDisplayPropertyType.DisplayName)
          {
            _displayNameFieldLoadedValue = snapshot.data;
            displayNameTextController.text = snapshot.data!;
            widgetTextField = TextFormField(
              decoration: InputDecoration(
                helperText: "What other users will se when displaying your participation in event",
                labelText: "Display Name",
                hintText: "What other users will see",
                prefixIcon: Icon(Icons.alternate_email)),
              controller: displayNameTextController,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.nickname],
              validator: (v) => _fieldDisplayNameValidator(v),
              onFieldSubmitted: (v) => _onDisplayNameSubmited(v),
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

  void _onNameSumbited(String? fieldValueNull){
    if(fieldValueNull == null){
      _canSendValues = false;
    }
    String fieldValue = fieldValueNull!;
    if(fieldValue != _nameFieldLoadedValue && !_hasChangedNameField){
      setState(() {
        _hasChangedNameField = true;
      });
    }
    else if(_hasChangedNameField){
      setState(() {
        _hasChangedNameField = false;
      });
    }
  }

  void _onSurnameSumbited(String? fieldValueNull){
    if(fieldValueNull == null || fieldValueNull.isEmpty){
      _canSendValues = false;
    }
    String fieldValue = fieldValueNull!;
    if(fieldValue != _surnameFieldLoadedValue && !_hasChangedSurnameField){
      setState(() {
        _hasChangedSurnameField = true;
      });
    }
    else if(_hasChangedSurnameField){
      setState(() {
        _hasChangedSurnameField = false;
      });
    }
  }

  void _onDisplayNameSubmited(String? fieldValueNull){
    if(fieldValueNull == null || fieldValueNull.isEmpty){
      _canSendValues = false;
    }
    String fieldValue = fieldValueNull!;
    if(fieldValue != _displayNameFieldLoadedValue && !_hasChangedDisplayNameField){
      setState(() {
        _hasChangedDisplayNameField = true;
      });
    }
    else if(_hasChangedDisplayNameField){
      setState(() {
        _hasChangedDisplayNameField = false;
      });
    }
  }

  String? _fieldNameValidator(String? fieldValueNull){
    String fieldValue = fieldValueNull ?? "";
    if(fieldValue.isEmpty){
      return "Name Field is Empty ! Write Something";
    }
    if(fieldValue.length > 20){
      return "Your name is too long";
    }
    return null;
  }

  String? _fieldSurnameValidator(String? fieldValueNull){
    String fieldValue = fieldValueNull ?? "";
    if(fieldValue.isEmpty){
      return "Surname is Empty ! Write Something";
    }
    if(fieldValue.length > 40){
      return "Surname is too long";
    }
    return null;
  }

  String? _fieldDisplayNameValidator(String? fieldValueNull){
    String fieldValue = fieldValueNull ?? "";
    if(fieldValue.isEmpty){
      return "Display Name is empty! Write something";
    }
    if(fieldValue.length > 20){
      return "Display Name is too long, shorten it";
    }
    return null;
  }

}