import '../../social_sign_in.dart';

class AppleSignInResult extends SocialSignInResultInterface{

  AppleSignInResult(this.status, {
    this.idToken = "",
    this.state = "",
    this.nonce = "",
  });

  @override
  String accessToken = "";

  @override
  String errorMessage = "";

  @override
  String idToken;

  @override
  SignInResultStatus status;

  String nonce;

  @override
  String state;
}