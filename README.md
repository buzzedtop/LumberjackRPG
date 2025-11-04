# LumberjackRPG

A 2D top-down RPG built with Flutter and the Flame game engine. Chop wood, mine resources, build structures, and explore dungeons in this medieval-themed adventure game.

## 🎮 Game Modes

LumberjackRPG supports two play modes:

1. **GUI Mode (Flame Engine)** - Full graphical interface with sprites and real-time rendering
2. **Terminal Mode** - Text-based command-line interface for quick testing

This README focuses on running the **GUI mode with Flame engine**. For terminal mode, see [README_TERMINAL.md](README_TERMINAL.md).

## 🚀 Quick Start - Running the GUI

### Prerequisites

- **Flutter SDK** 3.0 or higher
- **Dart SDK** 2.18.0 or higher (included with Flutter)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/buzzedtop/LumberjackRPG.git
   cd LumberjackRPG
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the game:**
   ```bash
   flutter run
   ```

That's it! The Flame engine GUI will launch on your default device (desktop, mobile simulator, or connected device).

## 📋 Detailed Setup Instructions

### Installing Flutter

If you don't have Flutter installed:

#### macOS
```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable ~/flutter

# Add to PATH (add this to ~/.zshrc or ~/.bash_profile)
export PATH="$PATH:$HOME/flutter/bin"

# Verify installation
flutter doctor
```

#### Linux
```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable ~/flutter

# Add to PATH (add this to ~/.bashrc)
export PATH="$PATH:$HOME/flutter/bin"

# Verify installation
flutter doctor
```

#### Windows
1. Download the Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
2. Extract to `C:\flutter`
3. Add `C:\flutter\bin` to your system PATH
4. Run `flutter doctor` in Command Prompt

### Verifying Installation

Run `flutter doctor` to check your installation:

```bash
flutter doctor
```

This will check for:
- ✓ Flutter SDK
- ✓ Connected devices
- ✓ Android toolchain (for mobile development)
- ✓ Xcode (for iOS development on macOS)
- ✓ Chrome (for web development)

You only need Flutter SDK installed to run on desktop. Platform-specific tools are only needed for their respective platforms.

## 🎯 Running on Different Platforms

### Desktop (macOS, Windows, Linux)

Run on your current desktop platform:
```bash
flutter run -d macos    # macOS
flutter run -d windows  # Windows
flutter run -d linux    # Linux
```

Or simply:
```bash
flutter run
```
Flutter will automatically select your desktop platform.

### Mobile Simulator/Emulator

**iOS Simulator (macOS only):**
```bash
# List available simulators
flutter devices

# Run on specific simulator
flutter run -d "iPhone 14 Pro"
```

**Android Emulator:**
```bash
# Start an emulator first from Android Studio, then:
flutter run -d emulator-5554
```

### Web Browser

```bash
flutter run -d chrome
```

### Mobile Device (Physical)

Connect your device via USB with developer mode enabled:

```bash
# List connected devices
flutter devices

# Run on connected device
flutter run
```

## 🎨 GUI Features

The Flame engine GUI provides:

- **Real-time rendering** - Smooth 60 FPS gameplay
- **Procedural terrain generation** - Dynamic maps using Perlin noise
- **Sprite-based graphics** - Character, monsters, resources, and terrain
- **Touch and keyboard controls** - Support for multiple input methods
- **Asset generation** - Runtime or pre-generated asset loading

### Controls

**Keyboard:**
- **WASD** or **Arrow Keys** - Move player
- **Space** - Attack/Interact
- **E** - Inventory (when implemented)
- **M** - Map (when implemented)
- **ESC** - Menu/Pause

**Touch (Mobile):**
- **Tap** - Move to location / Interact with objects
- **Hold** - Context menu (when implemented)

## 🛠️ Development Workflow

### Hot Reload

Flutter supports hot reload for fast development:

1. Make code changes in `lib/` files
2. Press `r` in the terminal where `flutter run` is running
3. Changes appear instantly without losing game state

### Hot Restart

For larger changes (like changing game initialization):

1. Press `R` (capital R) in the terminal
2. Game restarts with new changes

### Debug Mode vs Release Mode

**Debug mode (default):**
```bash
flutter run
```
- Includes debug information
- Hot reload enabled
- Slower performance

**Release mode:**
```bash
flutter run --release
```
- Optimized performance
- No hot reload
- Production-ready build

## 🏗️ Project Structure

### GUI-Related Files

```
lib/
├── main.dart              # Flutter app entry point
├── lumberjack_rpg.dart    # Flame game engine implementation
├── lumberjack.dart        # Player character
├── monster.dart           # Monster entities
├── game_map.dart          # World/map generation
├── game_state.dart        # Core game logic (shared with terminal)
├── building.dart          # Building system
├── town.dart              # Town management
└── dungeon.dart           # Dungeon system

assets/
├── map/                   # Terrain tile sprites
├── entities/              # Character and monster sprites
├── resources/             # Resource item sprites
└── svg/                   # SVG assets (optional)
```

### Key Files for GUI Development

- **`lib/lumberjack_rpg.dart`** - Main Flame game class
  - Contains game loop, rendering, and input handling
  - `usePreGeneratedAssets` flag toggles between runtime and pre-generated assets
  - Asset generation and caching logic

- **`lib/main.dart`** - Flutter wrapper
  - Sets up Material app
  - Configures screen orientation
  - Embeds Flame game in Flutter widget tree

## 🔧 Configuration

### Asset Loading Mode

