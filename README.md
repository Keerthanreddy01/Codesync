# CodeSync Arena - Multiplayer Competitive Coding Platform

A production-ready Flutter application for multiplayer competitive coding battles with real-time collaboration, Git-style branching, and AI-powered code judging.

## Project Overview

CodeSync Arena enables teams of 1-10 developers to:
- Compete in real-time coding challenges
- Collaborate using Git-style branching
- Get AI feedback on code efficiency, quality, and best practices
- Climb the global leaderboard
- Unlock achievements and badges

## Technology Stack

### Frontend
- **Flutter 3.x** - Cross-platform mobile and desktop development
- **Dart 3.x** - Modern, type-safe programming language
- **Riverpod** - Reactive state management

### Backend & Services
- **Firebase** - Authentication, Realtime Database, Firestore, Storage
- **Agora SDK** - Real-time voice chat
- **Judge0 API** - Code execution and testing (production)

### Local Storage
- **Hive** - Local NoSQL database
- **SharedPreferences** - Key-value storage
- **SQLite** - Structured data caching

## Project Structure

```
lib/
├── main.dart                          # Application entry point
├── app.dart                           # App configuration & initialization
├── core/
│   ├── constants/
│   │   └── app_constants.dart        # Application-wide constants
│   ├── theme/
│   │   ├── app_theme.dart            # Colors, typography, spacing
│   │   └── theme_config.dart         # ThemeData configuration
│   ├── utils/
│   │   └── validation_utils.dart     # Input validation helpers
│   └── config/
│       └── router.dart               # Navigation configuration
├── data/
│   ├── models/
│   │   ├── user_model.dart           # User data model
│   │   └── auth_request_models.dart  # Authentication request models
│   ├── repositories/
│   │   └── auth_repository.dart      # Authentication repository
│   └── data_sources/
│       ├── local/
│       │   └── local_auth_data_source.dart  # Local auth storage
│       └── remote/
│           └── (Firebase data sources)
├── domain/
│   ├── entities/
│   │   └── user_entity.dart          # Core user entity
│   ├── repositories/
│   │   └── (Abstract repositories)
│   └── use_cases/
│       └── (Use case implementations)
├── presentation/
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── welcome_screen.dart       # Welcome/splash screen
│   │   │   ├── login_screen.dart         # Login screen
│   │   │   ├── signup_screen.dart        # Sign up screen
│   │   │   ├── password_reset_screen.dart # Password reset
│   │   │   └── profile_setup_screen.dart  # Profile setup
│   │   ├── onboarding/
│   │   │   └── onboarding_screen.dart    # Onboarding tutorial
│   │   └── main/
│   │       └── home_screen.dart          # Home screen
│   ├── widgets/
│   │   └── auth_widgets.dart         # Reusable auth widgets
│   └── providers/
│       └── auth_providers.dart       # Riverpod providers
└── services/
    ├── auth/
    │   └── firebase_auth_service.dart    # Firebase auth service
    ├── database/
    │   └── (Database services)
    └── firebase/
        └── (Firebase services)
```

## Getting Started

