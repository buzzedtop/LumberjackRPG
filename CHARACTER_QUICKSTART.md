# Quick Start: ASCII to SVG Characters

## 🎯 TL;DR

LumberjackRPG now supports **three character rendering modes**:
- **ASCII** (`@`, `W`, `^`) - Classic terminal characters
- **Unicode** (🪓, 🐺, 🌲) - Emoji for better visuals  
- **SVG** (vector graphics) - High-quality scalable graphics

## ⚡ Quick Examples

### Terminal/CLI: Display Characters

```dart
import 'package:lumberjack_rpg/character_system.dart';

// Use Unicode emoji (recommended for terminal)
CharacterConfig.currentMode = RenderMode.unicode;

print('Player: ${GameCharacters.player.display}');     // 🪓
print('Wolf: ${GameCharacters.wolf.display}');         // 🐺
print('Forest: ${GameCharacters.forest.display}');     // 🌲
```

### Flutter/Flame: Load SVG Characters

```dart
import 'package:lumberjack_rpg/svg_loader.dart';

// Enable SVG mode
CharacterConfig.currentMode = RenderMode.svg;

// Load and use
final playerImage = await SvgCharacterLoader.loadCharacterImage(
  GameCharacters.player,
  size: 32.0,
);

add(SpriteComponent.fromImage(playerImage, ...));
```

### Widget: Display Character

```dart
import 'package:lumberjack_rpg/svg_loader.dart';

// In your Flutter UI
GameCharacterWidget(
  character: GameCharacters.wolf,
  size: 64,
)
```

## 📦 What's Included

### Available Characters

**Terrain**: forest 🌲, mountain ⛰️, cave 🕳️, water 💧, road 🛤️  
**Monsters**: wolf 🐺, bear 🐻, dragon 🐉, goblin 👺, troll 👹  
**Buildings**: sawmill 🏭, inn 🏠, blacksmith ⚒️, town 🏘️  
**Items**: wood 🪵, metal ⛏️, gold 🪙, treasure 💰  
**UI**: heart ❤️, star ⭐, clock ⏰, sun ☀️, moon 🌙

### Example SVG Assets

- `assets/svg/player.svg` - Player with axe
- `assets/svg/terrain/forest.svg` - Tree
- `assets/svg/monsters/wolf.svg` - Wolf enemy

## 🚀 Getting Started

### 1. Run the Demo

```bash
dart examples/character_demo.dart
```

This shows all characters in ASCII and Unicode modes.

### 2. Use in Your Code

```dart
// Switch modes anytime
CharacterConfig.currentMode = RenderMode.ascii;    // @
CharacterConfig.currentMode = RenderMode.unicode;  // 🪓
CharacterConfig.currentMode = RenderMode.svg;      // <svg>

// Display any character
print(GameCharacters.player.display);
```

### 3. Create Status Bars

```dart
// Render health/stats with icons
final status = CharacterRenderer.statusBar(85, 100, 5, 450);
print(status); // ❤️ HP: 85/100 | ⭐ Level: 5 (XP: 450)

// Day/night indicator
print(CharacterRenderer.timeIndicator(true));  // ☀️
print(CharacterRenderer.timeIndicator(false)); // 🌙
```

## 📝 Adding New Characters

```dart
// Define once, use everywhere
const myMonster = GameCharacter(
  name: 'Slime',
  ascii: 'S',
  unicode: '🟢',
  svgPath: 'monsters/slime.svg',
);

// Use it
print(myMonster.display);
```

## 🎨 Creating SVG Files

1. **Size**: 100x100 viewBox
2. **Format**: Standard SVG
3. **Location**: `assets/svg/...`

Example:
```xml
<svg width="100" height="100" viewBox="0 0 100 100">
  <circle cx="50" cy="50" r="40" fill="green"/>
</svg>
```

## 🔧 Configuration

```dart
// Set base path for SVG files
CharacterConfig.svgBasePath = 'assets/svg/';

// Enable/disable caching
CharacterConfig.cacheSvgs = true;

// Enable fallback (SVG → Unicode → ASCII)
CharacterConfig.useFallback = true;
```

## 📚 Full Documentation

- **ASCII_TO_SVG_GUIDE.md** - Complete migration guide
- **lib/character_system.dart** - Character definitions
- **lib/svg_loader.dart** - SVG loading implementation

## 🎮 Run Examples

```bash
# Character demo (terminal)
dart examples/character_demo.dart

# Game with characters
flutter run
```

## ✅ What's Ready

- ✅ Character system with 3 render modes
- ✅ 50+ predefined game characters
- ✅ SVG loader with caching
- ✅ 3 example SVG assets
- ✅ Demo showing all features
- ✅ Complete documentation

## 🚧 Next Steps

1. Create more SVG assets (see ASCII_TO_SVG_GUIDE.md)
2. Integrate into main game loop
3. Add SVG animations (future enhancement)

---

**Questions?** Check ASCII_TO_SVG_GUIDE.md for full details!
