import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_sign_in/src/social_sign_in.dart';
import 'package:social_sign_in/src/interface/social_sign_in_platform_interface.dart';
import 'package:social_sign_in/src/social_sign_in_mobile.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSocialSignInResult implements SocialSignInResultInterface {
  @override
  String accessToken = 'accessToken';

  @override
  String errorMessage = '';

  @override
  String idToken = '';

  @override
  SignInResultStatus status = SignInResultStatus.ok;

  @override
  String state = '';
}

class MockSocialSignInSiteConfig implements SocialSignInSiteConfig {
  @override
  SocialPlatform get site {
    throw UnimplementedError();
  }

  @override
  String clientId = '';

  @override
  String clientSecret = '';

  @override
  String redirectUrl = '';

  @override
  List<String> scope = const [];
}

class MockSocialSignInPlatform
    with MockPlatformInterfaceMixin
    implements SocialSignInPlatform {
  @override
  SocialSignInPlatform initialSite(
          SocialSignInSiteConfig profile, SocialSignInPageInfo pageInfo) =>
      this;

  @override
  Future<SocialSignInResultInterface> signInSite(
      SocialPlatform site, BuildContext context) {
    return Future.value(MockSocialSignInResult());
  }

  @override
  Future<SocialSignInResultInterface> signIn(BuildContext context) {
    throw UnimplementedError();
  }
}

void main() {
  final SocialSignInPlatform initialPlatform = SocialSignInPlatform.instance;

  test('$SocialSignInMobile is the default instance', () {
    expect(initialPlatform, isInstanceOf<SocialSignInMobile>());
  });

  test('initialSite', () async {
    SocialSignIn socialSignInPlugin = SocialSignIn();
    MockSocialSignInPlatform fakePlatform = MockSocialSignInPlatform();
    SocialSignInPlatform.instance = fakePlatform;
    socialSignInPlugin.initialSite(MockSocialSignInSiteConfig(), null);
  });

  // test('signIn', () async {
  //   SocialSignIn socialSignInPlugin = SocialSignIn();
  //   MockSocialSignInPlatform fakePlatform = MockSocialSignInPlatform();
  //   SocialSignInPlatform.instance = fakePlatform;
  //   ;
  //   var result = await socialSignInPlugin.signIn(
  //       SocialSite.gitHub, context);
  //
  //   expect(result.status, SignInResultStatus.ok);
  //   expect(result.accessToken, 'accessToken');
  // });
}
