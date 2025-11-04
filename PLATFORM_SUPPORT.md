# LumberjackRPG - Platform Support

## Supported Platforms

LumberjackRPG is a cross-platform game built with Flutter and Dart, supporting multiple platforms:

### ✅ Mobile Platforms
- **iOS** (iPhone and iPad) - iOS 11.0+
- **Android** (Phones and Tablets) - Android 5.0+ (API 21+)

### ✅ Desktop Platforms
- **macOS** - macOS 10.14+
- **Windows** - Windows 7+
- **Linux** - Most modern distributions

### ✅ Web Platform
- **Web Browsers** - Chrome, Firefox, Safari, Edge

### ✅ Terminal/CLI
- **Command Line** - Any system with Dart SDK

## Platform-Specific Features

### Mobile (iOS & Android)
```bash
# Build for iOS (requires macOS)
flutter build ios --release

# Build for Android
flutter build apk --release      # APK for direct distribution
flutter build appbundle --release # AAB for Play Store

# Run on connected device
flutter run
```

**Features:**
- Touch controls optimized for mobile
- Responsive UI for various screen sizes
- Battery-optimized rendering
- Support for both portrait and landscape modes
- Native performance

**Store Links (Coming Soon):**
- App Store: [To be published]
- Google Play: [To be published]

### Desktop (Windows, macOS, Linux)
```bash
# Build for current platform
flutter build windows --release
flutter build macos --release
flutter build linux --release

# Run on desktop
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

**Features:**
- Full keyboard support (WASD + Arrow keys)
- Mouse controls for point-and-click
- Larger screen real estate for better visibility
- No battery constraints
- Save games locally

### Web
```bash
# Build for web
flutter build web --release

# Run locally
flutter run -d chrome
flutter run -d web-server
```

**Features:**
- Play directly in browser (no installation)
- Cross-platform compatibility
- Instant updates
- Share via URL
- Progressive Web App (PWA) support

**Play Online:**
- [Game URL - To be deployed]

### Terminal/CLI
```bash
# Run terminal version
dart run bin/main.dart
```

**Features:**
- Text-based interface
- No graphics requirements
- Lightweight and fast
- Ideal for servers or minimal systems
- Full game mechanics available

## Quick Start by Platform

### For Mobile Users (iOS/Android)
1. Download from App Store or Google Play (when published)
2. Install and launch
3. Use touch controls to play
4. Swipe to move, tap to interact

### For Desktop Users (Windows/macOS/Linux)
1. Download the installer for your platform
2. Run the installer
3. Launch LumberjackRPG
4. Use keyboard (WASD/Arrows) and mouse to play

### For Web Users
1. Visit the game URL in your browser
2. Wait for assets to load
3. Click "Start Game"
4. Play directly in browser

### For Terminal Users
1. Install Dart SDK
2. Clone repository
3. Run `dart run bin/main.dart`
4. Follow text-based prompts

## Platform Comparison

| Feature | Mobile | Desktop | Web | Terminal |
|---------|--------|---------|-----|----------|
| Graphics | ✅ Full | ✅ Full | ✅ Full | ❌ Text |
| Touch Controls | ✅ | ❌ | ✅ | ❌ |
| Keyboard Controls | ❌ | ✅ | ✅ | ✅ |
| Mouse Controls | ❌ | ✅ | ✅ | ❌ |
| Save Games | ✅ | ✅ | ✅ | ⚠️ Session |
| Offline Play | ✅ | ✅ | ⚠️ PWA | ✅ |
| Performance | High | Highest | Medium | Highest |
| Installation | Store | Download | None | Manual |

## System Requirements

### Mobile
**iOS:**
- Device: iPhone 6s or newer, iPad (5th gen) or newer
- OS: iOS 11.0 or higher
- Storage: 100 MB free space
- RAM: 1 GB minimum

**Android:**
- Device: Any smartphone or tablet
- OS: Android 5.0 (Lollipop) or higher
- Storage: 100 MB free space
- RAM: 1 GB minimum

### Desktop
**Windows:**
- OS: Windows 7 or higher (64-bit)
- Processor: Intel Core i3 or equivalent
- RAM: 2 GB minimum, 4 GB recommended
- Storage: 200 MB free space

**macOS:**
- OS: macOS 10.14 (Mojave) or higher
- Processor: Intel or Apple Silicon
- RAM: 2 GB minimum, 4 GB recommended
- Storage: 200 MB free space

**Linux:**
- OS: Ubuntu 18.04, Debian 10, or equivalent
- Processor: Intel Core i3 or equivalent
- RAM: 2 GB minimum, 4 GB recommended
- Storage: 200 MB free space
- Dependencies: GLIBC 2.27 or higher

### Web
- Modern web browser (Chrome 90+, Firefox 88+, Safari 14+, Edge 90+)
- JavaScript enabled
- WebGL support
- 500 MB RAM available
- Stable internet connection (for initial load)

### Terminal
- Dart SDK 2.18.0 or higher
- Any terminal emulator
- 50 MB free space
- Minimal system requirements

## Installation Instructions

### iOS
1. Open App Store
2. Search "LumberjackRPG"
3. Tap "Get" and authenticate
4. Wait for installation
5. Launch from home screen

### Android
1. Open Google Play Store
2. Search "LumberjackRPG"
3. Tap "Install"
4. Wait for installation
5. Launch from app drawer

### Windows
1. Download `LumberjackRPG-Windows-Setup.exe`
2. Run installer
3. Follow installation wizard
4. Launch from Start Menu or Desktop

### macOS
1. Download `LumberjackRPG-macOS.dmg`
2. Open DMG file
3. Drag app to Applications folder
4. Launch from Applications

### Linux
1. Download `lumberjackrpg_1.1.0_amd64.deb` (Debian/Ubuntu)
   Or `lumberjackrpg-1.1.0-1.x86_64.rpm` (Fedora/Red Hat)
2. Install: `sudo dpkg -i lumberjackrpg_1.1.0_amd64.deb`
   Or: `sudo rpm -i lumberjackrpg-1.1.0-1.x86_64.rpm`
3. Run: `lumberjackrpg`

### Web
1. Navigate to game URL
2. Game loads automatically
3. Click "Play Now"

### Terminal
```bash
# Clone repository
git clone https://github.com/buzzedtop/LumberjackRPG.git
cd LumberjackRPG

