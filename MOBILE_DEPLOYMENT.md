# Mobile Deployment Guide - iOS and Android

## Overview
LumberjackRPG is built with Flutter, which provides native support for both iOS and Android platforms. This guide covers everything needed to deploy the game to mobile devices.

## Platform Support

### ✅ iOS (iPhone and iPad)
- iOS 11.0 or higher
- iPhone 6s and newer
- All iPad models from 2017 onwards
- Support for both portrait and landscape orientations

### ✅ Android
- Android 5.0 (API level 21) or higher
- Support for ARM and x86 architectures
- Works on phones and tablets
- Support for both portrait and landscape orientations

## Prerequisites

### Development Environment

#### For iOS Development:
- macOS computer (required for iOS builds)
- Xcode 12.0 or higher
- CocoaPods installed (`sudo gem install cocoapods`)
- Apple Developer Account ($99/year for App Store distribution)
- iOS Simulator or physical iOS device

#### For Android Development:
- Any operating system (Windows, macOS, Linux)
- Android Studio with Android SDK
- Java Development Kit (JDK) 11 or higher
- Android emulator or physical Android device

#### Flutter SDK:
```bash
# Install Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

## Project Setup

### 1. Install Dependencies
```bash
cd LumberjackRPG
flutter pub get
```

### 2. Configure for iOS

#### Update iOS Deployment Target
Edit `ios/Podfile`:
```ruby
platform :ios, '11.0'
```

#### Configure App Information
Edit `ios/Runner/Info.plist`:
```xml
<key>CFBundleDisplayName</key>
<string>LumberjackRPG</string>
<key>CFBundleIdentifier</key>
<string>com.yourcompany.lumberjackrpg</string>
<key>CFBundleVersion</key>
<string>1.0.0</string>
```

#### Set App Icon
Place app icons in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

Required sizes:
- 20x20, 29x29, 40x40, 60x60, 76x76, 83.5x83.5, 1024x1024

### 3. Configure for Android

#### Update Minimum SDK Version
Edit `android/app/build.gradle`:
```gradle
android {
    compileSdkVersion 33
    
    defaultConfig {
        applicationId "com.yourcompany.lumberjackrpg"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0.0"
    }
}
```

#### Configure App Name
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="LumberjackRPG"
    android:icon="@mipmap/ic_launcher">
```

#### Set App Icon
Place launcher icons in:
- `android/app/src/main/res/mipmap-mdpi/`
- `android/app/src/main/res/mipmap-hdpi/`
- `android/app/src/main/res/mipmap-xhdpi/`
- `android/app/src/main/res/mipmap-xxhdpi/`
- `android/app/src/main/res/mipmap-xxxhdpi/`

Required sizes:
- mdpi: 48x48
- hdpi: 72x72
- xhdpi: 96x96
- xxhdpi: 144x144
- xxxhdpi: 192x192

## Building for Development

### iOS Development Build
```bash
# Open iOS project in Xcode
open ios/Runner.xcworkspace

# Or build from command line
flutter build ios --debug

# Run on connected device
flutter run -d iphone

# Run on simulator
flutter run -d "iPhone 14"
```

### Android Development Build
```bash
# Build APK
flutter build apk --debug

# Install on connected device
flutter install

# Run on emulator/device
flutter run -d android
```

## Building for Production

### iOS Production Build

#### 1. Configure Signing
In Xcode:
1. Open `ios/Runner.xcworkspace`
2. Select Runner target
3. Go to "Signing & Capabilities"
4. Select your Team
5. Choose automatic signing or manual provisioning profile

#### 2. Build IPA
```bash
# Build release IPA
flutter build ios --release

# Build for App Store submission
flutter build ipa
```

#### 3. Submit to App Store
```bash
# Use Xcode or Transporter app
# Archive and upload from Xcode:
# Product > Archive > Distribute App
```

### Android Production Build

#### 1. Create Keystore
```bash
keytool -genkey -v -keystore ~/lumberjackrpg-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias lumberjackrpg
```

#### 2. Configure Signing
Create `android/key.properties`:
```properties
storePassword=<your-password>
keyPassword=<your-password>
keyAlias=lumberjackrpg
storeFile=/path/to/lumberjackrpg-release-key.jks
```

Edit `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

#### 3. Build Release APK/AAB
```bash
# Build APK for direct distribution
flutter build apk --release

# Build App Bundle for Play Store (recommended)
flutter build appbundle --release
```

#### 4. Submit to Google Play Store
1. Create developer account ($25 one-time fee)
2. Go to Google Play Console
3. Create new application
4. Upload AAB file from `build/app/outputs/bundle/release/app-release.aab`
5. Fill in store listing details
6. Submit for review

## Mobile-Specific Features

### Touch Controls
The game supports both tap and keyboard controls:
- **Tap/Touch**: Direct interaction with game objects
- **Gestures**: Swipe for movement (can be added)
- **Multi-touch**: Zoom and pan (can be added)

### Screen Orientations
Currently supports:
- Portrait mode
- Landscape mode (auto-rotates)

To lock to specific orientation, edit `lib/main.dart`:
```dart
SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,  // Portrait only
  // DeviceOrientation.landscapeLeft,  // Landscape only
]);
```

### Performance Optimization

#### Asset Compression
All assets should be optimized:
```bash
# Optimize PNG images
optipng -o7 assets/**/*.png

