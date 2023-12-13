import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import '../src/interface/social_sign_in_platform_interface.dart';
import '../src/social_sign_in_define.dart';
export '../src/social_sign_in_define.dart';
export '../src/social_sign_in_desktop.dart';
export '../src/site/apple/apple_sign_in.dart';
export '../src/site/facebook/facebook_sign_in.dart';
export '../src/site/google/google_sign_in.dart';
export '../src/site/microsoft/microsoft_sign_in.dart';
part '../src/interface/social_sign_in_site_interface.dart';
part '../src/interface/social_sign_in_error.dart';
part '../src/interface/social_sign_in_result.dart';

///Wrapper class providing the methods to interact with Social Sign-in.
class SocialSignIn {
  ///Configure the SocialSignInPlatform instance
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
  /*
  SocialSignIn().initialSite(FacebookSignInConfig(
      clientId: SocialPrivateData.facebookClientId,
      clientSecret: SocialPrivateData.facebookClientSecret,
      redirectUrl: SocialPrivateData.simpleRedirectUrl,
    ), null);



OutlinedButton(
    onPressed: () async {
	final authResult = await SocialSignIn().signInSite(SocialPlatform.facebook, context);
	printSignInResult(authResult);
    }, child: const Text('Login with Facebook'),
),
  * */
  Future<SocialSignInResultInterface> signInSite(
      SocialPlatform site, BuildContext context) {
    return SocialSignInPlatform.instance.signInSite(site, context);
  }

  ///Configure and direct login
  /*
  OutlinedButton(
    onPressed: () async {
        SocialSignIn()
        ..initialSite(GoogleSignInConfig(
            clientId: [YOUR GOOGLE CLIENT ID],
            clientSecret: [YOUR GOOGLE CLIENT SECRET],
            redirectUrl: [YOUR APP SERVER SIDE],
        ), null)
        ..signIn(context).then((authResult) => {

        });
    },
    child: const Text('Login with Google')
),
  * */
  Future<SocialSignInResultInterface> signIn(BuildContext context) {
    return SocialSignInPlatform.instance.signIn(context);
  }
}
