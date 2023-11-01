import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'interface/social_sign_in_platform_interface.dart';
import 'social_sign_in_define.dart';
export 'social_sign_in_define.dart';
export 'social_sign_in_desktop.dart';
export 'site/apple/apple_sign_in.dart';
export 'site/facebook/facebook_sign_in.dart';
export 'site/google/google_sign_in.dart';
export 'site/microsoft/microsoft_sign_in.dart';
part 'interface/social_sign_in_site_interface.dart';
part 'interface/social_sign_in_error.dart';
part 'interface/social_sign_in_result.dart';

class SocialSignIn {
  ///Wrapper class providing the methods to interact with Social Sign in
  SocialSignIn initialSite(
      SocialSignInSiteConfig profile, SocialSignInPageInfo? pageInfo) {
    SocialSignInPlatform.instance
        .initialSite(profile, pageInfo ?? DefaultSignInPageInfo());
    return this;
  }

  /// Returns the credentials state for a given user by SocialSignInResultInterface
  /// Get the credentials and authorization of social login,
  /// it will convert an authorization code obtained via Social sign
  /// into a session in your system.
  ///
  Future<SocialSignInResultInterface> signInSite(
      SocialPlatform site, BuildContext context) {
    return SocialSignInPlatform.instance.signInSite(site, context);
  }

  Future<SocialSignInResultInterface> signIn(BuildContext context) {
    return SocialSignInPlatform.instance.signIn(context);
  }
}
