# Quick Start - Flame GUI

This is a quick reference guide for running the LumberjackRPG Flame engine GUI. For complete documentation, see [README.md](README.md).

## ⚡ Super Quick Start

If you already have Flutter installed:

```bash
git clone https://github.com/buzzedtop/LumberjackRPG.git
cd LumberjackRPG
flutter pub get
flutter run
```

Done! The game will launch on your default device.

## 🔧 First Time Setup

### 1. Install Flutter

**macOS/Linux:**
```bash
git clone https://github.com/flutter/flutter.git -b stable ~/flutter
export PATH="$PATH:$HOME/flutter/bin"
flutter doctor
```

**Windows:**
- Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
- Extract to `C:\flutter`
- Add `C:\flutter\bin` to PATH
- Run `flutter doctor`

### 2. Get the Game

```bash
git clone https://github.com/buzzedtop/LumberjackRPG.git
cd LumberjackRPG
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the Game

```bash
flutter run
```

## 🎯 Platform-Specific Commands

### Desktop

```bash
flutter run -d macos      # macOS
flutter run -d windows    # Windows  
flutter run -d linux      # Linux
```

### Mobile Simulator

```bash
flutter run -d "iPhone 14 Pro"    # iOS Simulator (macOS only)
flutter run -d emulator-5554      # Android Emulator
```

### Web

```bash
flutter run -d chrome
```

## 🎮 Controls

### Keyboard
- **WASD** or **Arrow Keys** - Move
- **Space** - Attack/Interact
- **ESC** - Pause/Menu

### Touch (Mobile)
- **Tap** - Move/Interact

## 🔨 Development Commands

### Hot Reload
Press `r` in the terminal after making code changes

### Hot Restart
Press `R` in the terminal for full restart

### Release Build
```bash
flutter run --release
```

## ❓ Troubleshooting

### No devices found
```bash
flutter config --enable-macos-desktop
flutter config --enable-windows-desktop
flutter config --enable-linux-desktop
```

### Dependencies fail
```bash
flutter clean
flutter pub get
```

### Black screen
1. Check console for errors
2. Try: `flutter clean && flutter run`
3. Toggle `usePreGeneratedAssets` in `lib/lumberjack_rpg.dart`

## 📚 More Information

- **Full Documentation:** [README.md](README.md)
- **Terminal Mode:** [README_TERMINAL.md](README_TERMINAL.md)
- **Architecture:** [ARCHITECTURE.md](ARCHITECTURE.md)
- **Platform Support:** [PLATFORM_SUPPORT.md](PLATFORM_SUPPORT.md)

## 🆘 Getting Help

- GitHub Issues: [Report a bug](https://github.com/buzzedtop/LumberjackRPG/issues)
- Flame Docs: [docs.flame-engine.org](https://docs.flame-engine.org/)
- Flutter Docs: [docs.flutter.dev](https://docs.flutter.dev/)

---

**Ready to play?** Run `flutter run` and start chopping! 🪓
