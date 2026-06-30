# Lucky Money

Flutter prototype for a Thai lottery, gold price, and money news app.

## Current UI

- Home dashboard with gold price, next lottery draw, quick actions, and top news.
- Lottery checker with 6-digit input, mock prize board, and result state.
- My Numbers page for saved lottery numbers and notification state.
- Gold page with buy/sell prices, 7-day trend mock chart, calculator chips, and gold news.
- News feed with category chips and native-ad placeholders.

## Tech

- Flutter 3.32.8
- Android package: `com.callplay.luckymoney`
- iOS bundle id: `com.callplay.luckymoney`
- Mock data only for this first prototype.

## Run

```powershell
flutter pub get
flutter run
```

## Verified

```powershell
flutter analyze
flutter test
flutter build apk --debug
```

Debug APK output:

```text
build\app\outputs\flutter-apk\app-debug.apk
```

## Next Steps

- Connect real lottery results API.
- Connect gold price source and cache the latest quote.
- Add backend/admin flow for short money news.
- Add Firebase Messaging, Analytics, and Crashlytics.
- Add Google AdMob app id and real banner/native placements.
- Add privacy policy, terms, and store listing assets before release.
