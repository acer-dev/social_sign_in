import '../../social_sign_in.dart';

class GoogleSignInConfig extends SocialSignInSiteConfig {
  @override
  SocialPlatform get site => SocialPlatform.google;

  @override
  String clientId;

  @override
  String clientSecret;

  @override
  String redirectUrl;

  @override
  List<String> scope;

  GoogleSignInConfig(
      {required this.clientId,
      required this.clientSecret,
      required this.redirectUrl,
      this.scope = const ["profile", "email"]});
}
