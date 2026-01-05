# Installation & Setup Guide

Complete guide to set up CodeSync Arena development environment.

## System Requirements

### Windows/Mac/Linux
- **Flutter**: 3.x or higher
- **Dart**: 3.x or higher
- **Git**: Latest version
- **Node.js**: 16+ (for Firebase CLI)

### Mobile (Android)
- Android SDK 21+
- Android Studio 4.2+
- Android Gradle Plugin 7.0+

### Mobile (iOS)
- iOS 11.0+
- Xcode 13.0+
- CocoaPods

## Installation Steps

### 1. Install Flutter

#### Windows
```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH
# Set environment variable: FLUTTER_HOME=C:\path\to\flutter
# Add C:\path\to\flutter\bin to PATH

# Verify installation
flutter --version
dart --version
```

#### macOS
```bash
# Using Homebrew (recommended)
brew install flutter

# Or download directly
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH in ~/.zshrc or ~/.bash_profile
export PATH="$PATH:$HOME/flutter/bin"

# Verify installation
flutter --version
dart --version
```

#### Linux
```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH in ~/.bashrc or ~/.zshrc
export PATH="$PATH:$HOME/flutter/bin"

# Verify installation
flutter --version
dart --version
```

### 2. Install IDE Extensions

#### VS Code
```bash
code --install-extension Dart-Code.dart-code
code --install-extension Dart-Code.flutter
code --install-extension Riverpod.riverpod
code --install-extension esbenp.prettier-vscode
```

#### Android Studio
1. Preferences → Plugins
2. Search "Flutter"
3. Install Flutter plugin
4. Restart IDE

### 3. Clone Repository

```bash
git clone https://github.com/yourusername/codesync-arena.git
cd codesync-arena
```

### 4. Get Dependencies

```bash
flutter pub get
```

If you encounter issues:
```bash
flutter clean
flutter pub get
```

### 5. Configure Firebase

Follow [FIREBASE_SETUP.md](FIREBASE_SETUP.md) completely.

### 6. Generate Code (if using code generation)

```bash
# Generate Riverpod providers (if using riverpod_generator)
dart run build_runner build

# Watch mode for continuous generation
dart run build_runner watch
```

### 7. Run the App

#### On Emulator/Simulator
```bash
# Android
flutter emulators --launch <emulator_id>
flutter run

# iOS
open -a Simulator
flutter run
```

#### On Physical Device
```bash
# Android
adb devices  # List connected devices
flutter run

# iOS
flutter run
```

#### Web
```bash
flutter run -d chrome
```

## Development Setup

### Code Analysis

```bash
# Analyze code for issues
flutter analyze

# Format code
dart format lib/
flutter format lib/

# Fix issues automatically
dart fix --apply
```

### Linting

The project uses Flutter lints. Configuration in `analysis_options.yaml`.

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/unit/auth_test.dart

# With coverage
flutter test --coverage
coverage:format -i coverage/lcov.info -o coverage/html
```

## Project Structure

```
codesync-arena/
├── android/              # Android native code
├── ios/                  # iOS native code
├── lib/                  # Dart source code
│   ├── main.dart        # Entry point
│   ├── app.dart         # App configuration
│   ├── core/            # Core utilities and theme
│   ├── data/            # Data layer (models, repositories)
│   ├── domain/          # Domain layer (entities, use cases)
│   ├── presentation/    # Presentation layer (screens, widgets)
│   └── services/        # Services (Firebase, etc.)
├── test/                # Test files
├── pubspec.yaml         # Dependencies configuration
├── analysis_options.yaml # Linting rules
└── README.md            # This file
```

## Hot Reload

Works during development:

```bash
# Start app in debug mode
flutter run

# In IDE: Press 'r' for hot reload
# Press 'R' for hot restart
# Press 'q' to quit
```

## Environment Configuration

Create `.env` file in project root:

```env
FIREBASE_PROJECT_ID=codesync-arena
GOOGLE_CLIENT_ID=your_client_id.apps.googleusercontent.com
JUDGE0_API_KEY=your_judge0_key
```

Load in code:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

final projectId = dotenv.env['FIREBASE_PROJECT_ID'];
```

