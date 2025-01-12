import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/services/storage_service.dart';
import 'package:sportm8s/features/auth/presentation/screens/privacy_policy_screen.dart';
import 'package:flutter/scheduler.dart';

class AggreementsScreen extends ConsumerStatefulWidget
{
  const AggreementsScreen({super.key});

  @override
  ConsumerState<AggreementsScreen> createState() => _AggreementsScreenState();

}

class _AggreementsScreenState extends ConsumerState<AggreementsScreen>{

  final Map<AggreementType , bool> _acceptedAggreements = {
    AggreementType.PrivacyPolicy: false,
    AggreementType.TermsOfService: false,
    AggreementType.EndUserLicense: false,
    AggreementType.ConsentForDataCollection: false
  };

  Future<bool> hasAcceptedPrivacyPolicy() async
  {
    StorageService instance = await StorageService.getInstance();
    return instance.hasPrivacyPolicyAccepted;
  }

  Future<String> getPrivacyPolicyHtml() async
  {
    return await rootBundle.loadString('assets/text/privacyPolicyAndroidExample.txt');
  }

  Future<String> getTermsOfServiceHtml() async
  {
    return await rootBundle.loadString('assets/text/termsOfServiceExample.txt');
  }

  Map<String, Style> _getHtmlStylesTermsOfService() {
    return {
      "h3": Style(
        fontSize: FontSize(20),
        fontWeight: FontWeight.bold,
        margin: Margins.only(top: 24, bottom: 12),
        color: Colors.black87,
      ),
      "p": Style(
        fontSize: FontSize(16),
        lineHeight: LineHeight(1.5),
        margin: Margins.only(bottom: 12),
        color: Colors.black54,
      ),
      "li": Style(
        fontSize: FontSize(16),
        lineHeight: LineHeight(1.5),
        margin: Margins.only(left: 16, bottom: 8),
        color: Colors.black54,
      ),
      "ul": Style(
        margin: Margins.only(left: 16, top: 8, bottom: 16),
      ),
    };
  }

  Map<String, Style> _getPrivacyPolicyHtmlStyles() {
    return {
      "h2": Style(
        color: Colors.blue,
        fontSize: FontSize(24),
      ),
      "p": Style(
        fontSize: FontSize(16),
      ),
      "li": Style(
        margin: Margins.only(left: 16),
      ),
    };
  }

  void onAggreementApplied(AggreementType aggreementType) {
    final storageService = ref.watch(storageServiceInitializerProvider);
    storageService.when(
      data: (storageService) {
        switch (aggreementType) {
          case AggreementType.PrivacyPolicy:
            storageService.setPrivacyPolicyAccepted(true);
            break;
          case AggreementType.TermsOfService:
            storageService.setTermsOfServiceAccepted(true);
            break;
          case AggreementType.EndUserLicense:
            storageService.setEndUserLicenseAccepted(true);
            break;
          case AggreementType.ConsentForDataCollection:
            storageService.setDataCollectionConsentAccepted(true);
            break;
        }
        // Trigger a rebuild to show the next agreement if needed
        setState(() {});
      },
      error: (Object error, StackTrace stackTrace) {
        // Handle error case
        debugPrint('Error setting agreement: $error');
      },
      loading: () {
        // Handle loading state
        debugPrint('Storage service is loading');
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final storageService = ref.watch(storageServiceInitializerProvider);

    return storageService.when(data: (storageService) {
      if (!storageService.hasPrivacyPolicyAccepted) {
        return PrivacyPolicyScreen(
          aggrementNameKey: "aggreementPrivacyPolicy",
          useHtmlMarking: true,
          aggreementType: AggreementType.PrivacyPolicy,
          aggreementTypeCallback: onAggreementApplied,
          loadAggrementHtmlText: getPrivacyPolicyHtml,
          textHtmlStyle: _getPrivacyPolicyHtmlStyles(),
          consentTextKey: "consentPrivacyPolicy",
        );
      }
      if(!storageService.hasTermsOfServiceAccepted){
        return PrivacyPolicyScreen(
            aggrementNameKey: "aggreementTermsOfService",
            useHtmlMarking: true,
            aggreementType: AggreementType.TermsOfService,
            aggreementTypeCallback: onAggreementApplied,
            loadAggrementHtmlText: getTermsOfServiceHtml,
            textHtmlStyle: _getHtmlStylesTermsOfService(),
            consentTextKey: "consentTermsOfService",
        );
      }
      // Schedule navigation for the next frame
      if(context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/home');
        });
      }
      // Return a loading screen while we wait for navigation
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    },
        error: (error, stack) => Scaffold(body: Center(child: Text(
            "Loading Service Storage Failed Excp: $error "))),
        loading: () =>
        const Scaffold(body: Center(child: CircularProgressIndicator()))
    );
  }

}