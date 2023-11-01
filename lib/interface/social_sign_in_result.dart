part of 'package:social_sign_in/social_sign_in.dart';

class SocialSignInResult extends SocialSignInResultInterface {
  SocialSignInResult(
    this.status, {
    this.accessToken = "",
  });

  @override
  String accessToken;

  @override
  String errorMessage = "";

  @override
  String idToken = "";

  @override
  String state = "";

  @override
  SignInResultStatus status;
}
/// A more specific Exception which describes any potential native errors that occur within the Sign in with Social Sign in.
class SocialSignInFail extends SocialSignInResultInterface {
  SocialSignInFail({
    this.status = SignInResultStatus.failed,
    this.accessToken = "",
    this.idToken = "",
    this.errorMessage = "Unknown Fail!",
    this.state = "",
  });

  @override
  String accessToken;

  @override
  String errorMessage;

  @override
  String idToken;

  @override
  SignInResultStatus status;

  @override
  String state;
}
