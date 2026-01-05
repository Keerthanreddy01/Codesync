# Firebase Setup Guide for CodeSync Arena

This guide walks you through setting up Firebase for the CodeSync Arena application.

## Prerequisites

- Google Account
- Firebase CLI installed (`npm install -g firebase-tools`)
- Flutter & Dart installed

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create Project"
3. Enter project name: `codesync-arena`
4. Uncheck "Enable Google Analytics" (optional)
5. Click "Create Project"

## Step 2: Enable Authentication Methods

### Email/Password
1. Go to Authentication → Sign-in method
2. Click "Email/Password"
3. Enable "Email/Password" option
4. Enable "Email link (passwordless sign-in)" (optional)
5. Click "Save"

### Google Sign-In
1. Click "Google" in Sign-in methods
2. Enable Google
3. Add your project support email
4. Click "Save"

## Step 3: Create Firestore Database

1. Go to Firestore Database
2. Click "Create Database"
3. Start in **Production mode**
4. Select region closest to you (e.g., `us-central1`)
5. Click "Create"

### Set up Security Rules

1. Go to Firestore → Rules
2. Replace default rules with:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth.uid == userId || request.auth != null;
      allow create: if request.auth.uid == userId && 
                       request.resource.data.id == userId;
      allow update: if request.auth.uid == userId;
      allow delete: if request.auth.uid == userId;
    }

    // Battles collection (public read)
    match /battles/{battleId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth.uid == resource.data.hostId;
      allow delete: if request.auth.uid == resource.data.hostId;
      
      // Battle participants subcollection
      match /participants/{participantId} {
        allow read, write: if request.auth != null;
      }
    }

    // Problems collection (public read)
    match /problems/{problemId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admin can write
    }

    // Default deny all other access
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

3. Click "Publish"

## Step 4: Enable Realtime Database

1. Go to Realtime Database
2. Click "Create Database"
3. Start in **Locked mode**
4. Select region (same as Firestore)
5. Click "Enable"

### Set up Security Rules

1. Go to Realtime Database → Rules
2. Replace default rules with:

```json
{
  "rules": {
    "battles": {
      "$battleId": {
        ".read": "auth != null",
        ".write": "root.child('battles').child($battleId).child('hostId').val() === auth.uid"
      }
    },
    "chat": {
      "$battleId": {
        ".read": "auth != null",
        ".write": "auth != null"
      }
    },
    "presence": {
      "$userId": {
        ".read": true,
        ".write": "$userId === auth.uid"
      }
    }
  }
}
```

3. Click "Publish"

## Step 5: Set up Cloud Storage

1. Go to Cloud Storage
2. Click "Create Bucket"
3. Bucket name: `codesync-arena.appspot.com`
4. Choose location (same region as Firestore)
5. Choose storage class: "Standard"
6. Click "Create"

### Set up Security Rules

