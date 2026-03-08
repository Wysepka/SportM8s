
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/core/services/storage_service.dart';
import 'package:sportm8s/features/auth/presentation/widgets/profile_picture_widget.dart';
import "package:sportm8s/core/enums/enums_container.dart";
import 'package:sportm8s/services/server_user_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final FocusNode nameFocus = FocusNode();
  late TextFormField surnameTextField;
  final TextEditingController surnameTextController = TextEditingController();
  final FocusNode surnameFocus = FocusNode();
  late TextFormField displayNameTextField;
  final TextEditingController displayNameTextController = TextEditingController();
  final FocusNode displayNameFocus = FocusNode();

  bool _hasChangedNameField = false;
  bool _hasChangedSurnameField = false;
  bool _hasChangedDisplayNameField = false;

  String? _nameFieldLoadedValue = "";
  String? _surnameFieldLoadedValue = "";
  String? _displayNameFieldLoadedValue ="";

  bool _isSendingValuesOverNetwork = false;
  bool _canSendNameValues = true;
  bool _canSendSurnameValues = true;
  bool _canSendDisplayNameValus = true;

  bool _ditInitName = false;
  bool _didInitSurname = false;
  bool _didInitDisplayName = false;

  @override
  void initState() {
    super.initState();


    nameTextController.addListener(()  {
        if(!nameFocus.hasFocus) {
          _revalidateAllFields();
        }
    });
    surnameTextController.addListener(() {
      if(!surnameFocus.hasFocus) {
        _revalidateAllFields();
      }
    });
    displayNameTextController.addListener(() {
      if(!displayNameFocus.hasFocus) {
        _revalidateAllFields();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final l10n = AppLocalizations.of(context);
    var storageServiceAsync = ref.watch(storageServiceInitializerProvider);
    return Scaffold(
        appBar: AppBar(title: Text(l10n?.profile_Title_EditProfile ?? "Edit Profile"),),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(padding: EdgeInsets.fromLTRB(20 , 70, 20, 20),
                child: ListView(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    ProfilePictureWidget(pictureRadius: 60),
                    SizedBox(height: 10,),
                    Text(
                      l10n?.profile_Subtitle_PublicInfo ?? "Public Info",
                      style: Theme.of(context).textTheme.titleMedium,),
                    SizedBox(height: 5,),
                    Text(
                      l10n?.profile_Subtitle_UpdatePublicData ?? "Update your name , surname, and display name shown for other users",
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
              if(_isSendingValuesOverNetwork)...{
                Positioned.fill(
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                ),
              }
            ]
          ),
        )
    );
  }

  Widget _getEndResultButton(AsyncValue<StorageService> storageServiceAsync){
    bool hasChangedAnything = _hasChangedNameField || _hasChangedSurnameField || _hasChangedDisplayNameField;
    bool sendValuesAllGood = _nameFieldLoadedValue!.isNotEmpty &&
                             _surnameFieldLoadedValue!.isNotEmpty &&
                             _displayNameFieldLoadedValue!.isNotEmpty;

    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 48,
      child: FilledButton.icon(
          onPressed: () {
            if (sendValuesAllGood) {
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
            sendValuesAllGood ? (hasChangedAnything ? l10n?.profile_Button_Save ?? "Save" : l10n?.profile_Button_Continue ?? "Continue") : l10n?.profile_Button_DataMalformed ?? "Data Malformed",
          ),
          icon: _isSendingValuesOverNetwork ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
          : sendValuesAllGood ? const Icon(Icons.check) : const Icon(Icons.error),
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
    final l10n = AppLocalizations.of(context);

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
            if(!_ditInitName){
              //_ditInitName = true;
              WidgetsBinding.instance.addPostFrameCallback( (_) {
                setState(() {
                  _ditInitName = true;
                  nameTextController.text = snapshot.data!;
                  _nameFieldLoadedValue = snapshot.data;
                });
              });
            }

            _canSendNameValues = _nameFieldLoadedValue != null && _nameFieldLoadedValue!.isNotEmpty;
            widgetTextField = TextFormField(
              focusNode: nameFocus,
              decoration: InputDecoration(
                  labelText: l10n?.profile_Name ??  "Name",
                  hintText: l10n?.profile_NameExample ?? "e.g. Jacob",
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              controller: nameTextController,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              validator: (v) => _requiredValidator(v , 15 , "Name"),
              onFieldSubmitted: (v) => _revalidateAllFields(),
            );
            nameTextField = widgetTextField;
          }
          else if(type == ProfileDisplayPropertyType.Surname)
          {
            if(!_didInitSurname){
              WidgetsBinding.instance.addPostFrameCallback( (_) {
                setState(() {
                  _didInitSurname = true;
                  surnameTextController.text = snapshot.data!;
                  _surnameFieldLoadedValue = snapshot.data;
                });
              });
            }

            _canSendSurnameValues = _surnameFieldLoadedValue != null && _surnameFieldLoadedValue!.isNotEmpty;
            widgetTextField = TextFormField(
              focusNode: surnameFocus,
              decoration: InputDecoration(
                  labelText: l10n?.profile_Surname ?? "Surname",
                  hintText: l10n?.profile_SurnameExample ?? "e.g. Smith",
                  prefixIcon: Icon(Icons.badge_outlined),
              ),
              controller: surnameTextController,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.familyName],
              validator: (v) => _requiredValidator(v , 20 , l10n?.profile_Surname ?? "Surname"),
              onFieldSubmitted: (v) => _revalidateAllFields(),
            );
            surnameTextField = widgetTextField;
          }
          else if(type == ProfileDisplayPropertyType.DisplayName)
          {
            if(!_didInitDisplayName){
              WidgetsBinding.instance.addPostFrameCallback( (_) {
                setState(() {
                  _didInitDisplayName = true;
                  displayNameTextController.text = snapshot.data!;
                  _displayNameFieldLoadedValue = snapshot.data;
                });
              });
            }
            _canSendDisplayNameValus = _displayNameFieldLoadedValue != null && _displayNameFieldLoadedValue!.isNotEmpty;
            widgetTextField = TextFormField(
              focusNode: displayNameFocus,
              decoration: InputDecoration(
                helperText: l10n?.profile_DisplayNameHelper ?? "What other users will see when displaying your participation in event",
                labelText: l10n?.profile_DisplayNameLabel ?? "Display Name",
                hintText: l10n?.profile_DisplayNameHint ?? "What other users will see",
                prefixIcon: Icon(Icons.alternate_email)),
              controller: displayNameTextController,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.nickname],
              validator: (v) => _requiredValidator(v , 15 , l10n?.profile_DisplayNameLabel ?? "Display Name"),
              onFieldSubmitted: (v) => _revalidateAllFields(),
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

  String? _requiredValidator(String? v, int max, String label) {
    final l10n = AppLocalizations.of(context);
    final value = v?.trim() ?? '';
    if (value.isEmpty) return '$label ${l10n?.profile_CannotBeEmpty ?? "cannot be empty"}';
    if (value.length > max) return '$label ${l10n?.profile_IsTooLong ?? "is too long"}';
    return null;
  }

  void _revalidateAllFields() {
    final nameOk = nameTextController.text.trim().isNotEmpty;
    final surnameOk = surnameTextController.text.trim().isNotEmpty;
    final displayOk = displayNameTextController.text.trim().isNotEmpty;

    final changedName = nameTextController.text != (_nameFieldLoadedValue! ?? '');
    final changedSurname = surnameTextController.text != (_surnameFieldLoadedValue! ?? '');
    final changedDisplay = displayNameTextController.text != (_displayNameFieldLoadedValue! ?? '');

    final shouldRebuild =
        nameOk != _canSendNameValues ||
            surnameOk != _canSendSurnameValues ||
            displayOk != _canSendDisplayNameValus ||
            changedName != _hasChangedNameField ||
            changedSurname != _hasChangedSurnameField ||
            changedDisplay != _hasChangedDisplayNameField;

    if (!shouldRebuild) return;

    setState(() {
      _canSendNameValues = nameOk;
      _canSendSurnameValues = surnameOk;
      _canSendDisplayNameValus = displayOk;

      _nameFieldLoadedValue = nameTextController.text;
      _surnameFieldLoadedValue = surnameTextController.text;
      _displayNameFieldLoadedValue = displayNameTextController.text;

      _hasChangedNameField = changedName;
      _hasChangedSurnameField = changedSurname;
      _hasChangedDisplayNameField = changedDisplay;
    });
  }

}