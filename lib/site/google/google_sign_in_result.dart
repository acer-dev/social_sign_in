import '../../social_sign_in.dart';

class GoogleSignInResult extends SocialSignInResultInterface {
  GoogleSignInResult(
    this.status, {
    this.accessToken = "",
    this.idToken = "",
    this.errorMessage = "",
    this.state = "",
  });

  @override
  String accessToken;

  @override
  String errorMessage;

  @override
  String idToken;

  @override
  String state;

  @override
  SignInResultStatus status;
}
