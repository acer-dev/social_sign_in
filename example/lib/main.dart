import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:social_sign_in/site/facebook/facebook_sign_in_config.dart';
import 'package:social_sign_in/social_sign_in.dart';
import 'package:social_sign_in_example/private_data.dart';

void main() {
  try {

    SocialSignIn().initialSite(FacebookSignInConfig(
      clientId: SocialPrivateData.facebookClientId,
      clientSecret: SocialPrivateData.facebookClientSecret,
      redirectUrl: SocialPrivateData.simpleRedirectUrl,
    ), null);
  }catch(e){
    debugPrint("initial exception ${e.toString()}");
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _result = "None";
  String _detail = "";

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    printSignInResult(SocialSignInResultInterface result){
      if(result.status != SignInResultStatus.ok) {
        setState(() {
          _detail = result.errorMessage;
          _result = result.status == SignInResultStatus.cancelled ? "Cancelled" : "Failed";
        });
      }
      else {
        String tmp = "${result.accessToken} ${result.idToken}";

        if(tmp.length > 20) {
          tmp = "${tmp.substring(0,17)}...";
        }
        setState(() {
          _detail = "Access Token: $tmp";
          _result = "Success";
        });
      }
    }

    return Scaffold(
      body: Center(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: _result == "Success" ? Colors.green : Colors.yellow,
              child: Text("Social sign-in: $_result"),
            ),
            Text(_detail),
	    SignInButton(
              Buttons.facebook,
              onPressed: () async {
                // Trigger the sign-in flow
                final authResult = await SocialSignIn().signInSite(SocialPlatform.facebook, context);
                printSignInResult(authResult);
              },
            ),
        ],),
      )
    );
  }
}
