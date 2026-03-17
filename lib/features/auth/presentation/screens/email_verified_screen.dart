import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sportm8s/events/map_event_widget_container.dart';

class EmailVerifiedScreen extends StatelessWidget{

  const EmailVerifiedScreen();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.auth_EmailVerifiedSuccess ?? "Email successfully verified"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: MapEventWidgetContainer(
              child: Text(
                  l10n?.auth_EmailVerifiedSuccess ?? "Email successfully verified",
                  style: Theme.of(context).textTheme.titleLarge
              ),
            )
          ),
          SizedBox(height: 5,),
          ElevatedButton.icon(
            onPressed: () => _navigateToHomePage(context),
            label: Text(l10n?.auth_ContinueToHomePageButton ?? "Home page"),
            icon: Icon(Icons.home),
          ),
        ],
      ),
    );
  }

  void _navigateToHomePage(BuildContext context){
    Navigator.of(context).pushReplacementNamed('/login');
  }
  
}