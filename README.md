# social_sign_in

A Social Sign In Flutter project on Android, iOS, MacOS and Windows.
Current supported social provider: 
   Apple, Facebook, Google, Microsoft.

## Getting started

Add your library to `pubspec.yaml`
```yaml
depedencies:
    social_sign_in: ^0.0.5
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


### Microsoft
* Ref: [akamai Microsoft Online social login guide](https://techdocs.akamai.com/identity-cloud/docs/the-microsoft-online-social-configuration-guide)
* In Step 3. click Azure Active Directory, and then, in the navigation panel, click App registrations.

### Google
* Ref: [FlutterFire Social Authentication](https://firebase.flutter.dev/docs/auth/social/#google)

### Facebook
* Ref: [FlutterFire Social Authentication](https://firebase.flutter.dev/docs/auth/social/#google)



## Usage
### Setup
* Import it in your code.
```dart
import 'package:social_sign_in/social_sign_in.dart';
```

### Login
* Configure site information and trigger.
```dart
SocialSignIn().initialSite(FacebookSignInConfig(
      clientId: SocialPrivateData.facebookClientId,
      clientSecret: SocialPrivateData.facebookClientSecret,
      redirectUrl: SocialPrivateData.simpleRedirectUrl,
    ), null);



OutlinedButton(
    onPressed: () async {
	final authResult = await SocialSignIn().signInSite(SocialPlatform.facebook, context);
	printSignInResult(authResult);
    }, child: const Text('Login with Facebook'),
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
