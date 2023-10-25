import '../../social_sign_in.dart';

class MicrosoftSignInConfig extends SocialSignInSiteConfig {
  @override
  SocialPlatform get site => SocialPlatform.microsoft;

  @override
  String clientId;

  @override
  String clientSecret;

  @override
  String redirectUrl;

  @override
  List<String> scope;

  MicrosoftSignInConfig(
      {required this.clientId,
      required this.clientSecret,
      required this.redirectUrl,
      this.scope = const ["user.read"]});
}
