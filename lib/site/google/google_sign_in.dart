
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../social_sign_in.dart';
import '../../webView/social_sign_in_page_mobile.dart';
import 'google_sign_in_config.dart';
import 'google_sign_in_result.dart';

export 'google_sign_in_result.dart';
export 'google_sign_in_config.dart';


class GoogleSignIn extends SocialSignInSite {
  @override
  String clientId;
  @override
  String clientSecret;
  @override
  String redirectUrl;
  @override
  String scope;

  @override
  SocialSignInPageInfo pageInfo = DefaultSignInPageInfo();

  final String _authorizedUrl =
      "https://accounts.google.com/o/oauth2/v2/auth";
  final String _accessTokenUrl =
      "https://www.googleapis.com/oauth2/v3/token";

  GoogleSignIn({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUrl,
    required this.scope,
  });

  @override
  String authUrl() {
    return "$_authorizedUrl?response_type=code&client_id=$clientId&redirect_uri=$redirectUrl&state=$stateCode&scope=$scope";
  }

  @override
  Future<dynamic> signInWithWebView(BuildContext context) async{
    bool isFinish = false;

    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            SocialSignInPageMobile(
              url: authUrl(),
              redirectUrl: redirectUrl,
              userAgent: pageInfo.userAgent ?? "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.88 Mobile Safari/537.36",
              clearCache: pageInfo.clearCache,
              title: pageInfo.title,
              centerTitle: pageInfo.centerTitle,
              onPageFinished: (String url) {
                if(isFinish) return;
                if (url.contains("error=")) {
                  Navigator.of(context).pop(
                    Exception(Uri
                        .parse(url)
                        .queryParameters["error"]),
                  );
                } else if (url.startsWith(redirectUrl)) {
                  var uri = Uri.parse(url);
                  if(uri.queryParameters.containsKey('code') &&
                      uri.queryParameters.containsKey('state') &&
                      uri.queryParameters['state'] == stateCode){
                    isFinish = true;
                    Navigator.of(context).pop(uri.queryParameters["code"]);
                  }
                }
              },
            ),
      ),
    );
  }

  @override
  Future<SocialSignInResultInterface> exchangeAccessToken(String authorizationCode) async{
    var response = await http.post(
      Uri.parse(_accessTokenUrl),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "grant_type": "authorization_code",
        "redirect_uri": redirectUrl,
        "client_id": clientId,
        "client_secret": clientSecret,
        "code": authorizationCode
      },
    );

    if (response.statusCode == 200) {
      var body = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      if(body.containsKey("access_token")) {
        return GoogleSignInResult(
          SignInResultStatus.ok,
          accessToken: body["access_token"],
          idToken: body["id_token"] ?? "",
          state: stateCode,
        );
      } else {
        throw handleResponseBodyFail(body);
      }
    } else {
      throw handleUnSuccessCodeFail(response);
    }
  }

  factory GoogleSignIn.fromProfile(GoogleSignInConfig config){
    return GoogleSignIn(
      clientId: config.clientId,
      clientSecret: config.clientSecret,
      redirectUrl: config.redirectUrl,
      scope: config.scope.isNotEmpty ? config.scope.join(" ") : "profile email"
    );
  }
}