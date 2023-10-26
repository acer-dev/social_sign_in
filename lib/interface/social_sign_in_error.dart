part of 'package:social_sign_in/social_sign_in.dart';
/// An Exception which describes access denied, sign in be cancelled or potential native errors
/// that occur within the social sign in.
class SocialSignInException implements Exception {
  final SignInResultStatus status;
  final String description;
  SocialSignInException({
    this.status = SignInResultStatus.failed,
    this.description = 'unknown error',
  });
}