1. Go to Cloud Storage → Rules
2. Replace default rules with:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // User avatars
    match /avatars/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId && 
                      request.resource.size < 5 * 1024 * 1024; // 5MB limit
    }

    // Battle submissions
    match /submissions/{battleId}/{teamId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }

    // Deny all other access
    match /{allPaths=**} {
      allow read, write: if false;
    }
  }
}
```

3. Click "Publish"

## Step 6: Get Firebase Credentials

### Android Configuration

1. Go to Project Settings → Your Apps
2. Click "Add app" → Select "Android"
3. Enter Android package name: `com.example.codesync_arena`
4. Get SHA-1 fingerprint:
   ```bash
   cd android
   ./gradlew signingReport
   ```
5. Copy SHA-1 fingerprint from output
6. Paste into Firebase console
7. Download `google-services.json`
8. Place in `android/app/`

### iOS Configuration

1. Go to Project Settings → Your Apps
2. Click "Add app" → Select "iOS"
3. Enter iOS Bundle ID: `com.example.codesync-arena`
4. Download `GoogleService-Info.plist`
5. Place in `ios/Runner/`

### Web Configuration

1. Go to Project Settings → Your Apps
2. Click "Add app" → Select "Web"
3. Get the config object
4. Copy credentials to `lib/firebase_options.dart`

## Step 7: Update firebase_options.dart

1. Open `lib/firebase_options.dart`
2. Replace placeholders with your Firebase credentials:
   - `apiKey`
   - `appId`
   - `messagingSenderId`
   - `projectId`
   - `storageBucket`

Example from Firebase console:
```dart
const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyDnRl...', // From google-services.json
  appId: '1:123456789:android:abc123...', // From google-services.json
  messagingSenderId: '123456789',
  projectId: 'codesync-arena',
  storageBucket: 'codesync-arena.appspot.com',
);
```

## Step 8: Configure Google Sign-In

### Get Google Client ID

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Select your project
3. Go to APIs & Services → Credentials
4. Click "Create Credentials" → "OAuth 2.0 Client ID"
5. Select "Android" / "iOS" / "Web" as appropriate
6. Follow setup wizard
7. Copy Client ID

### Update Configuration

1. Update `lib/core/constants/app_constants.dart`:
   ```dart
   static const String googleClientId = 'YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com';
   ```

## Step 9: Test Firebase Connection

1. Update `lib/firebase_options.dart` with your actual credentials
2. Run the app:
   ```bash
   flutter run
   ```
3. Test authentication flow:
   - Try signing up with email/password
   - Test Google Sign-In
   - Check Firestore console to see user document created

## Step 10: Enable Additional Services (Optional)

### Cloud Functions

1. Go to Cloud Functions
2. Click "Create Function"
3. Set up function for additional operations (email verification, etc.)

### Cloud Messaging

1. Go to Cloud Messaging
2. Upload your FCM credentials
3. Configure push notifications

### Analytics

1. Go to Analytics
2. Enable analytics
3. Update app to track events

## Firestore Collections Structure

Create these collections manually or let the app create them:

### users
```
Document ID: {userId}
Fields:
- id: string
- email: string
- displayName: string
- photoUrl: string
- username: string
- bio: string
- xp: number
- level: number
- createdAt: timestamp
- lastSignedIn: timestamp
- emailVerified: boolean
- hasCompletedOnboarding: boolean
```

### battles
```
Document ID: {battleId}
Fields:
- id: string
- hostId: string (user who created battle)
- problemId: string
- status: string (waiting, in_progress, finished)
- mode: string (classic, battle_royale, practice, tournament)
- timeLimit: number (in seconds)
- maxParticipants: number
- createdAt: timestamp
- startedAt: timestamp
- endedAt: timestamp
- isPublic: boolean

Subcollections:
- participants
- submissions
```

### problems
```
Document ID: {problemId}
Fields:
- id: string
- title: string
- description: string
- difficulty: string (easy, medium, hard, expert)
- categories: array
- tags: array
- starterCode: string
- testCases: array
- constraints: array
- createdAt: timestamp
- updatedAt: timestamp
```

## Troubleshooting

### Firebase App Not Initialized
- Make sure all credentials are correct in `firebase_options.dart`
- Verify Firebase project exists and is active

### Authentication Not Working
- Check that Email/Password and Google Sign-In are enabled
- Verify security rules allow user creation

### Firestore Not Accessible
- Check security rules allow your app to read/write
- Verify Firestore database is created

### Google Sign-In Fails on Android
- Check that SHA-1 fingerprint is registered in Firebase
- Verify `google-services.json` is in `android/app/`

## Next Steps

1. Test all authentication flows
2. Set up cloud functions for additional features
3. Configure analytics
4. Set up error logging (Crashlytics)
5. Implement team management features

## Security Checklist

- ✅ Firestore security rules restrict access
- ✅ Realtime Database rules restrict access
- ✅ Cloud Storage rules restrict access
- ✅ Firebase Auth enabled for all sign-in methods
- ✅ Email verification required (future)
- ✅ Rate limiting enabled (future)
- ✅ HTTPS/TLS required for all connections

## References

- [Firebase Console](https://console.firebase.google.com)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Google Cloud Console](https://console.cloud.google.com)
- [Flutter Firebase Plugin](https://firebase.flutter.dev/)

---

**Last Updated**: January 2025
