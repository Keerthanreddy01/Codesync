# 📖 CodeSync Arena Documentation

## 🚀 Quick Start

### Prerequisites
- Flutter 3.0+ and Dart 3.0+
- Firebase project setup
- Git for version control

### Installation
```bash
# Clone and setup
git clone https://github.com/Keerthanreddy01/Codesync.git
cd Codesync
flutter pub get

# Configure Firebase
flutterfire configure

# Run the app
flutter run
```

## 🏗️ Architecture

### Clean Architecture Layers
- **🎨 Presentation** - UI components, screens, and state management
- **🏗️ Domain** - Business logic, entities, and use cases  
- **📊 Data** - Repositories, data sources, and models

### Key Technologies
- **Flutter/Dart** - Cross-platform framework
- **Firebase** - Backend-as-a-Service
- **Riverpod** - State management
- **GoRouter** - Navigation

## 🔥 Firebase Setup

### 1. Create Firebase Project
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Create new project
firebase projects:create codesync-arena
```

### 2. Configure Services
Enable the following Firebase services:
- **Authentication** (Email/Password, Google)
- **Firestore Database** (Real-time data)
- **Storage** (File uploads)
- **Analytics** (User tracking)

### 3. Security Rules
```javascript
// Firestore Security Rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Public read access for rooms
    match /rooms/{roomId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        resource.data.createdBy == request.auth.uid;
    }
  }
}
```

## 🌿 Branch System

### Git-Style Collaboration
CodeSync Arena implements a Git-like branching system for collaborative coding:

#### Core Concepts
- **Main Branch** - The primary codebase
- **Feature Branches** - Individual developer work
- **Merge Requests** - Code review process
- **Conflict Resolution** - Automated and manual merge handling

#### Implementation
```dart
class BranchService {
  Future<Branch> createBranch(String name, String parentId) async {
    return Branch(
      id: generateId(),
      name: name,
      parentId: parentId,
      createdAt: DateTime.now(),
      commits: [],
    );
  }
  
  Future<MergeResult> mergeBranch(String sourceId, String targetId) async {
    // Implement merge logic with conflict detection
  }
}
```

## 🎯 Features

### 🏆 Battle System
- **Real-time Coding** - Synchronized code editing
- **Problem Sets** - Curated coding challenges
- **Judging System** - Automated code evaluation
- **Rankings** - Performance-based scoring

### 👥 Team Features
- **Team Creation** - Form coding teams
- **Role Management** - Team leader and member roles
- **Communication** - In-app chat and voice
- **Progress Tracking** - Team performance analytics

### 🎖️ Achievements
- **Skill Badges** - Language and concept mastery
- **Streaks** - Daily coding challenges
- **Tournaments** - Competitive events
- **Leaderboards** - Global and local rankings

## 🧪 Testing

### Test Structure
```
test/
├── unit/           # Unit tests for business logic
├── widget/         # Widget and UI tests
├── integration/    # End-to-end tests
└── mocks/         # Mock data and services
```

### Running Tests
```bash
# All tests
flutter test

# Specific test suite
flutter test test/unit/
flutter test test/widget/

# With coverage
flutter test --coverage
```

## 🚀 Deployment

### Development
```bash
# Debug mode with hot reload
flutter run --debug

# Profile mode for performance testing
flutter run --profile
```

### Production
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

### CI/CD Pipeline
```yaml
# GitHub Actions example
name: CI/CD
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter test
  
  build:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build web --release
```

## 🔧 Configuration

### Environment Variables
```env
# Firebase Configuration
FIREBASE_PROJECT_ID=codesync-arena
FIREBASE_API_KEY=your-api-key
FIREBASE_APP_ID=your-app-id

# External APIs
JUDGE0_API_KEY=your-judge0-key
AGORA_APP_ID=your-agora-id
```

### App Configuration
```dart
class AppConfig {
  static const String appName = 'CodeSync Arena';
  static const String version = '1.0.0';
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  
  // API Endpoints
  static const String judge0BaseUrl = 'https://judge0-ce.p.rapidapi.com';
  static const String agoraBaseUrl = 'https://api.agora.io';
}
```

## 🐛 Troubleshooting

### Common Issues

#### Firebase Not Initializing
- Verify `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are correctly placed
- Check Firebase project configuration matches app bundle ID

#### Build Failures
```bash
# Clean build files
flutter clean
flutter pub get

# Reset Flutter
flutter doctor --android-licenses
flutter doctor
```

#### Performance Issues
- Enable debug mode: `flutter run --debug`
- Use Flutter Inspector for widget tree analysis
- Monitor memory usage with DevTools

### Debug Tools
```bash
# Flutter Inspector
flutter inspector

# Performance monitoring
flutter run --profile

# Memory analysis
flutter run --track-widget-creation
```

## 🤝 Contributing

### Development Workflow
1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Make changes following code style guidelines
4. Add tests for new functionality
5. Run test suite (`flutter test`)
6. Commit changes (`git commit -m 'Add amazing feature'`)
7. Push to branch (`git push origin feature/amazing-feature`)
8. Create Pull Request

### Code Standards
- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add documentation comments for public APIs
- Maintain test coverage above 80%

### Commit Message Format
```
type(scope): description

feat(auth): add Google Sign-In
fix(battle): resolve real-time sync issue
docs(readme): update installation guide
test(widget): add login screen tests
```

## 📞 Support

- 📧 **Email**: support@codesync-arena.com
- 🐛 **Issues**: [GitHub Issues](https://github.com/Keerthanreddy01/Codesync/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/Keerthanreddy01/Codesync/discussions)

---

**Last updated**: January 2026 | **Version**: 1.0.0
