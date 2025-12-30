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

enum SportEventType{
  Invalid,
  Soccer,
  Volleyball,
  Basketball,
  Tennis,
  Running,
  Cycling,
}

enum EventParamType{
  EventName,
  EventDescription,
  EventParticipants,
  EventDate,
  EventTime,
}

enum MapViewBottomPanelType{
  Invalid,
  CreatingEvent,
  JoiningEvent,
}

enum EventServiceRequestType{
  Idle,
  CreatingEvent,
  JoiningEvent,
}