In `lib/lumberjack_rpg.dart`, you can toggle between runtime generation and pre-generated assets:

```dart
// Toggle between pre-generated and runtime-generated assets
static const bool usePreGeneratedAssets = false;
```

- `false` - Assets generated at runtime (slower startup, no pre-generated files needed)
- `true` - Uses pre-generated assets from `assets/` directory (faster, requires asset generation)

### Screen Orientation

In `lib/main.dart`, configure supported orientations:

```dart
SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
  DeviceOrientation.landscapeLeft,
  DeviceOrientation.landscapeRight,
]);
```

## 📦 Dependencies

The game uses these Flame and Flutter packages:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flame: ^1.30.1              # Flame game engine
  flame_noise: ^0.1.1+6       # Procedural noise generation
  flutter_svg: ^2.0.9         # SVG rendering
  image: ^4.2.0               # Image processing
  vector_math: ^2.1.0         # Vector mathematics
```

These are automatically installed with `flutter pub get`.

## 🐛 Troubleshooting

### "No devices found"

**Problem:** `flutter run` says no devices available.

**Solution:**
```bash
# Enable desktop support (one-time setup)
flutter config --enable-macos-desktop
flutter config --enable-windows-desktop
flutter config --enable-linux-desktop

# Verify
flutter devices
```

### "Could not resolve dependencies"

**Problem:** Package resolution fails.

**Solution:**
```bash
# Clean and reinstall
flutter clean
flutter pub get
```

### "Flame game not rendering"

**Problem:** Black screen or no game content.

**Solution:**
1. Check console for errors
2. Verify assets are loading (check `pubspec.yaml`)
3. Try clearing cache: `flutter clean`
4. Toggle `usePreGeneratedAssets` flag in `lumberjack_rpg.dart`

### Poor Performance

**Problem:** Low FPS or stuttering.

**Solution:**
1. Run in release mode: `flutter run --release`
2. Close other applications
3. Reduce asset resolution if using custom assets
4. Check `flutter doctor` for platform-specific optimizations

### Assets Not Loading

**Problem:** Missing sprites or textures.

**Solution:**
1. Verify `pubspec.yaml` includes all asset paths
2. Run `flutter pub get` after modifying `pubspec.yaml`
3. Check that asset files exist in `assets/` directory
4. Try runtime generation by setting `usePreGeneratedAssets = false`

## 🎓 Learning Resources

### Flame Engine Documentation
- [Flame Official Docs](https://docs.flame-engine.org/)
- [Flame GitHub](https://github.com/flame-engine/flame)
- [Flame Examples](https://github.com/flame-engine/flame/tree/main/examples)

### Flutter Documentation
- [Flutter Official Docs](https://docs.flutter.dev/)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

### Game-Specific Docs
- [Terminal Mode Guide](README_TERMINAL.md) - Command-line gameplay
- [Architecture Overview](ARCHITECTURE.md) - Code structure
- [Platform Support](PLATFORM_SUPPORT.md) - Multi-platform deployment
- [Mobile Deployment](MOBILE_DEPLOYMENT.md) - iOS/Android publishing
- [Flame Update Guide](FLAME_UPDATE_GUIDE.md) - Engine version updates

## 🔨 Building for Distribution

### Desktop Application

**macOS:**
```bash
flutter build macos --release
# Output: build/macos/Build/Products/Release/LumberjackRPG.app
```

**Windows:**
```bash
flutter build windows --release
# Output: build\windows\runner\Release\
```

**Linux:**
```bash
flutter build linux --release
# Output: build/linux/x64/release/bundle/
```

### Mobile Application

**Android APK:**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**iOS:**
```bash
flutter build ios --release
# Requires macOS and Xcode
```

See [MOBILE_DEPLOYMENT.md](MOBILE_DEPLOYMENT.md) for detailed mobile build instructions.

### Web Application

```bash
flutter build web --release
# Output: build/web/
```

Deploy the `build/web/` directory to any static hosting service.

## 🎮 Gameplay

### Core Mechanics

- **Exploration** - Navigate a procedurally generated world
- **Resource Gathering** - Chop wood and mine metals
- **Building** - Construct medieval structures in your town
- **Combat** - Fight monsters in dungeons
- **Town Management** - Build and upgrade buildings for resource production

### Game Progression

1. Start in the wilderness
2. Gather basic resources (wood, iron)
3. Build your first structures (sawmill, water wheel)
4. Expand your town with more buildings
5. Enter dungeons to fight monsters and collect treasure
6. Upgrade and optimize your resource production

For detailed gameplay mechanics, see [README_TERMINAL.md](README_TERMINAL.md).

## 🤝 Contributing

Contributions are welcome! The game is structured to be easy to extend:

- **Adding buildings** - See `lib/building.dart`
- **Adding monsters** - See `lib/monster.dart` and `lib/dungeon.dart`
- **Adding assets** - Add to `assets/` and update `pubspec.yaml`
- **Modifying game logic** - Core logic in `lib/game_state.dart` is shared between GUI and terminal

## 📄 License

This project is open source. See LICENSE file for details.

## 🙏 Acknowledgments

- Built with [Flutter](https://flutter.dev/) and [Flame](https://flame-engine.org/)
- Procedural generation using [flame_noise](https://pub.dev/packages/flame_noise)
- Game design inspired by classic RPGs and resource management games

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/buzzedtop/LumberjackRPG/issues)
- **Documentation:** See other README files in the repository
- **Community:** [Discord/Forum - Coming Soon]

---

**Ready to play?** Run `flutter run` and start your lumberjack adventure! 🪓🌲