### Prerequisites
- Flutter 3.x installed
- Dart 3.x installed
- Firebase project created
- Google Cloud Console configured

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/codesync-arena.git
cd codesync-arena
```

2. **Get dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**
   - Download `google-services.json` from Firebase Console (Android)
   - Download `GoogleService-Info.plist` from Firebase Console (iOS)
   - Place files in the appropriate directories

4. **Update Firebase configuration**
   - Edit `lib/firebase_options.dart`
   - Replace placeholder API keys with your actual Firebase credentials

5. **Run the app**
```bash
flutter run
```

## Architecture

### Clean Architecture Layers

#### 1. **Presentation Layer** (UI)
- Screens and widgets
- Riverpod providers for state management
- User interactions and navigation

#### 2. **Domain Layer** (Business Logic)
- Entities (User, Battle, etc.)
- Abstract repositories
- Use cases

#### 3. **Data Layer** (Data Management)
- Models (for serialization)
- Repository implementations
- Data sources (local & remote)

### State Management with Riverpod

All state is managed using Riverpod providers:
- `authStateProvider` - Current authentication state
- `currentUserProvider` - Current logged-in user
- `signupProvider` - Sign up operation
- `loginProvider` - Login operation
- `googleSignInProvider` - Google Sign-In
- Custom providers for other features

## Authentication Flow

### Sign Up
1. User enters email and password
2. Password is validated (8+ chars, uppercase, lowercase, numbers)
3. Firebase creates auth account
4. User document is created in Firestore
5. User is redirected to profile setup

### Login
1. User enters credentials
2. Firebase authenticates user
3. User document is fetched from Firestore
4. Redirect to profile setup (if needed) or home

### Password Reset
1. User enters email
2. Firebase sends reset email
3. User clicks link in email
4. Password is reset
5. User can log in with new password

### Profile Setup
1. User enters username, display name, bio
2. Optional: User uploads avatar image
3. User profile is updated in Firestore
4. User is redirected to onboarding

### Onboarding
1. User sees tutorial slides (4 screens)
2. Each slide explains a feature
3. User completes onboarding
4. User is redirected to home

## Validation

Input validation is handled by `ValidationUtils`:

- **Email**: RFC 5322 compatible regex
- **Password**: 8+ chars, uppercase, lowercase, numbers
- **Username**: 3-32 chars, alphanumeric + underscore/hyphen
- **Display Name**: 2-50 chars
- **Bio**: Max 500 chars

Password strength indicator shows real-time feedback:
- Very Weak (0)
- Weak (1)
- Fair (2)
- Good (3)
- Strong (4)

## Error Handling

All Firebase operations are wrapped in try-catch blocks with user-friendly error messages:

- `invalid-email` → "Invalid email address"
- `user-disabled` → "This account has been disabled"
- `wrong-password` → "Incorrect password"
- `email-already-in-use` → "Email already in use"
- `weak-password` → "Password is too weak"

## Data Models

### User Model
```dart
class UserModel {
  String id
  String email
  String? displayName
  String? photoUrl
  String? username
  String? bio
  int xp (default: 0)
  int level (default: 1)
  DateTime createdAt
  DateTime lastSignedIn
  bool emailVerified
  bool hasCompletedOnboarding
}
```

## Firebase Database Schema

### Firestore Collections

#### `users` Collection
```json
{
  "id": "user_id",
  "email": "user@example.com",
  "displayName": "John Doe",
  "photoUrl": "https://...",
  "username": "john_dev",
  "bio": "Passionate developer",
  "xp": 1250,
  "level": 5,
  "createdAt": "2025-01-05T00:00:00Z",
  "lastSignedIn": "2025-01-05T12:30:00Z",
  "emailVerified": true,
  "hasCompletedOnboarding": true
}
```

### Realtime Database (for live features)
```json
{
  "battles": {},
  "chat": {},
  "presence": {}
}
```

## UI/UX Design System

### Color Scheme (Dark Theme)
- **Primary**: #3B82F6 (Blue)
- **Secondary**: #10B981 (Green)
- **Background**: #0D1117
- **Surface**: #161B22
- **Error**: #EF4444
- **Success**: #10B981

### Typography
- **Headings**: Inter Bold
- **Body**: Inter Regular
- **Code**: JetBrains Mono

### Spacing Scale
- xs: 4px
- sm: 8px
- md: 12px
- lg: 16px
- xl: 24px
- xxl: 32px

### Border Radius
- xs: 4px
- sm: 8px
- md: 12px
- lg: 16px

### Animations
- Duration: 200-300ms
- Easing: Curves.easeInOut
- Smooth page transitions with GoRouter

## Features Implemented (Phase 1)

✅ Email/Password Authentication
✅ Google Sign-In
✅ Password Reset
✅ User Profile Setup
✅ Onboarding Tutorial
✅ Local Data Caching
✅ Navigation with GoRouter
✅ Error Handling
✅ Input Validation
✅ Responsive Design

## Features Coming Soon (Phase 2+)

- [ ] Team Creation & Management
- [ ] Battle Creation & Matchmaking
- [ ] Git-Style Branch System
- [ ] Live Code Editor
- [ ] Real-time Code Synchronization
- [ ] Voice Chat (Agora)
- [ ] Code Execution & Testing
- [ ] AI Judge System
- [ ] Leaderboard & Rankings
- [ ] Achievements & Badges
- [ ] Tournament System
- [ ] Spectator Mode
- [ ] Social Features

## Testing

### Unit Tests
```bash
flutter test test/unit
```

### Widget Tests
```bash
flutter test test/widget
```

### Integration Tests
```bash
flutter test test/integration
```

### Code Coverage
```bash
flutter test --coverage
```

## Build & Deployment

### Debug Build
```bash
flutter run
```

### Release Build

**Android:**
```bash
flutter build apk --release
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

**Desktop (Windows/Mac/Linux):**
```bash
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

## Environment Variables

Create a `.env` file (use `.env.example` as template):

```env
FIREBASE_PROJECT_ID=codesync-arena
GOOGLE_CLIENT_ID=your_google_client_id.apps.googleusercontent.com
JUDGE0_API_KEY=your_judge0_api_key
```

## Performance Optimization

- ✅ Lazy loading of data
- ✅ Const constructors throughout
- ✅ Efficient image caching with `cached_network_image`
- ✅ Debounced input validation
- ✅ Virtual scrolling for long lists (future)
- ✅ Code splitting and lazy code loading

## Security Best Practices

- ✅ Firebase Security Rules enforce access control
- ✅ Sensitive data encrypted in transit (HTTPS)
- ✅ Local data encrypted with Hive
- ✅ Input validation on all forms
- ✅ Rate limiting on API calls
- ✅ User authentication required for protected routes

## Troubleshooting

### Firebase Initialization Error
- Check that `google-services.json` and `GoogleService-Info.plist` are in correct locations
- Verify Firebase project ID matches configuration

### Google Sign-In Not Working
- Verify Google OAuth credentials are configured in Google Cloud Console
- Check that `signing_fingerprint.json` is available for Android

### Hot Reload Issues
- Run `flutter clean` to clear build cache
- Restart the development server

## Contributing

1. Create a feature branch (`git checkout -b feature/amazing-feature`)
2. Commit changes (`git commit -m 'Add amazing feature'`)
3. Push to branch (`git push origin feature/amazing-feature`)
4. Open a Pull Request

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## Support

For issues, questions, or suggestions, please open an issue on GitHub or contact support@codesync-arena.com

## Changelog

### Version 1.0.0 (January 2025)
- Initial release with authentication system
- Email/password and Google Sign-In
- User profile setup
- Onboarding tutorial
- Complete navigation flow

---

**Built with ❤️ using Flutter and Dart**
