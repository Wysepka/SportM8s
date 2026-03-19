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
  ClimbingBouldering,
  ClimbingLeading,
  ClimbingTopRope,
  CrossCountrySkiing,
  Other
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

enum UserEventRequestType{
  Invalid,
  Join,
  Leave,
}

enum APIAuthConnectionType{
  Invalid,
  Login,
  Signin,
}

enum ResetPasswordEmailState{
  Invalid,
  InSendProcess,
  SendSuccesfull,
  SendError
}