import 'package:flutter/cupertino.dart';
import 'social_sign_in.dart';
import 'dart:io';
import 'interface/social_sign_in_platform_interface.dart';
import 'site/facebook/facebook_sign_in_desktop.dart';
import 'site/google/google_sign_in_desktop.dart';
import 'site/microsoft/microsoft_sign_in_desktop.dart';
import 'site/apple/apple_sign_in_windows.dart';

/// An implementation of [SocialSignInPlatform] that uses method channels.
class SocialSignInDesktop extends SocialSignInPlatform {

  /// Registers this class as the default instance of [SocialSignInPlatform].
  static void registerWith() {
    SocialSignInPlatform.instance = SocialSignInDesktop();
  }

  @override
  void initialSite(SocialSignInSiteConfig config, SocialSignInPageInfo pageInfo){
    try {
      SocialSignInSite? siteInfo;
      switch (config.site) {
        case SocialPlatform.apple:
          if(config is AppleSignInConfig) {
            if(Platform.isMacOS){
              siteInfo = AppleSignIn.fromProfile(config);
            }
            else if(Platform.isWindows) {
              // throw UnsupportedError("Unsupported sign in with apple on windows.");
              siteInfo = AppleSignInWindows.fromProfile(config);
            }
          }
          break;
        case SocialPlatform.facebook:
          if(config is FacebookSignInConfig) {
            siteInfo = FacebookSignInDesktop.fromProfile(config);
          }
          break;
        case SocialPlatform.google:
          if(config is GoogleSignInConfig) {
            siteInfo = GoogleSignInDesktop.fromProfile(config);
          }
          break;
        case SocialPlatform.microsoft:
          if(config is MicrosoftSignInConfig) {
            siteInfo = MicrosoftSignInDesktop.fromProfile(config);
          }
          break;
        default:
          throw Exception("Unsupported social site of desktop!");
      }
      if(siteInfo == null){
        throw Exception("Site config miss match!");
      }
      siteInfo.pageInfo = pageInfo;
      SocialSignInPlatform.lastSite = siteInfo;
      SocialSignInPlatform.setSite(config.site, siteInfo);
    }catch (e){
      rethrow;
    }
  }

  @override
  Future<SocialSignInResultInterface> signInSite(SocialPlatform site, BuildContext context) async {
    try {
      var socialSite = SocialSignInPlatform.getSite(site);
      if(socialSite == null) return SocialSignInFail(errorMessage: "Uninitialized site");
      return await socialSite.signIn(context);
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
}