## Troubleshooting

### Flutter Doctor Issues

```bash
flutter doctor

# Fix issues shown
flutter doctor --android-licenses  # Accept Android licenses
```

### Build Issues

```bash
# Clean everything
flutter clean
rm -rf ios/Pods
rm ios/Podfile.lock

# Get fresh dependencies
flutter pub get

# Rebuild
flutter run
```

### Hot Reload Not Working

- Restart the IDE
- Use `flutter run` again
- Check for syntax errors

### Firebase Connection Issues

1. Verify credentials in `firebase_options.dart`
2. Check `google-services.json` exists (Android)
3. Check `GoogleService-Info.plist` exists (iOS)
4. Run `flutter clean && flutter pub get`

### Google Sign-In Not Working

**Android:**
- Get SHA-1: `cd android && ./gradlew signingReport`
- Add to Firebase console
- Verify in `google-services.json`

**iOS:**
- Check URL schemes in Xcode
- Verify `GoogleService-Info.plist` is in Xcode project

## Building for Release

### Android Release Build

```bash
# Create keystore
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10950 -alias upload

# Build APK
flutter build apk --release

# Build App Bundle (for Google Play)
flutter build appbundle --release
```

Output: `build/app/release/app-release.apk` or `.aab`

### iOS Release Build

```bash
# Build iOS app
flutter build ios --release

# Create IPA
cd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release -derivedDataPath build -archivePath build/Runner.xcarchive -allowProvisioningUpdates archive
xcodebuild -exportArchive -archivePath build/Runner.xcarchive -exportOptionsPlist ExportOptions.plist -exportPath build/ipa
```

### Web Release Build

```bash
flutter build web --release
# Output: build/web/
```

## Performance Optimization

### Profile the App

```bash
# Run with profile flag
flutter run --profile

# Or use DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

### Check Build Size

```bash
flutter build apk --release --analyze-size
flutter build appbundle --release --analyze-size
```

## Deployment

### Play Store

1. Create Google Play developer account
2. Create app listing
3. Build release AAB
4. Upload to Play Store Console
5. Fill in store listing
6. Submit for review

### App Store

1. Create Apple Developer account
2. Create app on App Store Connect
3. Build release IPA
4. Upload with Xcode
5. Fill in app details
6. Submit for review

## Continuous Integration

### GitHub Actions Example

Create `.github/workflows/test.yml`:

```yaml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
```

## Useful Commands

```bash
# List devices
flutter devices

# Get package info
flutter pub add package_name
flutter pub remove package_name

# Update dependencies
flutter pub upgrade
flutter pub outdated

# Create new feature
flutter create --org com.example feature_name

# Check for issues
flutter doctor
flutter analyze

# Format code
dart format lib/
flutter format lib/

# Build for different platforms
flutter build apk
flutter build appbundle
flutter build ios
flutter build web
flutter build windows
flutter build macos
flutter build linux
```

## Debugging

### Debug Mode
```bash
flutter run -d <device_id>
```

### DevTools
```bash
flutter pub global activate devtools
flutter pub global run devtools

# Or automatically launch with run:
flutter run --devtools
```

### Logging
```dart
import 'package:logger/logger.dart';

final logger = Logger();
logger.d('Debug message');
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message');
```

## Git Workflow

```bash
# Create feature branch
git checkout -b feature/auth-system

# Make changes and commit
git add .
git commit -m "feat: add authentication system"

# Push and create PR
git push origin feature/auth-system

# After merge, delete branch
git branch -d feature/auth-system
```

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)

## Support

For setup issues:
1. Check [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
2. Run `flutter doctor`
3. Check GitHub Issues
4. Contact: support@codesync-arena.com

---

**Last Updated**: January 2025
