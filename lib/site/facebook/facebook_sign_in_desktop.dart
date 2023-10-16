import 'package:flutter/material.dart';

import '../../webView/social_sign_in_page_desktop.dart';
import 'facebook_sign_in.dart';

export 'facebook_sign_in_result.dart';
export 'facebook_sign_in_config.dart';

class FacebookSignInDesktop extends FacebookSignIn {

  FacebookSignInDesktop({
    required super.clientId,
    required super.clientSecret,
    required super.redirectUrl,
    required super.scope,
  });

  @override
  Future<dynamic> signInWithWebView(BuildContext context) async{
    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            SocialSignInPageDesktop(
              url: authUrl(),
              redirectUrl: redirectUrl,
              userAgent: pageInfo.userAgent,
              title: pageInfo.title,
              centerTitle: pageInfo.centerTitle,
              onPageFinished: (String url) {
                if (url.contains("error=")) {
                  throw Exception(Uri
                      .parse(url)
                      .queryParameters["error"]);
                } else if (url.startsWith(redirectUrl)) {
                  var uri = Uri.parse(url);
                  if(uri.queryParameters.containsKey('code') &&
                      uri.queryParameters.containsKey('state') &&
                      uri.queryParameters['state'] == stateCode){
                    return uri.queryParameters["code"];
                  }
                  return "";
                }
                return null;
              },
            ),
      ),
    );
  }

  factory FacebookSignInDesktop.fromProfile(FacebookSignInConfig config){
    return FacebookSignInDesktop(
      clientId: config.clientId,
      clientSecret: config.clientSecret,
      redirectUrl: config.redirectUrl,
      scope: config.scope.isNotEmpty ? config.scope.join(" ") : "email public_profile",
    );
  }
}