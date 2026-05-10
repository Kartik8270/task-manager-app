# TaskFlow – Flutter Task Manager App

A clean, fully-featured **Task Manager** mobile app built with Flutter, Firebase, and REST API integration. Submitted as part of the Sankar Group Flutter Development Internship Assignment.

---

## 📱 Features

### ✅ User Authentication (Firebase Auth)
- User Sign Up with email & password
- User Login with validation
- Secure Logout with confirmation dialog
- Persistent session (auto-login on relaunch)

### 📋 Task Management (Cloud Firestore)
- **Add** tasks with title, description, date, and status
- **Edit** any task with pre-filled form
- **Delete** tasks with confirmation
- **Mark as Complete / Pending** with one tap
- Real-time sync via Firestore streams
- Filter tasks: All / Pending / Completed

### 💬 REST API Integration
- Fetches a random motivational quote from `https://api.quotable.io/random`
- Displays quote content and author
- Refresh quote with a tap
- Graceful error handling if API is unavailable

### 🎨 UI/UX
- Splash screen with animation
- Clean and modern purple-themed design
- Animated transitions using `flutter_animate`
- Google Fonts (Poppins)
- Filter chips for task filtering
- Progress tracker ("done/total")
- Loading indicators throughout
- Error snackbars with descriptive messages
- Empty state illustrations

---

## 📁 Folder Structure

```
lib/
├── main.dart                    # App entry point, Firebase init
├── firebase_options.dart        # Firebase config (replace with yours)
├── models/
│   ├── task_model.dart          # Task data model
│   └── quote_model.dart         # Quote data model
├── services/
│   ├── auth_service.dart        # Firebase Auth (signup, login, logout)
│   ├── task_service.dart        # Firestore CRUD for tasks
│   └── quote_service.dart       # HTTP call to quotable.io
├── screens/
│   ├── splash_screen.dart       # Animated splash + auth check
│   ├── login_screen.dart        # Login screen with form validation
│   ├── signup_screen.dart       # Sign up screen
│   ├── home_screen.dart         # Task list + quote card + filters
│   └── add_edit_task_screen.dart# Add & edit task form
├── widgets/
│   ├── custom_widgets.dart      # CustomTextField, PrimaryButton, etc.
│   ├── task_card.dart           # Task list card with options menu
│   └── quote_card.dart          # Motivational quote card
└── utils/
    └── app_theme.dart           # Theme, colors, typography
```

---

## 🚀 Setup & Installation

### Prerequisites
- Flutter SDK `>=3.0.0` — [Install Flutter](https://flutter.dev/docs/get-started/install)
- A Firebase account — [console.firebase.google.com](https://console.firebase.google.com)
- Android Studio or VS Code with Flutter extension

---

### Step 1 — Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/task_manager_app.git
cd task_manager_app
```

---

### Step 2 — Set Up Firebase

1. Go to [Firebase Console](https://console.firebase.google.com) and create a new project (e.g., `taskflow-app`)

2. **Enable Authentication:**
   - Go to **Build → Authentication → Get Started**
   - Enable **Email/Password** sign-in method

3. **Enable Firestore:**
   - Go to **Build → Firestore Database → Create database**
   - Start in **test mode** (or apply the rules in `firestore.rules`)

4. **Add Android App:**
   - Go to Project Settings → Add App → Android
   - Package name: `com.example.task_manager_app`
   - Download `google-services.json`
   - Place it in `android/app/`

5. **Get Firebase config values:**
   - Go to **Project Settings → General → Your Apps → SDK Setup and Configuration**
   - Copy the config values

6. **Update `lib/firebase_options.dart`:**
   Replace all `YOUR_*` placeholders with your actual Firebase project values.

   ```dart
   static const FirebaseOptions android = FirebaseOptions(
     apiKey: 'AIza...your-actual-key',
     appId: '1:123456:android:abcdef',
     messagingSenderId: '123456789',
     projectId: 'taskflow-app',
     storageBucket: 'taskflow-app.appspot.com',
   );
   ```

> **Tip:** You can also run `flutterfire configure` (after installing FlutterFire CLI) to auto-generate this file.

---

### Step 3 — Apply Firestore Security Rules

In Firebase Console → Firestore → Rules, paste:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /tasks/{taskId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && request.auth.uid == request.resource.data.userId;
    }
  }
}
```

---

### Step 4 — Install Dependencies

```bash
flutter pub get
```

---

### Step 5 — Run the App

```bash
# On Android device/emulator
flutter run

# Build APK
flutter build apk --release
```

The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🛠 Tech Stack

| Technology         | Purpose                        |
|--------------------|--------------------------------|
| Flutter 3.x        | Cross-platform UI framework    |
| Dart               | Programming language           |
| Firebase Auth      | User authentication            |
| Cloud Firestore    | Real-time NoSQL database       |
| http package       | REST API calls                 |
| provider           | State management               |
| google_fonts       | Poppins typography             |
| flutter_animate    | UI animations                  |
| intl               | Date formatting                |
| uuid               | Unique task IDs                |

## 👤 Author

**Kartik**  
IIT Jodhpur  
