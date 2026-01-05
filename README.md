# 🚀 CodeSync Arena

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

**A revolutionary multiplayer competitive coding platform built with Flutter**

*Compete • Collaborate • Code • Conquer*

[📱 Demo](#demo) • [🚀 Features](#features) • [💻 Installation](#installation) • [📚 Documentation](#documentation)

</div>

---

## 🌟 About

CodeSync Arena is a Flutter-based application designed for competitive programming and collaborative coding. Built with modern technologies and clean architecture, it provides a solid foundation for multiplayer coding experiences. The project showcases best practices in Flutter development, Firebase integration, and scalable app architecture.

### 🎯 Key Highlights
- **Flutter Development** - Cross-platform mobile and desktop application
- **Firebase Integration** - Authentication and real-time data management
- **Clean Architecture** - Maintainable and scalable codebase
- **Modern UI** - Material Design 3 with responsive layouts
- **Professional Code** - Well-documented and tested implementation

## ✨ Features

### 🏆 Core Features
- **Authentication System** - Secure user registration and login
- **User Profiles** - Personalized developer profiles
- **Responsive Design** - Works across mobile, tablet, and desktop
- **Modern UI** - Clean Material Design 3 interface
- **Real-time Updates** - Live data synchronization

### 🔧 Technical Features
- **Multi-platform Support** - Android, iOS, Web, Windows
- **Clean Architecture** - Scalable and maintainable codebase
- **State Management** - Efficient app state handling with Riverpod
- **Firebase Integration** - Backend services and authentication
- **Code Quality** - Comprehensive testing and documentation

## 🛠️ Technology Stack

### Frontend
- **Flutter 3.x** - Modern cross-platform UI framework
- **Dart 3.x** - Type-safe, compiled programming language  
- **Riverpod** - Robust state management solution
- **Material Design 3** - Modern, accessible UI components

### Backend & Services
- **Firebase Suite** - Authentication and real-time database
- **Cloud Firestore** - Document-based data storage
- **Firebase Analytics** - Basic app usage tracking

### Architecture
- **Clean Architecture** - Separation of concerns and maintainable code
- **Repository Pattern** - Data abstraction and testability
- **Provider Pattern** - Reactive state management
- **Modular Design** - Scalable and organized code structure

## 📁 Project Structure

```
lib/
├── 📱 main.dart                    # Application entry point
├── 🚀 app.dart                     # App configuration & theme
├── 🔧 core/                        # Core utilities and configuration
│   ├── constants/                  # App-wide constants
│   ├── theme/                      # UI themes and styling
│   ├── utils/                      # Helper utilities
│   └── config/                     # App configuration
├── 📊 data/                        # Data layer
│   ├── models/                     # Data models and entities
│   ├── repositories/              # Data repositories
│   └── data_sources/              # Local and remote data sources
├── 🏗️ domain/                      # Business logic layer
│   ├── entities/                   # Domain entities
│   ├── repositories/              # Repository interfaces
│   └── use_cases/                 # Business use cases
├── 🎨 presentation/                # UI layer
│   ├── screens/                    # Application screens
│   ├── widgets/                    # Reusable UI components
│   └── providers/                  # State management
├── 🔧 services/                    # External services
│   ├── auth/                       # Authentication services
│   ├── database/                   # Database services
│   └── api/                        # API integrations
└── 🧪 test/                        # Unit and widget tests
```

## 🚀 Installation

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.0 or higher)
- [Dart SDK](https://dart.dev/get-dart) (3.0 or higher)
- [Firebase CLI](https://firebase.google.com/docs/cli) for backend setup
- Android Studio / Xcode for mobile development

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/Keerthanreddy01/Codesync.git
   cd Codesync
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for your project
   flutterfire configure
   ```

4. **Run the application**
   ```bash
   # For development
   flutter run
   
   # For specific platform
   flutter run -d android
   flutter run -d ios
   flutter run -d windows
   ```

### Environment Setup

Create a `.env` file in the root directory:
```env
# Firebase Configuration
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
FIREBASE_APP_ID=your-app-id

# Judge0 API (Optional - for code execution)
JUDGE0_API_KEY=your-judge0-key
JUDGE0_HOST=your-judge0-host
```

## 📱 Screenshots

<div align="center">
<table>
  <tr>
    <td align="center">🏠 Home Screen</td>
    <td align="center">🔐 Authentication</td>
    <td align="center">👤 User Profile</td>
  </tr>
  <tr>
    <td align="center">💻 Main Interface</td>
    <td align="center">⚙️ Settings</td>
    <td align="center">📱 Responsive Design</td>
  </tr>
</table>
</div>

*Screenshots will be added as development progresses*

## 🚀 Getting Started

1. **📥 Clone Repository** - Download the source code
2. **⚙️ Install Dependencies** - Run `flutter pub get`
3. **🔥 Setup Firebase** - Configure authentication
4. **▶️ Launch App** - Run `flutter run`
5. **🎯 Explore** - Navigate through the interface

## 🏗️ Architecture

CodeSync Arena follows **Clean Architecture** principles:

### Layers
- **🎨 Presentation Layer** - UI components and state management
- **🏗️ Domain Layer** - Business logic and entities
- **📊 Data Layer** - Data sources and repositories

### Design Patterns
- **Repository Pattern** - Data abstraction
- **Provider Pattern** - State management
- **Dependency Injection** - Loose coupling
- **Observer Pattern** - Reactive programming
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
   ```bash
   flutterfire configure
   ```

3. **Run the app**
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

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

### Getting Started
1. 🍴 Fork the repository
2. 🌟 Create a feature branch (`git checkout -b feature/amazing-feature`)
3. 💻 Make your changes
4. ✅ Add tests for new functionality
5. 📝 Commit your changes (`git commit -m 'Add amazing feature'`)
6. 🚀 Push to the branch (`git push origin feature/amazing-feature`)
7. 📋 Open a Pull Request

### Development Guidelines
- Follow [Flutter style guide](https://flutter.dev/docs/development/tools/formatting)
- Write meaningful commit messages
- Add documentation for new features
- Ensure all tests pass
- Keep PRs focused and small

### Code of Conduct
Please read our [Code of Conduct](CODE_OF_CONDUCT.md) before contributing.

## 🚀 Build & Deployment

### Development
```bash
# Run in development mode
flutter run

# Run with hot reload
flutter run --hot
```

### Production Builds
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS  
flutter build ios --release

# Web
flutter build web --release

# Desktop
flutter build windows --release
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

## 📈 Performance

- **Fast startup** - Optimized initialization
- **Smooth animations** - 60fps UI performance  
- **Efficient networking** - Smart caching strategies
- **Memory management** - Proper disposal of resources
- **Bundle optimization** - Tree-shaking and code splitting

## 🔒 Security

- **Firebase Security Rules** - Server-side validation
- **Input sanitization** - XSS protection
- **Secure authentication** - JWT tokens and refresh logic
- **HTTPS only** - All network communication encrypted
- **Data validation** - Client and server-side validation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing cross-platform framework
- **Firebase** - For backend services
- **Material Design** - For beautiful UI components
- **Open Source Community** - For inspiration and contributions

## 📞 Support

Having issues? Feel free to:

- 🐛 **Report Bugs**: [GitHub Issues](https://github.com/Keerthanreddy01/Codesync/issues)
- 💬 **Ask Questions**: [GitHub Discussions](https://github.com/Keerthanreddy01/Codesync/discussions)

## 🗺️ Development Roadmap

### 🚀 Planned Features
- [ ] **Team Management** - Create and join coding teams
- [ ] **Real-time Collaboration** - Live code editing
- [ ] **Battle System** - Competitive coding challenges
- [ ] **Progress Tracking** - User statistics and achievements
- [ ] **Enhanced UI** - Improved user experience
- [ ] **Performance Optimization** - Better app performance

---

<div align="center">

**Made with ❤️ by the CodeSync Team**

[⭐ Star us on GitHub](https://github.com/Keerthanreddy01/Codesync)

</div>
