enum AggreementType{
  PrivacyPolicy,
  TermsOfService,
  EndUserLicense,
  ConsentForDataCollection,
}

typedef AggreementTypeCallback = void Function(AggreementType type);