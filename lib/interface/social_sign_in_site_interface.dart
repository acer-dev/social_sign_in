part of 'package:social_sign_in/social_sign_in.dart';

abstract class SocialSignInPageInfo {
  String? get userAgent;
  bool get clearCache => true;
  String get title => "";
  bool? get centerTitle;
}

String _getRandomString(int length, String charset) {
  final random = math.Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

class DefaultSignInPageInfo extends SocialSignInPageInfo {
  @override
  String title;
  @override
  bool? centerTitle;
  @override
  String? userAgent;
  @override
  bool clearCache;

  DefaultSignInPageInfo({
    this.title = "",
    this.centerTitle,
    this.clearCache = true,
    this.userAgent,
  });
}

abstract class SocialSignInSiteConfig {
  SocialPlatform get site;
  String get clientId;
  set clientId(String value);
  String get clientSecret;
  set clientSecret(String value);
  String get redirectUrl;
  set redirectUrl(String value);
  List<String> get scope;
  set scope(List<String> value);
}

/// Authorization details from the login flow
abstract class SocialSignInResultInterface {
  set accessToken(String value);
  String get accessToken;
  set idToken(String value);
  String get idToken;
  set status(SignInResultStatus value);
  SignInResultStatus get status;
  set errorMessage(String value);
  String get errorMessage;
  set state(String value);
  String get state;
}

///Constructor for sign in
abstract class SocialSignInSite {
  String get clientId;
  set clientId(String value);
  String get clientSecret;
  set clientSecret(String value);
  String get redirectUrl;
  set redirectUrl(String value);
  String get scope;
  set scope(String value);
  SocialSignInPageInfo get pageInfo;
  set pageInfo(SocialSignInPageInfo value);
  late String stateCode;

  String? customStateCode() => null;
  String authUrl();
  String generateString(
          [int length = 32,
          String charset =
              'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890']) =>
      _getRandomString(length, charset);
  String generateNonce([int length = 32]) => _getRandomString(length,
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._');

  @protected
  Future<dynamic> signInWithWebView(BuildContext context) async {
    throw UnimplementedError('signInWithWebView() has not been implemented.');
  }

  ///To exchange an authorization code for an access token
  @protected
  Future<SocialSignInResultInterface> exchangeAccessToken(
      String authorizationCode) async {
    throw UnimplementedError('exchangeAccessToken() has not been implemented.');
  }

  ///Default signIn with webView flow
  Future<SocialSignInResultInterface> signIn(BuildContext context) async {
    stateCode = customStateCode() ?? generateString(10); // simple state code
    debugPrint("stateCode = $stateCode");

    var authorizedResult = await signInWithWebView(context);
    if (authorizedResult == null ||
        authorizedResult.toString().contains('access_denied')) {
      throw SocialSignInException(
          status: SignInResultStatus.cancelled,
          description: "Sign In attempt has been cancelled.");
    } else if (authorizedResult is Exception) {
      throw SocialSignInException(description: authorizedResult.toString());
    }
    String authorizedCode = authorizedResult;
    debugPrint("authorized_code: $authorizedCode");
    return await exchangeAccessToken(authorizedCode);
  }

  ///The error will be thrown when the token exchange fails.
  Exception handleResponseBodyFail(Map<String, dynamic> body) {
    if (body.containsKey("error")) {
      return SocialSignInException(
          description:
              "Unable to obtain token. Received: ${body["error_description"]}");
    } else {
      return SocialSignInException(description: "Unknown fail");
    }
  }

  ///The error will be thrown when the token exchange fails.
  Exception handleUnSuccessCodeFail(Response response) {
    var body =
        json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    if (body.containsKey("error")) {
      return SocialSignInException(
          description:
              "Unable to obtain token. Received: ${body["error_description"]}");
    } else {
      return SocialSignInException(
          description:
              "Unable to obtain token. Received: ${response.statusCode}");
    }
  }
}
