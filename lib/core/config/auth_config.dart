class AuthConfig {
  static const String tenant = 'MarcinWysocki.onmicrosoft.com';
  static const String clientId = '02e111f1-cd6e-4a8d-8761-1c9f4f2ee439';
  static const String scope = 'openid profile offline_access';
  static const String redirectUri = 'msauth://com.example.sportm8s/callback';
  
  // Your Azure AD B2C policy names
  static const String signUpSignInPolicy = 'B2C_1_SportM8s';
  static const String resetPasswordPolicy = 'B2C_1_SportM8s_ResetPassword';
  static const String editProfilePolicy = 'B2C_1_SportM8s_EditProfile';

  static String get authorityBase =>
      'https://${tenant.split('.')[0]}.b2clogin.com/${tenant}';
      
  static String getAuthorityUrl(String policy) =>
      '$authorityBase/$policy';
} 