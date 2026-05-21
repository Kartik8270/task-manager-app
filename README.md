# TaskFlow – Flutter Task Manager App

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-blue?logo=dart" />
  <img src="https://img.shields.io/badge/Firebase-Auth_%26_Firestore-orange?logo=firebase" />
  <img src="https://img.shields.io/badge/Platform-Android-green?logo=android" />
  <img src="https://img.shields.io/badge/Status-Complete-brightgreen" />
</p>

> A clean, fully-featured **Task Manager** mobile app built with Flutter, Firebase Authentication, Cloud Firestore, and REST API integration. Submitted as part of the **Sankar Group Flutter Development Internship Assignment**.
a
--
> 
## ✨ Features

### 🔐 User Authentication (Firebase Auth)
- Email & Password Sign Up with validation
- Secure Login with persistent session (auto-login on relaunch)
- Logout with confirmation dialog

### 📋 Task Management (Cloud Firestore)
- **Add** tasks with title, description, due date & status
- **Edit** any task with a pre-filled form
- **Delete** tasks with confirmation dialog
- **Toggle Complete / Pending** with one tap
- Real-time sync via Firestore streams
- Filter tasks: **All / Pending / Completed**
- Progress tracker showing tasks done vs total

### 💬 REST API Integration
- Fetches a random motivational quote from `zenquotes.io`
- Displays quote content and author name
- Tap refresh to load a new quote
- Graceful error handling with retry option

### 🎨 UI/UX Highlights
- Animated splash screen
- Clean modern purple-themed design
- Smooth transitions using `flutter_animate`
- Loading indicators on all async actions
- Descriptive error snackbars
- Empty state screen when no tasks exist

---

## 📁 Folder Structure

```
lib/
├── main.dart                     # App entry point & Firebase init
├── firebase_options.dart         # Firebase config (fill with your values)
├── models/
│   ├── task_model.dart           # Task data model with Firestore mapping
│   └── quote_model.dart          # Quote data model
├── services/
│   ├── auth_service.dart         # Firebase Auth — signup, login, logout
│   ├── task_service.dart         # Firestore CRUD operations
│   └── quote_service.dart        # REST API call to zenquotes.io
├── screens/
│   ├── splash_screen.dart        # Animated splash + auth state check
│   ├── login_screen.dart         # Login with form validation
│   ├── signup_screen.dart        # Registration screen
│   ├── home_screen.dart          # Task list, quote card, filters
│   └── add_edit_task_screen.dart # Add & edit task form
├── widgets/
│   ├── custom_widgets.dart       # CustomTextField, PrimaryButton, etc.
│   ├── task_card.dart            # Task card with options menu
│   └── quote_card.dart           # Motivational quote card
└── utils/
    └── app_theme.dart            # Theme, colors, typography
```

---

## 🚀 Setup & Installation

### Prerequisites
- Flutter SDK `>=3.0.0` → [Install Flutter](https://flutter.dev/docs/get-started/install)
- A Firebase account → [console.firebase.google.com](https://console.firebase.google.com)
- Android Studio or VS Code with Flutter & Dart extensions
- Android Emulator or physical Android device

---

### Step 1 — Clone the Repository

```bash
git clone https://github.com/Kartik8270/task-manager-app.git
cd task-manager-app
flutter pub get
```

---

### Step 2 — Firebase Setup

#### 2a. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com) → **Add project**
2. Name it (e.g. `taskflow-app`) → Create

#### 2b. Enable Authentication
1. **Build → Authentication → Get Started**
2. Enable **Email/Password** → Save

#### 2c. Enable Firestore
1. **Build → Firestore Database → Create database**
2. Choose **Start in test mode** → Enable

#### 2d. Add Android App
1. Project Settings → **Add App → Android**
2. Package name: `com.example.task_manager_app`
3. Download `google-services.json`
4. Place it in `android/app/google-services.json`

#### 2e. Update `lib/firebase_options.dart`
Replace the placeholder values with your actual Firebase config:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  appId: 'YOUR_APP_ID',
  messagingSenderId: 'YOUR_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  storageBucket: 'YOUR_PROJECT_ID.firebasestorage.app',
);
```

---

### Step 3 — Firestore Security Rules

In Firebase Console → **Firestore → Rules**, paste:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /tasks/{taskId} {
      allow read, write: if request.auth != null
        && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null
        && request.auth.uid == request.resource.data.userId;
    }
  }
}
```

### Step 4 — Firestore Composite Index

In Firebase Console → **Firestore → Indexes → Add Index**:

| Collection | Field 1 | Field 2 | Scope |
|---|---|---|---|
| tasks | userId (Asc) | createdAt (Desc) | Collection |

---

### Step 5 — Run the App

```bash
# Debug mode
flutter run

# Build release APK
flutter build apk --release
# APK → build/app/outputs/flutter-apk/app-release.apk
```

---

## 🛠 Tech Stack

| Technology | Purpose |
|---|---|
| Flutter 3.x | Cross-platform UI framework |
| Dart | Programming language |
| Firebase Auth | User authentication |
| Cloud Firestore | Real-time NoSQL database |
| http | REST API integration |
| flutter_animate | UI animations |
| intl | Date formatting |
| uuid | Unique task IDs |


## 👤 Author

**Kartik Jain**
B.Tech, IIT Jodhpur
📧 kartikjain827@gmail.com
🔗 [GitHub](https://github.com/Kartik8270)