# Install dependencies
dart pub get

# Run game
dart run bin/main.dart
```

## Building from Source

### Prerequisites
- Flutter SDK 3.0+ installed
- Dart SDK 2.18+ installed
- Platform-specific tools (Xcode for iOS, Android Studio for Android)

### Build Commands
```bash
# Clone repository
git clone https://github.com/buzzedtop/LumberjackRPG.git
cd LumberjackRPG

# Get dependencies
flutter pub get

# Build for your platform
flutter build ios --release          # iOS
flutter build apk --release          # Android APK
flutter build appbundle --release    # Android Bundle
flutter build windows --release      # Windows
flutter build macos --release        # macOS
flutter build linux --release        # Linux
flutter build web --release          # Web

# Or run in development mode
flutter run
```

## Controls by Platform

### Mobile Touch Controls
- **Tap**: Select/Interact with objects
- **Tap & Hold**: View details
- **Swipe**: Scroll/Move (if applicable)
- **Pinch**: Zoom in/out (if applicable)
- **Two-finger tap**: Special actions

### Desktop/Web Keyboard Controls
- **WASD/Arrow Keys**: Move player
- **Spacebar**: Action/Interact
- **E**: Open inventory
- **M**: Open map
- **Esc**: Menu/Pause
- **Mouse Click**: Select/Interact

### Terminal Controls
- **Text Commands**: Type actions (m, c, n, t, etc.)
- **Arrow Keys**: Navigate menus
- **Enter**: Confirm selection
- **Q**: Quit/Back

## Cross-Platform Save Games

Save games are stored locally on each platform:

- **iOS**: App Documents directory
- **Android**: App data directory  
- **Desktop**: User documents folder
- **Web**: Browser localStorage
- **Terminal**: Not persistent (session-based)

Future update may include cloud save synchronization.

## Performance Tips

### Mobile
- Close background apps for better performance
- Play with device plugged in for extended sessions
- Lower screen brightness to save battery
- Enable battery saver mode if game runs slowly

### Desktop
- Close unnecessary applications
- Update graphics drivers
- Run in fullscreen for better performance
- Reduce window size if experiencing lag

### Web
- Use latest version of Chrome or Firefox
- Close other browser tabs
- Disable browser extensions if experiencing issues
- Clear browser cache if assets don't load

### Terminal
- Use modern terminal emulator
- Increase terminal buffer size
- Disable unnecessary shell features

## Troubleshooting

### Issue: Game won't launch on mobile
- **Solution**: Restart device, check storage space, update OS

### Issue: Poor performance on mobile
- **Solution**: Close background apps, enable battery saver, reduce graphics settings

### Issue: Can't install on iOS
- **Solution**: Check iOS version (11.0+ required), free up storage

### Issue: Can't install on Android
- **Solution**: Enable "Install from Unknown Sources" for direct APK, check storage

### Issue: Web version won't load
- **Solution**: Clear browser cache, check internet connection, try different browser

### Issue: Desktop build won't run
- **Solution**: Install Visual C++ Redistributable (Windows), check Gatekeeper (macOS)

## Getting Help

- **Documentation**: See other README files in repository
- **Issues**: Report bugs on GitHub Issues
- **Discord**: [Community server - Coming soon]
- **Email**: support@lumberjackrpg.com [To be set up]

## Platform Roadmap

### Current Status (v1.1.0)
- ✅ Core game mechanics
- ✅ Terminal version complete
- ✅ Flutter/mobile framework ready
- ✅ Desktop support ready
- ✅ Web support ready

### Next Steps (v1.2.0)
- [ ] Publish to iOS App Store
- [ ] Publish to Google Play Store
- [ ] Deploy web version to hosting
- [ ] Create installers for desktop platforms
- [ ] Add cloud save synchronization
- [ ] Implement in-app purchases (mobile)
- [ ] Add gamepad support (desktop/mobile)
- [ ] Optimize for tablets
- [ ] Add accessibility features

## Conclusion

LumberjackRPG truly is a cross-platform game! Whether you prefer playing on your phone, computer, web browser, or even in a terminal, the game offers a complete experience tailored to each platform. Choose your preferred platform and start your lumberjack adventure today!
