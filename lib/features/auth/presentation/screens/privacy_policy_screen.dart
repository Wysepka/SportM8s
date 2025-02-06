import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/services/storage_service.dart';
import 'package:sportm8s/features/auth/presentation/widgets/aggreement_widget.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;

class PrivacyPolicyScreen extends ConsumerWidget {
  final String aggrementNameKey;
  final String consentTextKey;
  final Map<String,Style> textHtmlStyle;
  final bool useHtmlMarking;
  final AggreementType aggreementType;
  final AggreementTypeCallback aggreementTypeCallback;
  final Future<String> Function()? loadAggrementHtmlText;

  const PrivacyPolicyScreen(
  {
    super.key,
    required this.aggrementNameKey,
    required this.consentTextKey,
    required this.useHtmlMarking,
    required this.aggreementType,
    required this.aggreementTypeCallback,
    required this.loadAggrementHtmlText,
    required this.textHtmlStyle,
  });

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
    aggreementTypeCallback.call(aggreementType);
  }

  Future<bool> hasAcceptedPrivacyPolicy(WidgetRef ref) async
  {
    StorageService instance = await StorageService.getInstance();
    return await instance.hasPrivacyPolicyAccepted(ref);
  }

  Future<String> getPrivacyPolicyHtml() async
  {
    return await rootBundle.loadString('assets/text/privacyPolicyAndroidExample.txt');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(aggrementNameKey),
        actions: !kReleaseMode ? [
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
        ] : null,
      ),
      body: FutureBuilder<String>(future: loadAggrementHtmlText!(), builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasError){
            String errorMessage = snapshot.error.toString();
            return Center(child: Text("Error Loading Privacy Policy Text ! Exception: $errorMessage"));
          }
          return AggreementWidget(
              text: snapshot.data ?? lorumIpsum,
              onAggrementAppliedPressed: onAggreementApplied,
              useHtmlFormat: snapshot.data != null,
              textHtmlStyles: textHtmlStyle,
              consentTextKey: consentTextKey,
          );
        }
      ) ,
    );
  }
}