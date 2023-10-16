
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import 'interface/social_sign_in_platform_interface.dart';
import 'social_sign_in_define.dart';

export 'social_sign_in_define.dart';

part 'interface/social_sign_in_site_interface.dart';
part 'interface/social_sign_in_error.dart';
part 'interface/social_sign_in_result.dart';


class SocialSignIn {
  SocialSignIn initialSite(SocialSignInSiteConfig profile, SocialSignInPageInfo? pageInfo){
    SocialSignInPlatform.instance.initialSite(profile, pageInfo ?? DefaultSignInPageInfo());
    return this;
  }

  Future<SocialSignInResultInterface> signInSite(SocialPlatform site, BuildContext context) {
    return SocialSignInPlatform.instance.signInSite(site, context);
  }

  Future<SocialSignInResultInterface> signIn(BuildContext context) {
    return SocialSignInPlatform.instance.signIn(context);
  }
}
