# Quick Start Guide

Get CodeSync Arena running in 5 minutes!

## Prerequisites

✅ Flutter 3.x installed
✅ Dart 3.x installed
✅ Git installed
✅ A code editor (VS Code, Android Studio, etc.)

## 1. Clone & Setup (2 min)

```bash
# Clone the repository
git clone <repo-url>
cd CodeSync

# Get dependencies
flutter pub get
```

## 2. Configure Firebase (2 min)

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create new project or use existing "codesync-arena"
3. Download credentials:
   - **Android**: `google-services.json` → `android/app/`
   - **iOS**: `GoogleService-Info.plist` → `ios/Runner/`
4. Update `lib/firebase_options.dart` with your API keys

## 3. Run the App (1 min)

```bash
# Start emulator/simulator
flutter emulators --launch <emulator_id>  # or open Simulator

# Run the app
flutter run
```

## 4. Test Authentication

1. **Welcome Screen** - Tap "Get Started"
2. **Sign Up** - Create account with email/password
3. **Profile Setup** - Add username and display name
4. **Onboarding** - Swipe through 4 tutorial slides
5. **Home Screen** - Welcome message with user info

## Useful Commands

```bash
# Hot reload during development
flutter run
# Press 'r' for hot reload
# Press 'R' for hot restart
# Press 'q' to quit

# Clean build
flutter clean

# Analyze code
flutter analyze

# Format code
dart format lib/

# Run tests
flutter test

# Build for release
flutter build apk --release    # Android
flutter build ios --release   # iOS
flutter build web --release   # Web
```

## File Structure Overview

```
lib/
├── main.dart                          # Entry point
├── app.dart                           # App configuration
├── core/
│   ├── constants/app_constants.dart
│   ├── theme/app_theme.dart
│   └── config/router.dart             # Navigation
├── data/
│   ├── models/user_model.dart
│   └── repositories/auth_repository.dart
├── presentation/
│   ├── screens/auth/                  # Login, signup, etc.
│   ├── screens/onboarding/            # Onboarding tutorial
│   ├── screens/main/home_screen.dart
│   ├── widgets/auth_widgets.dart      # Reusable components
│   └── providers/auth_providers.dart  # State management
└── services/
    └── auth/firebase_auth_service.dart
```

## Key Screens

| Screen | Route | Purpose |
|--------|-------|---------|
| Welcome | `/welcome` | Splash/welcome screen |
| Login | `/login` | Email/password login |
| Sign Up | `/signup` | Create new account |
| Forgot Password | `/forgot-password` | Password reset |
| Profile Setup | `/profile-setup` | Complete user profile |
| Onboarding | `/onboarding` | Tutorial walkthrough |
| Home | `/home` | Main app screen |

## Authentication Methods

### Email/Password
```
Email: your@email.com
Password: MyPassword123
```
- Minimum 8 characters
- Must have uppercase, lowercase, numbers
- Real-time strength indicator

### Google Sign-In
- Click "Sign in with Google"
- Authenticate with Google account
- Auto-creates account

## Features Implemented ✅

- ✅ Email/password authentication
- ✅ Google Sign-In
- ✅ Password reset
- ✅ User profile creation
- ✅ Onboarding tutorial
- ✅ Navigation routing
- ✅ Form validation
- ✅ Error handling
- ✅ Local data caching
- ✅ Dark theme UI

## Troubleshooting

### Firebase Not Connecting
```bash
# Check your credentials in firebase_options.dart
# Verify google-services.json exists in android/app/
# Run: flutter clean && flutter pub get
```

### Google Sign-In Not Working
```bash
# Get SHA-1 fingerprint
cd android
./gradlew signingReport

# Add to Firebase Console → Project Settings → Android
```

### Build Errors
```bash
# Clean everything
flutter clean
rm -rf ios/Pods ios/Podfile.lock

# Rebuild
flutter pub get
flutter run
```

## What's Next?

### Phase 2 (Team Management)
- [ ] Create teams
- [ ] Invite members
- [ ] Manage roles
- [ ] Team chat

### Phase 3 (Battles)
- [ ] Create battles
- [ ] Join battles
- [ ] Real-time matchmaking
- [ ] Problem library

### Phase 4 (Coding Arena)
- [ ] Code editor
- [ ] Syntax highlighting
- [ ] Real-time sync
- [ ] Live cursors

### Phase 5 (Judging)
- [ ] AI judge system
- [ ] Code execution
- [ ] Test cases
- [ ] Scoring

### Phase 6 (Advanced)
- [ ] Voice chat
- [ ] Leaderboard
- [ ] Achievements
- [ ] Tournaments

## Important Files to Know

| File | Purpose |
|------|---------|
| `pubspec.yaml` | Dependencies & project config |
| `lib/firebase_options.dart` | Firebase credentials |
| `lib/core/theme/app_theme.dart` | Design system |
| `lib/presentation/providers/auth_providers.dart` | State management |
| `lib/services/auth/firebase_auth_service.dart` | Firebase integration |

## Design Resources

### Colors
- Primary Blue: `#3B82F6`
- Secondary Green: `#10B981`
- Background: `#0D1117`
- Text: `#FFFFFF`

### Typography
- Headings: Inter Bold
- Body: Inter Regular
- Code: JetBrains Mono

## Code Examples

### Access Current User
```dart
final authState = ref.watch(authStateProvider);
authState.whenData((state) {
  if (state.user != null) {
    print('User: ${state.user!.email}');
  }
});
```

### Sign Up
```dart
final request = SignupRequest(
  email: 'user@example.com',
  password: 'Password123',
  confirmPassword: 'Password123',
);
await ref.read(signupProvider(request).future);
```

### Sign In
```dart
final request = LoginRequest(
  email: 'user@example.com',
  password: 'Password123',
);
await ref.read(loginProvider(request).future);
```

## Performance Tips

1. **Hot Reload**: Use during development (press 'r')
2. **Hot Restart**: When hot reload fails (press 'R')
3. **DevTools**: Monitor performance and state
4. **Profile**: Use `--profile` flag for performance testing

## Resources

- [Complete README](README.md)
- [Firebase Setup Guide](FIREBASE_SETUP.md)
- [Installation Guide](SETUP.md)
- [Implementation Summary](IMPLEMENTATION_SUMMARY.md)
- [Flutter Docs](https://flutter.dev)
- [Firebase Docs](https://firebase.google.com/docs)

## Common Issues & Solutions

### Issue: "Firebase not initialized"
**Solution**: Ensure `google-services.json` and `GoogleService-Info.plist` are in correct locations

### Issue: "Google Sign-In fails on Android"
**Solution**: Add SHA-1 fingerprint to Firebase project settings

### Issue: "Hot reload not working"
**Solution**: Use hot restart (R) or restart `flutter run`

### Issue: "State not updating"
**Solution**: Ensure using Riverpod providers correctly with `ref.watch()`

## Getting Help

1. Check the guides (`README.md`, `SETUP.md`, `FIREBASE_SETUP.md`)
2. Review inline code comments
3. Check Flutter/Firebase documentation
4. Run `flutter doctor` to verify setup

## Summary

You now have a **production-ready authentication system** for CodeSync Arena! 🚀

- Complete auth flows
- User management
- Input validation
- Error handling
- Professional UI
- Clean architecture

Ready to build Phase 2? Check the implementation guides and start with team management!

---

**Happy Coding!** 💻
