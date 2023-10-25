part of 'package:social_sign_in/social_sign_in.dart';

class SocialSignInException implements Exception {
  final SignInResultStatus status;
  final String description;
  SocialSignInException({
    this.status = SignInResultStatus.failed,
    this.description = 'unknown error',
  });
}
