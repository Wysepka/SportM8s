enum AggreementType{
  PrivacyPolicy,
  TermsOfService,
  EndUserLicense,
  ConsentForDataCollection,
}

enum ProfileDisplayPropertyType{
  Name,
  Surname,
  DisplayName,
}

typedef AggreementTypeCallback = void Function(AggreementType type);