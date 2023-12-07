import '../../social_sign_in.dart';

///Configure Facebook sign-in parameters required for web-based authentication flows
class FacebookSignInConfig extends SocialSignInSiteConfig {
  @override
  SocialPlatform get site => SocialPlatform.facebook;

  @override
  String clientId;

  @override
  String clientSecret;

  @override
  String redirectUrl;

  @override
  List<String> scope;

  /// Parameters required for web-based authentication flows
  FacebookSignInConfig({
    ///the Identifier value shown on the detail view of the service after opening
    ///it from social sign in console or developer
    required this.clientId,
    required this.clientSecret,
    required this.redirectUrl,
    this.scope = const ["email", "public_profile"],
  });
}