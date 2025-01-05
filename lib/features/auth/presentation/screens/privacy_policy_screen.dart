
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/services/storage_service.dart';
import 'package:sportm8s/features/auth/presentation/widgets/aggreement_widget.dart';
import "package:shared_preferences/shared_preferences.dart";

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  final String lorumIpsum = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem "
      "accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore"
      "veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia"
      "voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione"
      "voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet,"
      "consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et"
      "dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem"
      "ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum"
      "iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui"
      "dolorem eum fugiat quo voluptas nulla pariatur";

  //final String privacyPolicyExample = ""

  void onAggreementApplied() {
    print("Privacy Policy Applied");
  }

  Future<bool> hasAcceptedPrivacyPolicy() async
  {
    StorageService instance = await StorageService.getInstance();
    return instance.hasPrivacyPolicyAccepted;
  }

  Future<String> getPrivacyPolicyHtml() async
  {
    return await rootBundle.loadString('assets/text/privacyPolicyAndroidExample.txt');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final storageService = ref.watch(storageServiceInitializerProvider);

    return storageService.when(data: (storageService) {
      if (storageService.hasPrivacyPolicyAccepted) {
        Future.microtask(() {
          Navigator.of(context).pushReplacementNamed("/home");
        });
      }
      return Scaffold(
        appBar: AppBar(title: Text("Privacy Policy Screen"), actions: [
        IconButton(
        icon: const Icon(Icons.bug_report),
        onPressed: () async {
          try {
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }
          }
        },
        tooltip: 'Debug: Clear Session',
        ),
        ],),
        body: FutureBuilder(future: getPrivacyPolicyHtml(), builder: (context,snapshot) {
          return AggreementWidget(
              text: snapshot.data ?? lorumIpsum,
              onAggrementAppliedPressed: onAggreementApplied,
              useHtmlFormat: snapshot.data != null,
          );
        }
      ) ,
      );
    },
        error: (error, stack) => Scaffold(body: Center(child: Text(
            "Loading PrivacyPolicy Storage Failed Excp: $error "))),
        loading: () =>
        const Scaffold(body: Center(child: CircularProgressIndicator()))
    );

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}