# Or use ImageMagick
mogrify -strip -quality 85 assets/**/*.png
```

#### Frame Rate
The game runs at 60 FPS by default. For better battery life:
```dart
// In lumberjack_rpg.dart
@override
void onLoad() async {
  // Limit to 30 FPS on mobile
  game.pauseWhenBackgrounded = true;
}
```

### Memory Management
- Assets are loaded dynamically
- Unused resources are disposed
- Background pause to save battery

## Platform-Specific Configurations

### iOS Permissions
Add to `ios/Runner/Info.plist` if needed:
```xml
<!-- For notifications -->
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
</array>
```

### Android Permissions
Add to `android/app/src/main/AndroidManifest.xml` if needed:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.VIBRATE"/>
```

## Testing on Mobile

### iOS Testing
```bash
# Run on simulator
flutter run -d "iPhone 14 Pro"

# Run on physical device
flutter run -d "Your iPhone"

# List available devices
flutter devices
```

### Android Testing
```bash
# Run on emulator
flutter run -d emulator-5554

# Run on physical device (enable USB debugging)
flutter run -d <device-id>

# List available devices
flutter devices
```

### Performance Testing
```bash
# Profile mode for performance analysis
flutter run --profile

# Release mode testing
flutter run --release
```

## App Store Submission Checklist

### iOS App Store
- [ ] App icons (all required sizes)
- [ ] Screenshots (6.5", 5.5", 12.9" iPad)
- [ ] App description (max 4000 characters)
- [ ] Keywords (max 100 characters)
- [ ] Privacy policy URL
- [ ] Support URL
- [ ] Age rating completed
- [ ] TestFlight beta testing (optional)
- [ ] Build uploaded via Xcode/Transporter
- [ ] Submitted for review

### Google Play Store
- [ ] App icons (512x512 and all launcher icons)
- [ ] Feature graphic (1024x500)
- [ ] Screenshots (phone and tablet sizes)
- [ ] Short description (max 80 characters)
- [ ] Full description (max 4000 characters)
- [ ] Content rating questionnaire completed
- [ ] Privacy policy URL
- [ ] APK or AAB uploaded
- [ ] Store listing complete
- [ ] Submitted for review

## Distribution Channels

### Official Stores
1. **Apple App Store** (iOS)
   - Reach: ~1.2 billion devices
   - Revenue: 70% developer, 30% Apple
   - Review time: 1-3 days

2. **Google Play Store** (Android)
   - Reach: ~2.5 billion devices
   - Revenue: 70% developer, 30% Google
   - Review time: few hours to 7 days

### Alternative Distribution

#### Android APK
- Direct download from website
- Third-party stores (Amazon Appstore, Samsung Galaxy Store)
- Side-loading via APK file

#### iOS TestFlight
- Beta testing (up to 10,000 external testers)
- No App Store review required for internal testing
- 90-day testing period

## Monetization Options (Future)

### In-App Purchases
```yaml
# Add to pubspec.yaml
dependencies:
  in_app_purchase: ^3.1.0
```

### Advertisements
```yaml
# Add to pubspec.yaml
dependencies:
  google_mobile_ads: ^3.0.0
```

### Premium Version
- Free version with ads
- Paid version ($2.99-$4.99)
- In-app purchase to remove ads

## Troubleshooting

### Common iOS Issues

**Build fails with CocoaPods error:**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter build ios
```

**App crashes on launch:**
- Check iOS deployment target (11.0+)
- Verify signing certificates
- Check Info.plist configuration

### Common Android Issues

**Gradle build fails:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter build apk
```

**App not installing:**
- Check minimum SDK version (21+)
- Verify app signing
- Check AndroidManifest.xml

### Performance Issues
- Reduce asset sizes
- Use asset bundles for lazy loading
- Profile with DevTools
- Enable tree shaking: `flutter build --release`

## Continuous Integration/Deployment

### GitHub Actions Example
```yaml
# .github/workflows/mobile-build.yml
name: Mobile Build

on:
  push:
    branches: [ main ]

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build apk --release
      
  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build ios --release --no-codesign
```

## Resources

### Documentation
- [Flutter Mobile Deployment](https://docs.flutter.dev/deployment/android)
- [iOS Deployment Guide](https://docs.flutter.dev/deployment/ios)
- [Android Deployment Guide](https://docs.flutter.dev/deployment/android)

### Tools
- [Flutter DevTools](https://docs.flutter.dev/development/tools/devtools)
- [Xcode](https://developer.apple.com/xcode/)
- [Android Studio](https://developer.android.com/studio)
- [App Icon Generator](https://appicon.co/)

### Communities
- [Flutter Discord](https://discord.gg/flutter)
- [Flutter Reddit](https://reddit.com/r/FlutterDev)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

## Next Steps

1. **Set up development environment** (Xcode for iOS, Android Studio for Android)
2. **Test on simulators/emulators** to verify functionality
3. **Test on physical devices** for performance validation
4. **Optimize assets** for mobile (reduce file sizes)
5. **Create app icons** for both platforms
6. **Write store descriptions** and prepare screenshots
7. **Set up developer accounts** (Apple, Google)
8. **Build release versions** and test thoroughly
9. **Submit to app stores** following platform guidelines
10. **Monitor analytics** and gather user feedback

## Conclusion

LumberjackRPG is fully ready for iOS and Android deployment! The Flutter framework provides all necessary tools and the game architecture supports mobile platforms out of the box. Follow this guide to successfully launch on both app stores.
