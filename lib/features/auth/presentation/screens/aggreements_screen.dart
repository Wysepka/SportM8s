import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/services/storage_service.dart';
import 'package:sportm8s/features/auth/presentation/screens/privacy_policy_screen.dart';
import 'package:flutter/scheduler.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/core/logger/logger_config.dart';
import 'package:sportm8s/services/server_user_service.dart';
import 'package:sportm8s/core/models/server_response.dart';

class AggreementsScreen extends ConsumerStatefulWidget
{
  const AggreementsScreen({super.key});

  @override
  ConsumerState<AggreementsScreen> createState() => _AggreementsScreenState();

}

class _AggreementsScreenState extends ConsumerState<AggreementsScreen>{

  final LoggerService _logger = LoggerService();
  bool _isLoading = false;
  bool _termsAccepted = false;
  bool _privacyAccepted = false;
  bool _marketingAccepted = false;
  late final ServerUserService _serverUserService;

  @override
  void initState() {
    super.initState();
    _serverUserService = ref.read(serverUserServiceProvider);
  }

  /*
  Future<bool> hasAcceptedPrivacyPolicy() async
  {
    StorageService instance = await StorageService.getInstance();
    _logger.debug('Checking if privacy policy is accepted');
    return instance.hasPrivacyPolicyAccepted;
  }
  */

  Future<String> getPrivacyPolicyHtml() async
  {
    _logger.debug('Loading privacy policy HTML content');
    return await rootBundle.loadString('assets/text/privacyPolicyAndroidExample.txt');
  }

  Future<String> getTermsOfServiceHtml() async
  {
    _logger.debug('Loading terms of service HTML content');
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
        _logger.info('Applying agreement: ${aggreementType.toString()}');
        switch (aggreementType) {
          case AggreementType.PrivacyPolicy:
            storageService.setPrivacyPolicyAccepted(ref, true);
            _logger.debug('Privacy Policy accepted');
            break;
          case AggreementType.TermsOfService:
            storageService.setTermsOfServiceAccepted(ref, true);
            _logger.debug('Terms of Service accepted');
            break;
          case AggreementType.EndUserLicense:
            storageService.setEndUserLicenseAccepted(ref, true);
            _logger.debug('End User License accepted');
            break;
          case AggreementType.ConsentForDataCollection:
            storageService.setDataCollectionConsentAccepted(ref, true);
            _logger.debug('Data Collection Consent accepted');
            break;
        }
        // Trigger a rebuild to show the next agreement if needed
        setState(() {});
      },
      error: (Object error, StackTrace stackTrace) {
        _logger.error('Error setting agreement', error, stackTrace);
      },
      loading: () {
        _logger.debug('Storage service is loading');
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final storageService = ref.watch(storageServiceInitializerProvider);

    return storageService.when(
      data: (storageService) {
        return FutureBuilder<bool>(
          future: storageService.hasPrivacyPolicyAccepted(ref),
          builder: (context, privacySnapshot) {
            if (privacySnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!privacySnapshot.data!) {
              _logger.debug('Showing Privacy Policy screen');
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

            return FutureBuilder<bool>(
              future: storageService.hasTermsOfServiceAccepted(ref),
              builder: (context, termsSnapshot) {
                if (termsSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (!termsSnapshot.data!) {
                  _logger.debug('Showing Terms of Service screen');
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

                if(context.mounted) {
                  _logger.info('All agreements accepted, navigating to home screen');
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacementNamed(context, '/home');
                  });
                }
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            );
          }
        );
      },
      error: (error, stack) {
        _logger.error('Failed to load Storage Service', error, stack);
        return Scaffold(body: Center(child: Text(
            "Loading Service Storage Failed Excp: $error ")));
      },
      loading: () {
        _logger.debug('Loading Storage Service');
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
    );
  }

}