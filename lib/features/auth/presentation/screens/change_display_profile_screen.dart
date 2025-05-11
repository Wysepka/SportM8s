
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/core/services/storage_service.dart';
import 'package:sportm8s/features/auth/presentation/widgets/profile_picture_widget.dart';
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

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Padding(padding: EdgeInsets.fromLTRB(20 , 70, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ProfilePictureWidget(pictureRadius: 500)
              ],
            )
        )
    );
  }
}