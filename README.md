
# unity


![ezgif com-gif-maker (2)](https://user-images.githubusercontent.com/38905681/115279317-dea3ee00-a146-11eb-85d5-55c3fda3395a.gif)

## About

Our goal is to bring people together for mindful practices.

Where humans unite for greater awareness.

Built buy humans for humans. Open Source.

Feel invited to participate by giving feedback and contributing.

## Getting started

### Flutter

Get started with [flutter](https://flutter.dev/docs/get-started/install)

### Firebase

Create a Firebase instance. Follow the instructions at https://console.firebase.google.com.

Go to the Firebase Console for your new instance.

Add Android App -> Add `android/app/google-services.json` for Android.



Click "Authentication" in the left-hand menu. Click the "sign-in method" tab.

Click "Email/Password" and "Google" (not yet) and enable it.

Add `ios/Runner/GoogleService-Info.plist` for iOS.

Search everywhere for `com.YOUR_COMPANY_NAME.YOUR_PROJECT_NAME` and replace with yours.




### Google Maps API

Setup Google Cloud Account.

Follow the instructions of [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) package.

Enable Google Maps API `https://console.cloud.google.com/google/maps-apis`.

Under APIs & Services -> Credentials -> Create credentials -> API key -> Get Api Key

Edit `secrets.json`.

For Android search for `YOUR_GOOGLE_MAPS_API_KEY` in `android/app/src/main/AndroidManifest.xml`.

For iOS search for `YOUR_GOOGLE_MAPS_API_KEY` in `ios/Runner/AppDelegate.swift`.


### Double check

The project_number `683044187809` and the package name `com.mibin.unity` should be replaced by your information.

After entering the credentials run `git update-index --skip-worktree android/app/src/main/AndroidManifest.xml ios/Runner/AppDelegate.swift secrets.json` to tell git that changes in these files will not be tracked anymore.

### Tech Stack

Flutter

Firebase

### Todos

- [x] upgrade to flutter 2.0
- [x] save credentials in a convienient way to make repo public
- [ ] write function to create sessions & users for testing
- [ ] make tags more beautiful
- [ ] decide font and colors
- [ ] split create session into several steps/screens
- [ ] test coverage 50 %
- [ ] google login
- [ ] facebook login
- [ ] implemnet comments of session
- [ ] HomeScreen (Start Search, Create, Next Session)
- [ ] Filter (Tags, distance, time)
- [ ] Share session (Whatsapp, FB, ... )
- [ ] Create translation file used by the intl package (german)





