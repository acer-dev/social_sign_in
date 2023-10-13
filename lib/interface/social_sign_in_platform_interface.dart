import 'package:flutter/cupertino.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../social_sign_in.dart';
import '../social_sign_in_mobile.dart';

abstract class SocialSignInPlatform extends PlatformInterface {
  /// Constructs a SocialSignInPlatform.
  SocialSignInPlatform() : super(token: _token);

  static final Object _token = Object();

  static SocialSignInPlatform _instance = SocialSignInMobile();

  /// The default instance of [SocialSignInPlatform] to use.
  ///
  /// Defaults to [SocialSignInMobile].
  static SocialSignInPlatform get instance => _instance;

  static final Map<SocialPlatform, SocialSignInSite> _siteList = {};
  ///
  ///
  ///
  static SocialSignInSite? getSite (SocialPlatform site) => _siteList[site];
  static void setSite(SocialPlatform site, SocialSignInSite data) => _siteList[site] = data;

  static SocialSignInSite? lastSite;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SocialSignInPlatform] when
  /// they register themselves.
  static set instance(SocialSignInPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<SocialSignInResultInterface> signInSite(SocialPlatform site, BuildContext context) async {
    throw UnimplementedError('signIn() has not been implemented.');
  }

  Future<SocialSignInResultInterface> signIn(BuildContext context) async {
    try {
      if(lastSite == null) return SocialSignInFail(errorMessage: "Uninitialized site");
      return await lastSite!.signIn(context);
    }catch (e){
      if(e is SocialSignInException){
        return SocialSignInFail(
            status: e.status,
            errorMessage: e.description
        );
      }
      else {
        return SocialSignInFail(errorMessage: e.toString());
      }
    }
  }

  void initialSite(SocialSignInSiteConfig config, SocialSignInPageInfo pageInfo){
    throw UnimplementedError('initialSite() has not been implemented.');
  }
}
