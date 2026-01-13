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
import 'package:sportm8s/graphics/sportm8s_themes.dart';
import 'package:sportm8s/services/server_user_service.dart';
import 'package:sportm8s/core/models/server_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
    return await rootBundle.loadString('assets/text/privacyPolicyV3.txt');
  }

  Future<String> getTermsOfServiceHtml() async
  {
    _logger.debug('Loading terms of service HTML content');
    return await rootBundle.loadString('assets/text/termsOfServiceV2.txt');
  }

  Map<String, Style> _getHtmlStylesTermsOfService() {
    return {
      "h3": Style(
        fontSize: FontSize(20),
        fontWeight: FontWeight.bold,
        margin: Margins.only(top: 24, bottom: 12),
        color: SportM8sColors.textPrimary,
      ),
      "p": Style(
        fontSize: FontSize(16),
        lineHeight: LineHeight(1.5),
        margin: Margins.only(bottom: 12),
        color: SportM8sColors.textPrimary,
      ),
      "li": Style(
        fontSize: FontSize(16),
        lineHeight: LineHeight(1.5),
        margin: Margins.only(left: 16, bottom: 8),
        color: SportM8sColors.textPrimary,
      ),
      "ul": Style(
        margin: Margins.only(left: 16, top: 8, bottom: 16),
      ),
    };
  }

  Map<String, Style> _getPrivacyPolicyHtmlStyles() {
    return {
      "h2": Style(
        color: SportM8sColors.textPrimary,
        fontSize: FontSize(24),
      ),
      "p": Style(
        color: SportM8sColors.textPrimary,
        fontSize: FontSize(16),
      ),
      "li": Style(
        color: SportM8sColors.textPrimary,
        margin: Margins.only(left: 16),
      ),
    };
  }

  void onAggreementApplied(AggreementType aggreementType) async{
    setState(() {
      _isLoading = true;
    });
    try {
      final storageService = ref.watch(storageServiceInitializerProvider);
      storageService.when(
          data: (storageService) async {
            _logger.info('Applying agreement: ${aggreementType.toString()}');
            switch (aggreementType) {
              case AggreementType.PrivacyPolicy:
                await storageService.setPrivacyPolicyAccepted(ref, true);
                _logger.debug('Privacy Policy accepted');
                break;
              case AggreementType.TermsOfService:
                await storageService.setTermsOfServiceAccepted(ref, true);
                _logger.debug('Terms of Service accepted');
                break;
              case AggreementType.EndUserLicense:
                await storageService.setEndUserLicenseAccepted(ref, true);
                _logger.debug('End User License accepted');
                break;
              case AggreementType.ConsentForDataCollection:
                await storageService.setDataCollectionConsentAccepted(ref, true);
                _logger.debug('Data Collection Consent accepted');
                break;
            }
            // Trigger a rebuild to show the next agreement if needed
            setState(() {_isLoading = false;});
          },
          error: (Object error, StackTrace stackTrace) {
            _logger.error('Error setting agreement', error, stackTrace);
          },
          loading: () {
            _logger.debug('Storage service is loading');
          }
      );
    }
    catch(error, stacktrace){
      _logger.error("Error setting Agreement Applied variable in server ! E: $error , ST: $stacktrace");
      if(mounted){
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final l10n = AppLocalizations.of(context);
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
                aggrementNameKey: l10n?.agreement_Title_PrivacyPolicy ?? "Privacy Policy",
                useHtmlMarking: true,
                aggreementType: AggreementType.PrivacyPolicy,
                aggreementTypeCallback: onAggreementApplied,
                loadAggrementHtmlText: getPrivacyPolicyHtml,
                textHtmlStyle: _getPrivacyPolicyHtmlStyles(),
                consentTextKey: l10n?.agreement_ConfirmCheckbox_ReadWholeDoc ?? "I have read whole document",
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
                    aggrementNameKey: l10n?.agreement_Title_TermsOfService ?? "Terms of Service",
                    useHtmlMarking: true,
                    aggreementType: AggreementType.TermsOfService,
                    aggreementTypeCallback: onAggreementApplied,
                    loadAggrementHtmlText: getTermsOfServiceHtml,
                    textHtmlStyle: _getHtmlStylesTermsOfService(),
                    consentTextKey: l10n?.agreement_ConfirmCheckbox_ReadWholeDoc ?? "I have read whole document",
                  );
                }

                if(context.mounted) {
                  _logger.info('All agreements accepted, navigating to home screen');
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacementNamed(context, '/change-profile-screen');
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