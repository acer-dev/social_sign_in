# social_sign_in

A Flutter plugin that helps to sign in with Facebook, Google, Microsoft and Apple using Firebase.

## Getting started

Add the library to your project.
```yaml
dependencies:
    social_sign_in: ^0.0.5
```

## Firebase setup

Follow the steps below to configure.

1. Sign into [Firebase console](https://console.firebase.google.com/u/0/) using your Google account.
2. Create a project in Firebase console.
3. Under your project, click **Authentication** to enable the function.
4. Before enable each provider, you need to create an app separately in the Meta for Developers, Google Console, Microsoft Azure and Apple Developer.
5. Navigate to the **Sign-in Method** tab to enable providers you want to support as a sign-in provider.
6. Except Google Sign-in, you need to configure the Redirect URL  on the console website of social providers you want to support as the URL generated when you enable specific social provider

###  Sign in with Facebook

1. Start the app creation process in Meta for Developers.
2. Choose a use case which determines permissions, products and APIs are available to your app.
3. Set your app name and email.
4. Specify your app's Client ID, Client Secret you just created in the project .
* Ref: [FlutterFire Social Authentication](https://firebase.flutter.dev/docs/auth/social/#facebook)

###  Sign in with Google

1. Create authorization credentials in Google Console.
2. Specify your app's Client ID, Client Secret you just created in the project.

* Ref: [FlutterFire Social Authentication](https://firebase.flutter.dev/docs/auth/social/#google)

###  Sign in with Microsoft
1. Login Azure portal and click Azure Active Directory, and then, in the navigation panel, click **App registrations** to register an application.
2. Enter your **Application Name** and pick **Accounts in any organizational directory (Any Azure AD directory - Multitenant) and personal Microsoft accounts(eg. Skype, Xbox)** to allow for Sign-in from both organization and public accounts. 
3. Choose **Web** as the Redirect URI and enter the Redirect URI in Firebase Console under Authentication > Sign-In Method > Enable Microsoft provider.
4. Add new client secret in **Certificates and secrets**.
5. Specify your app's Client ID, Client Secret you just created in the project.

* Ref: [Register an application with the Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app)

6. For some uncertain reasons, it may be failed to obtain the Firebase token when Sign-in with Microsoft account. It is required to implement the function  to validate that the access token has been successfully acquired to get the Firebase token. You can refer to following codes.

* Deploy an API on **Firebase Cloud Function** to validate access token like:
    ```js
    exports.verifyMicrosoft = functions.https.onRequest(async (req, res) => {
        if (!req.body.token) {
            return res.status(400).send('Access Token not found');
        }
        const reqToken = req.body.token;
        const profile = await axios.get('https://graph.microsoft.com/v1.0/me',{
            headers:{
                Authorization: `Bearer ${reqToken}`
            }
        });
        
        if(profile.status === 200 && profile.data.id) {

            const uid = 'microsoft:'+profile.data.id;
            const email = profile.data.mail;
                
            const firebaseToken = await admin.auth().createCustomToken(
                uid, {
                    provider: 'hotmail.com'
                }
            );
            if(email) {
                admin.auth().updateUser(
                    uid, {
                        email: email
                    }
                );
            }
            res.status(200).send({
                accessToken: firebaseToken
            });
        }
        else {
            res.sendStatus(401);
        }
    });
    ```

### Sign in with Apple

1. As you build in Xcode, it will automatically create an app in the Apple Developer [Certificates, Identifiers & Profiles](https://developer.apple.com/account/resources/identifiers/list/bundleId). If it's not, create it yourself, set the Description and Bundle ID. 
2. Add the **Sign In with Apple** capability and restart the app in Xcode. (Runner (file browser side bar) -> Targets -> Runner -> Signing & Capabilities).
3. [Create a Service ID](https://developer.apple.com/account/resources/identifiers/list/serviceId) and enable service **Sign In With Apple** (configure it later). 
4. [Create a key](https://developer.apple.com/account/resources/authkeys/list) and Enable Service **Sign In With Apple**.
5. Navigate to the **Sign-In Method** tab to enable Apple provider as a sign-in provider in Firebase console.
6. Enter the **Service ID** (created in step 3), **Team ID**, **Key ID**, and **Private Key** (created in step 4, download the key as a file with .p8 file extension format). 

7. In order to sign in with Apple on Android and Windows devices, additional configuration is required.

* Android
    1. Deploy an API on Firebase Cloud Function to get **redirect URL** like: \
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
    4. Deploy a web page with Apple Sign-In functionality.
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
                    clientId: urlParams.get('clientId'),
                    redirectURI: urlParams.get('redirectUrl'),
                    scope: urlParams.get('scope'),
                    state: urlParams.get('state'),
                    nonce: urlParams.get('nonce')
                });
            </script>
        </body>
        </html>
        ```
* Windows
    1. Deploy an API on Firebase Cloud Function to get **redirect URL** like: \
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
    2. Deploy a page on firebase hosting to get host page URL like: \
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
    3. Configure in Apple developer site setting service ids with **redirect URL**, **redirect domain**, and **host page domain**.

## Usage

Import social_sign_in.dart.

```dart
import 'package:social_sign_in/social_sign_in.dart';
```

### Login

Call the method by following examples. Refer to the **example** folder and the source code for more information.

The provided examples showcase two approaches to logging in. You can choose the one that best fits your needs.

* Configuration and triggering the login in a single step:
    ```dart
    SocialSignIn().initialSite(FacebookSignInConfig(
        clientId: [YOUR FACEBOOK CLIENT ID],
        clientSecret: [YOUR FACEBOOK CLIENT SECRET],
        redirectUrl: [YOUR LOGIN REDIRECT URL],
        ), null);

    OutlinedButton(
        onPressed: () async {
        final authResult = await SocialSignIn().signInSite(SocialPlatform.facebook, context);
        printSignInResult(authResult);
        }, child: const Text('Login with Facebook'),
    ),
    ```
* Configuration and login triggering into two steps:
    ```dart
    OutlinedButton(
        onPressed: () async {
            SocialSignIn()
            .initialSite(GoogleSignInConfig(
                clientId: [YOUR GOOGLE CLIENT ID],
                clientSecret: [YOUR GOOGLE CLIENT SECRET],
                redirectUrl: [YOUR LOGIN REDIRECT URL],
            ), null)
            .signIn(context).then((authResult) => {
                
            });
        },
        child: const Text('Login with Google')
    ),
    ```
