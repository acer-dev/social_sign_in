import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../social_sign_in.dart';

export 'apple_sign_in_result.dart';
export 'apple_sign_in_config.dart';

class AppleSignIn extends SocialSignInSite {
  @override
  String clientId;
  @override
  String clientSecret = "";
  @override
  String redirectUrl;
  @override
  String scope = "";


  final List<AppleIDAuthorizationScopes> scopes = [];

  @override
  SocialSignInPageInfo pageInfo = DefaultSignInPageInfo();

  AppleSignIn({
    required this.clientId,
    required this.redirectUrl,
    this.scope = ""
  });

  @override
  String authUrl() {
    return "";
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String buildState({int p = 0}){
    final jsonState = json.encode({
      "c":stateCode,
      "p":p
    });
    final bytes = utf8.encode(jsonState);
    return base64.encode(bytes);
  }

  @override
  Future<SocialSignInResultInterface> signIn(BuildContext context) async {
    stateCode = generateString(10);// simple state code
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: scopes,
      nonce: nonce,
      state: buildState(),
      webAuthenticationOptions: Platform.isAndroid ? WebAuthenticationOptions(
        clientId: clientId,
        redirectUri: Uri.parse(redirectUrl),
      ) : null,
    );

    if(appleCredential.identityToken != null){
      return AppleSignInResult(
          SignInResultStatus.ok,
          state: stateCode,
          nonce: rawNonce,
          idToken: appleCredential.identityToken!
      );
    }
    else{
      return AppleSignInResult(
          SignInResultStatus.cancelled,
      );
    }
  }

  factory AppleSignIn.fromProfile(AppleSignInConfig config){
    var appleSignIn = AppleSignIn(
      clientId: config.clientId,
      redirectUrl: config.redirectUrl,
      scope: config.scope.isNotEmpty ? config.scope.join(" ") : "name email",
    );
    for(var scope in config.scope){
      if(scope == "email"){
        appleSignIn.scopes.add(AppleIDAuthorizationScopes.email);
      }else if(scope == "name"){
        appleSignIn.scopes.add(AppleIDAuthorizationScopes.fullName);
      }
    }
    return appleSignIn;
  }
}
