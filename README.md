# Re-kollect

Flutter + Firebase MVP built directly from the attached PRD.

Implemented scope only:
- Firebase Phone Authentication onboarding for Generator and Collector roles.
- Firestore-backed `users`, `collectors`, and `requests` collections.
- Generator pickup request form with generator type, waste type, OpenStreetMap/Nominatim location lookup, map pin, directions/landmarks, and payment disclaimer.
- Collector dashboard with real-time request list, OpenStreetMap markers, generator-type tags/icons, claim, complete, and call-customer actions.
- Call buttons open the native dialer through Flutter platform channels.
- Firebase Cloud Messaging client setup for role topics.
- Plus Jakarta Sans and PRD-defined glassmorphism/eco-green UI.

## Firebase setup

Add your Firebase configuration before running:
- Android: place `google-services.json` in `android/app/` and set the Firebase values in `lib/firebase_options.dart`.
- iOS: place `GoogleService-Info.plist` in `ios/Runner/` and set the Firebase values in `lib/firebase_options.dart`.
- Enable Firebase Phone Authentication, Firestore, and Firebase Cloud Messaging.
- Whitelist hackathon test phone numbers/codes in the Firebase console.

## Run

```bash
flutter pub get
flutter run
```
# rekollect
