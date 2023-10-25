import '../../social_sign_in.dart';

class FacebookSignInResult extends SocialSignInResultInterface {
  FacebookSignInResult(
    this.status, {
    this.accessToken = "",
    this.idToken = "",
    this.state = "",
  });

  @override
  String accessToken;

  @override
  String errorMessage = "";

  @override
  String idToken = "";

  @override
  String state;

  @override
  SignInResultStatus status;
}
