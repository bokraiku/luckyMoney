# Lucky Money

Flutter prototype for a Thai lottery, gold price, and money news app.

## Features

### App Shell

- Flutter app scaffold for Android and iOS.
- Material 3 theme with a clean finance-utility visual style.
- Light mode and dark mode toggle with persisted preference.
- Bottom navigation with 5 tabs:
  - Home
  - Lottery Check
  - My Numbers
  - Gold
  - News
- Tab-specific generated background images bundled from `assets/backgrounds/`.
- Soft overlay surfaces so cards and Thai text stay readable on top of the images.

### Home

- Home dashboard with gold price, next lottery draw, quick actions, and top news.
- Gold price summary card.
- Next lottery draw countdown card.
- Quick actions for checking a number and saving a number.
- Top money-news preview feed.
- Sponsored/native ad placeholder.

### Lottery Check

- 6-digit lottery number input with numeric-only filtering.
- Draw selector for latest and historical lottery results.
- Prize matching through a reusable `LotteryResult.check()` domain method.
- Winner and non-winner result states.
- Save a checked number directly into My Numbers.
- Prize board for:
  - First prize
  - Front 3 digits
  - Back 3 digits
  - Last 2 digits
- Banner ad placeholder.

### My Numbers

- Saved lottery number list persisted locally with `SharedPreferences`.
- Add a new 6-digit number from the My Numbers tab.
- Save a checked number from the Lottery Check tab.
- Delete saved numbers.
- Draw date and note per saved number.
- Status badges:
  - Waiting
  - Winner
  - Not winner
- Notification toggle card for lottery result alerts.

### Gold

- Gold price screen with expanded buy/sell data.
- Gold bar buy/sell price.
- Gold ornament buy/sell price.
- Latest price-change badge.
- Mock 7-day trend chart.
- Gold price calculator chips for:
  - 1 baht
  - 2 salung
  - 1 salung
  - Half salung
- Gold news preview section.

### News

- Money-news feed for lottery, gold, government benefits, and scam alerts.
- Category filter chips.
- News cards with category, time, title, summary, and icon.
- Native ad placeholder inside the feed.

### Monetization-Ready UI

- Banner/native ad placeholders are already placed in the main user flows.
- Current ad components are placeholders only. Real Google AdMob integration is still a next step.

### Current Prototype Data

- Lottery result, saved numbers, gold prices, and news are mock data in `lib/main.dart`.
- No backend, real API, Firebase, push notification, or AdMob SDK is connected yet.

## Tech

- Flutter 3.32.8
- Riverpod for app state.
- SharedPreferences for local saved-number storage.
- SharedPreferences for saved theme mode preference.
- Android package: `com.callplay.luckymoney`
- iOS bundle id: `com.callplay.luckymoney`
- Mock data only for this first prototype.

## Current Architecture

```text
lib/
├─ app/              App shell, theme, navigation, background constants
├─ data/             Mock lottery, gold, news, and seeded saved-number data
├─ models/           Lottery, saved-number, gold, and news models
├─ providers/        Riverpod providers and saved-number controller
├─ repositories/     Lottery, local saved-number, and theme settings repositories
├─ screens/          Home, lottery check, my numbers, gold, and news screens
└─ widgets/          Shared cards, tiles, buttons, and page surfaces
```

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
