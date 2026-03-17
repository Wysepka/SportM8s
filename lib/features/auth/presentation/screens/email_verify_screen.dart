import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/services/auth_service.dart';
import 'package:sportm8s/events/map_event_widget_container.dart';
import 'package:sportm8s/gen/assets.gen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "dart:math";

class EmailVerifyScreen extends ConsumerStatefulWidget{

  const EmailVerifyScreen({super.key});

  @override
  ConsumerState<EmailVerifyScreen> createState() => _EmailVerifyScreen();

}

class _EmailVerifyScreen extends ConsumerState<EmailVerifyScreen> with SingleTickerProviderStateMixin{

  Timer? _timer;

  bool _verified = false;
  bool _navigated = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      checkEmailVerification();
    });
  }

  void checkEmailVerification() async{
    final authService = ref.read(authServiceProvider);

    final ok = await authService.hasUserVerifiedEmail();
    if (!mounted) return;

    if (ok) {
      setState(() => _verified = true);

      _timer?.cancel();

      if (!_navigated) {
        _navigated = true;
        Navigator.pushReplacementNamed(context, '/aggreements');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n?.auth_EmailVerifyWaiting ?? "Verify your email"),),
      body: Padding(
        padding: EdgeInsets.fromLTRB(50, 100, 50, 100),
        child: Center(
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  final angle = _controller.value * 2 * pi;
                  return Transform.rotate(angle: angle, child: child,);
                },
                child: Image.asset(Assets.logos.sportM8sColorLogo.path ,width: 256,height:  256)),
              SizedBox(
                width: 10,
                height: 30,
              ),
              MapEventWidgetContainer(
                child: Column(
                  children: [
                    Text(
                      _verified ? l10n?.auth_EmailVeryficationContinue ?? "Proceed to app" : l10n?.auth_EmailVerifyWaiting ?? "Verify your email",
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: FilledButton.icon(
                          label: Text(_verified ? l10n?.auth_EmailVeryficationContinue ?? "Proceed" : l10n?.auth_EmailVeryficationRefresh ?? "Refresh"),
                          onPressed: _verified ? null : checkEmailVerification,
                          icon: _verified ?
                          Icon(
                            Icons.check_circle ,
                            color: Colors.greenAccent,
                            size: 45,
                          ) :
                          Icon(
                            Icons.refresh,
                            size: 45,
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

}