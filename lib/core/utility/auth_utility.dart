import 'package:sportm8s/core/enums/enums_container.dart';


class AuthUtility{
  static String AuthConnectionTypeToString(APIAuthConnectionType authConnectionType){
    switch(authConnectionType){
      case APIAuthConnectionType.Login:
        return "login";
      case APIAuthConnectionType.Signup:
        return "signin";
      case APIAuthConnectionType.Invalid:
        return "invalid";
    }
  }

  static APIAuthConnectionType AuthConnectionFromString(String authConnectionType){
    switch(authConnectionType){
      case "login":
        return APIAuthConnectionType.Login;
      case "signin":
        return APIAuthConnectionType.Signup;
      default:
        return APIAuthConnectionType.Invalid;
    }
  }
}