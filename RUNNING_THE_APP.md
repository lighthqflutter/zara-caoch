# How to Run the Zara Coach App

## Quick Start (Recommended)

The simplest way to run the app without errors:

```bash
cd /Users/lighthqmini/StudioProjects/zara_coach
flutter run
```

Flutter will automatically detect available devices and let you choose one.

## Running on Specific Devices

### On iPad (Wireless)
```bash
flutter run -d 00008030-0006052036C0C02E
```

### On iPhone Simulator
```bash
flutter run -d 0501A8BB-0AB3-4CA8-90EA-46735768C93E
```

### List All Available Devices
```bash
flutter devices
```

## Common Issues & Solutions

### Issue 1: Build Errors After Updating Dependencies

**Solution**: Clean and rebuild
```bash
flutter clean
flutter pub get
flutter run
```

### Issue 2: iOS Build Fails

**Solution**: Reset CocoaPods
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter run
```

### Issue 3: Xcode Derived Data Issues

**Solution**: Clear Xcode cache
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData
flutter run
```

### Issue 4: "Framework 'Pods_Runner' not found"

**Solution**: Complete reset
```bash
# Clear Xcode Derived Data
rm -rf ~/Library/Developer/Xcode/DerivedData

# Deintegrate and reinstall CocoaPods
cd ios
pod deintegrate
pod install
cd ..

# Run the app
flutter run
```

### Issue 5: Wireless Debug Connection Timeout

This is normal for wireless connections. The app IS installed even if the debug connection times out. Just open the app on your device.

**Better solution**: Use a USB cable for faster, more reliable connections.

## Firebase Setup

### First Time Setup

1. **Create Firestore Database**
   - Visit: https://console.firebase.google.com/project/zara-coach
   - Go to Firestore Database
   - Click "Create Database"
   - Start in "Test Mode"
   - Choose location: `us-central`

2. **Deploy Security Rules**
   - Copy contents from `firestore.rules`
   - Paste into Firebase Console → Firestore → Rules
   - Click "Publish"

3. **Deploy Storage Rules**
   - Copy contents from `storage.rules`
   - Paste into Firebase Console → Storage → Rules
   - Click "Publish"

## Hot Reload & Hot Restart

While the app is running:
- **Hot Reload** (faster): Press `r` in the terminal
- **Hot Restart** (clears state): Press `R` in the terminal
- **Quit**: Press `q` in the terminal

## Building for Release

### iOS
```bash
flutter build ios --release
```

### Android
```bash
flutter build apk --release
```

## Troubleshooting

### Cannot Build in Xcode Directly

Flutter projects cannot be built directly in Xcode. Always use `flutter build` or `flutter run`.

### Permission Denied Errors from Firestore

Make sure you've:
1. Created the Firestore database
2. Deployed the security rules from `firestore.rules`
3. Restarted the app after deploying rules

### App Doesn't Connect to Debugger

The app may still be installed and running on your device. Check your home screen for "Zara Coach" app icon.

## Development Workflow

Recommended workflow for development:

1. **Start development**:
   ```bash
   flutter run
   ```

2. **Make code changes** in your editor

3. **See changes immediately**: Press `r` for hot reload

4. **If hot reload doesn't work**: Press `R` for hot restart

5. **If something breaks**: Press `q` to quit, then restart with `flutter run`

## Getting Help

If you encounter errors:
1. Copy the error message
2. Try the relevant solution from "Common Issues" above
3. If still stuck, run `flutter doctor` to check your setup

## Notes

- **Build time**: First build takes 1-2 minutes, subsequent builds are faster (~30-60s)
- **Wireless debugging**: Slower than USB, may timeout but app still installs
- **USB debugging**: Faster and more reliable
- **Hot reload**: Works great for UI changes, may need restart for logic changes
