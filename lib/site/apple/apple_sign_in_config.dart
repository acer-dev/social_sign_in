import '../../social_sign_in.dart';

class AppleSignInConfig extends SocialSignInSiteConfig {
  @override
  SocialPlatform get site => SocialPlatform.apple;

  @override
  String clientId;

  @override
  String clientSecret = "";

  @override
  String redirectUrl;

  /// host url for windows.
  String hostUrl;

  @override
  List<String> scope;

  /// Parameters required for web-based authentication flows
  AppleSignInConfig({
    ///the Identifier value shown on the detail view of the service after opening
    ///it from social sign in console or developer
    required this.clientId,
    required this.redirectUrl,
    this.hostUrl = "",
    this.scope = const ["name", "email"],
  });
}
