enum SocialPlatform {
  ///https://developer.apple.com/account/resources/identifiers/list/bundleId
  apple,
  ///https://developers.facebook.com/
  facebook,
  ///https://console.cloud.google.com/
  google,
  ///https://portal.azure.com/
  microsoft,
}

enum SignInResultStatus {
  /// The login was successful.
  ok,

  /// The user cancelled the login flow, usually by closing the
  /// login dialog.
  cancelled,

  /// The login completed with an error and the user couldn't log
  /// in for some reason.
  failed,
}
