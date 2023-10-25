import '../../social_sign_in.dart';

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

  FacebookSignInConfig({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUrl,
    this.scope = const ["email", "public_profile"],
  });
}
