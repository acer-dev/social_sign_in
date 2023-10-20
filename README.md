# social_sign_in

A Social Sign In Flutter project on Android, iOS, MacOS and Windows.
Current supported social provider: 
   Apple, Facebook, Google, Microsoft.

## Getting started

Add your library to `pubspec.yaml`
```yaml
depedencies:
    social_sign_in: ^0.2.6
```
## Site Prepare
### Apple
* Ref: [FlutterFire Social Authentication](https://firebase.flutter.dev/docs/auth/social/#apple)

#### Native on Android
1. Deploy an API on firebase cloud function to get **redirect URL** like: \
   **https://<firebase_project_id>.cloudfunctions.net/callbacks_sign_in_with_apple**
```js
exports.callbacks_sign_in_with_apple = functions.https.onRequest(async (request, response) => {
    const redirect = `intent://callback?${new URLSearchParams(
      request.body
    ).toString()}#Intent;package=${
      "[com.your.android_package]"
    };scheme=signinwithapple;end`;
  
    console.log(`Redirecting to ${redirect}`);
  
    response.redirect(307, redirect);
});
```
2. Configure in Apple developer site setting service ids with **redirect URL** and **domain**.
3. Modify **android/app/src/main/AndroidManifest.xml** 
```xml
<activity
    android:name="com.aboutyou.dart_packages.sign_in_with_apple.SignInWithAppleCallback"
    android:exported="true"
>
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />

        <data android:scheme="signinwithapple" />
        <data android:path="callback" />
    </intent-filter>
</activity>
```

#### Native on Windows
1. Deploy a page on firebase hosting to get host page URL like: \
   **https://<firebase_project_id>.firebaseapp.com/sign_in_with_apple.html**
```html
<html>
    <head>
    </head>
    <body>
        <script type="text/javascript" src="https://appleid.cdn-apple.com/appleauth/static/jsapi/appleid/1/en_US/appleid.auth.js"></script>
        <div id="appleid-signin" data-color="black" data-border="true" data-type="sign in"></div>
        <script type="text/javascript">
            const queryString = window.location.search;
            const urlParams = new URLSearchParams(queryString);
            AppleID.auth.init({
                clientId: urlParams.get('[YOUR_APPLE_SERVER_SERVICE_ID]'),
                redirectURI: urlParams.get('[YOUR_REDIRECT_URL]'),
                scope: urlParams.get('scope'),
                state: urlParams.get('state'),
                nonce: urlParams.get('nonce')
            });
        </script>
    </body>
</html>
```
2. Deploy an API on firebase cloud function to get **redirect URL** like: \
   **https://<firebase_project_id>.cloudfunctions.net/callbacks_sign_in_with_apple**
```js
exports.callbacks_sign_in_with_apple = functions.https.onRequest(async (request, response) => {
    redirect = `http://localhost?${new URLSearchParams(
        req.body
    ).toString()}`;
  
    console.log(`Redirecting to ${redirect}`);
  
    response.redirect(307, redirect);
});
```
3. Configure in Apple developer site setting service ids with **redirect URL**, **redirect domain**, and **host page domain**.

### GitHub
1. Obtain a GitHub account from [GitHub](https://github.com/).
2. Go to User Setting, and then, in the navigation panel, click Developer Settings.
3. In the navigation panel, click OAuth Apps, click the **New OAuth App** in primary panel.
4. Fill table and Register application.
5. Enter previous create app, get client id and generate client secrets.

### Line
1. Obtain a Line developer account from [LINE Developers](https://developers.line.biz/)
2. Log on the [Line devekoper console](https://developers.line.biz/console/)
3. Click Create in Providers panel.
4. Switch to previous create provider, in the primary panel, click **create new channel**, and then choise Line Login.
5. Fill table to create and wait for review.
6. Enter channel to get channel ID and Client secrets.
7. Switch tab to LINE Login and enable **Use LINE Login in your web app** and add Callback URL.

### Steam
1. Obtain a Steam developer account from [Steam Community](https://steamcommunity.com/).
2. Register an steam api key from [Registration page](https://steamcommunity.com/dev/apikey).

### Microsoft
* Ref: [akamai Microsoft Online social login guide](https://techdocs.akamai.com/identity-cloud/docs/the-microsoft-online-social-configuration-guide)
* In Step 3. click Azure Active Directory, and then, in the navigation panel, click App registrations.

### Google
* Ref: [FlutterFire Social Authentication](https://firebase.flutter.dev/docs/auth/social/#google)

### Facebook
* Ref: [FlutterFire Social Authentication](https://firebase.flutter.dev/docs/auth/social/#google)

### Discord
1. Obtain a Discord developer’ s account from [Discord Developer Portal](https://discord.com/developers).
2. In the navigation panel, click Applications, click the **New Applications** in primary panel.
3. Enter application, switch to OAuth2 in the navigation.
4. Generate client secret and enter redirect URL.

### Twitter
1. Obtain a Twitter developer’ s account from [Twitter Developer Platform](https://developer.twitter.com).
2. Create new app in Developer Portal.
3. Switch to Keys and tokens
4. Generate and get OAuth 2.0 Client ID and Client Secret.

### Tiktok
1. Obtain a TikTok developer’ s account from [TikTok for Developer](https://developers.tiktok.com/).
2. Click Manage apps in the top.
3. Enter data in primary panel.
4. Add Product **Login Kit** and **TikTok API**.
5. Save changes and submit for review.
6. Wait for review.

## Usage
### Setup
* Import it in your code.
```dart
import 'package:social_sign_in/social_sign_in.dart';
```

### Login
* Configure site information and trigger.
```dart
SocialSignIn().initialSite(GitHubSignInConfig(
    clientId: [YOUR GITHUB CLIENT ID],
    clientSecret: [YOUR GITHUB CLIENT SECRET],
    redirectUrl: [YOUR APP SERVER SIDE],
), DefaultSignInPageInfo(
    title: "Login with GitHub",
    centerTitle: true,
    clearCache: true
));

OutlinedButton(
    onPressed: () async {
        final authResult = await SocialSignIn().signInSite(SocialPlatform.gitHub, context);
    },
    child: const Text('Login with github')
),
```
* Configure and direct login. 
```dart
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
```
