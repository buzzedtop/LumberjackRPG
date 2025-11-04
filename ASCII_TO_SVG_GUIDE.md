# ASCII to SVG Character Migration Guide

## Overview

This guide explains how to migrate from ASCII characters to SVG-based character rendering in LumberjackRPG while maintaining backward compatibility.

## Architecture

The character rendering system supports three modes:
1. **ASCII** - Basic ASCII characters (single chars like `@`, `W`, `^`)
2. **Unicode** - Extended Unicode/Emoji (🪓, 🐺, 🌲)
3. **SVG** - Vector graphics for high-quality rendering

## Current Implementation

### Character System (`lib/character_system.dart`)

The `GameCharacter` class defines each entity with multiple representations:

```dart
const player = GameCharacter(
  name: 'Player',
  ascii: '@',           // ASCII fallback
  unicode: '🪓',        // Unicode emoji
  svgPath: 'player.svg', // SVG file path
);
```

### SVG Loader (`lib/svg_loader.dart`)

Handles loading and caching SVG files for Flutter/Flame:
- Loads SVG assets
- Converts to `ui.Image` for rendering
- Caches for performance
- Falls back to Unicode/ASCII if SVG unavailable

## Migration Path

### Phase 1: Current State (ASCII/Unicode)
✅ Terminal version uses ASCII/Unicode characters
✅ Flutter version uses generated sprite images
✅ Character definitions exist for all entities

### Phase 2: Add SVG Support (In Progress)
- [x] Create character system with multi-mode support
- [x] Add SVG loader utility
- [x] Create example SVG assets
- [x] Add flutter_svg dependency
- [ ] Update Flutter game to use SVG characters
- [ ] Create complete SVG asset library

### Phase 3: Complete Migration
- [ ] Replace all generated sprites with SVG
- [ ] Optimize SVG loading
- [ ] Add SVG animations
- [ ] Support dynamic SVG styling

## Using the Character System

### 1. Terminal/CLI Mode

```dart
import 'package:lumberjack_rpg/character_system.dart';

void main() {
  // Set rendering mode
  CharacterConfig.currentMode = RenderMode.unicode;
  
  // Display characters
  print('Player: ${GameCharacters.player.display}');
  print('Wolf: ${GameCharacters.wolf.display}');
  print('Forest: ${GameCharacters.forest.display}');
  
  // Create status bar
  final status = CharacterRenderer.statusBar(100, 100, 5, 250);
  print(status); // ❤️ HP: 100/100 | ⭐ Level: 5 (XP: 250)
}
```

### 2. Flutter/Flame Mode with SVG

```dart
import 'package:lumberjack_rpg/character_system.dart';
import 'package:lumberjack_rpg/svg_loader.dart';

class MyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    // Set to SVG mode
    CharacterConfig.currentMode = RenderMode.svg;
    CharacterConfig.svgBasePath = 'assets/svg/';
    
    // Preload common characters
    await SvgCharacterLoader.preloadCommonCharacters();
    
    // Load player character
    final playerImage = await SvgCharacterLoader.loadCharacterImage(
      GameCharacters.player,
      size: 32.0,
    );
    
    if (playerImage != null) {
      // Use image in Flame game
      add(SpriteComponent.fromImage(
        playerImage,
        position: Vector2(100, 100),
        size: Vector2(32, 32),
      ));
    }
  }
}
```

### 3. Using GameCharacterWidget (Flutter UI)

```dart
import 'package:lumberjack_rpg/svg_loader.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameCharacterWidget(
          character: GameCharacters.player,
          size: 64,
        ),
        GameCharacterWidget(
          character: GameCharacters.wolf,
          size: 48,
        ),
      ],
    );
  }
}
```

## Switching Render Modes

### At Runtime

```dart
// Switch to ASCII mode
CharacterConfig.currentMode = RenderMode.ascii;
print(GameCharacters.player.display); // Output: @

// Switch to Unicode mode  
CharacterConfig.currentMode = RenderMode.unicode;
print(GameCharacters.player.display); // Output: 🪓

// Switch to SVG mode (requires Flutter)
CharacterConfig.currentMode = RenderMode.svg;
```

### Based on Platform

```dart
import 'dart:io';

void configureRenderMode() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Desktop: Use SVG for best quality
    CharacterConfig.currentMode = RenderMode.svg;
  } else if (Platform.isAndroid || Platform.isIOS) {
    // Mobile: Use SVG with caching
    CharacterConfig.currentMode = RenderMode.svg;
    CharacterConfig.cacheSvgs = true;
  } else {
    // Web or other: Use Unicode fallback
    CharacterConfig.currentMode = RenderMode.unicode;
  }
}
```

## Creating SVG Assets

### SVG Requirements

1. **Dimensions**: 100x100 viewBox
2. **Format**: Clean, optimized SVG
3. **Colors**: Use fills and strokes
4. **Simplicity**: Keep paths simple for performance

### Example: Creating a Monster SVG

```xml
<?xml version="1.0" encoding="UTF-8"?>
<svg width="100" height="100" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <g id="dragon">
    <!-- Body -->
    <ellipse cx="50" cy="60" rx="30" ry="20" fill="#8B0000"/>
    
    <!-- Head -->
    <circle cx="30" cy="40" r="18" fill="#DC143C"/>
    
    <!-- Wings -->
    <path d="M 60 50 Q 80 30 70 50 Z" fill="#FF6347"/>
    
    <!-- Eyes -->
    <circle cx="25" cy="38" r="3" fill="#FFD700"/>
  </g>
</svg>
```

### SVG Optimization Tools

- **SVGO**: Command-line optimizer
- **SVGOMG**: Web-based optimizer
- **Inkscape**: Vector editing with export options

```bash
# Optimize all SVGs
svgo -f assets/svg/ -r
```

## Directory Structure

```
assets/
└── svg/
    ├── player.svg              # Main player character
    ├── terrain/                # Terrain tiles
    │   ├── forest.svg
    │   ├── mountain.svg
    │   ├── cave.svg
    │   ├── deep_cave.svg
    │   ├── water.svg
    │   └── road.svg
    ├── monsters/               # Enemy characters
    │   ├── wolf.svg
    │   ├── boar.svg
    │   ├── bear.svg
    │   ├── dragon.svg
    │   ├── goblin.svg
    │   └── troll.svg
    ├── buildings/              # Town buildings
    │   ├── sawmill.svg
    │   ├── water_wheel.svg
    │   ├── inn.svg
    │   ├── blacksmith.svg
    │   ├── workshop.svg
    │   ├── storehouse.svg
    │   ├── town.svg
    │   └── well.svg
    ├── resources/              # Gatherable resources
    │   ├── wood.svg
    │   └── metal.svg
    ├── items/                  # Items and equipment
    │   ├── axe_stone.svg
    │   ├── axe_iron.svg
    │   ├── treasure.svg
    │   └── gold.svg
    └── ui/                     # UI elements
        ├── heart.svg
        ├── star.svg
        ├── clock.svg
        ├── sun.svg
        └── moon.svg
```

## Adding to pubspec.yaml

```yaml
dependencies:
  flutter_svg: ^2.0.9

flutter:
  assets:
    - assets/svg/
    - assets/svg/terrain/
    - assets/svg/monsters/
    - assets/svg/buildings/
    - assets/svg/resources/
    - assets/svg/items/
    - assets/svg/ui/
```

## Performance Considerations

### Caching

```dart
// Enable caching (default)
CharacterConfig.cacheSvgs = true;

// Clear cache when needed
SvgCharacterLoader.clearCache();
```

### Preloading

```dart
// Preload on game start
await SvgCharacterLoader.preloadCommonCharacters();

// Batch load specific characters
final characters = [
  GameCharacters.wolf,
  GameCharacters.boar,
  GameCharacters.bear,
];
await SvgCharacterLoader.loadCharacters(characters);
```

### Optimization Tips

1. **Use Simple Paths**: Complex SVGs slow down rendering
2. **Enable Caching**: Reuse loaded assets
3. **Preload Critical Assets**: Load frequently-used characters on startup
4. **Optimize SVG Files**: Remove unnecessary metadata
5. **Size Appropriately**: Don't render huge SVGs for small sprites

## Fallback Strategy

The system automatically falls back when SVGs aren't available:

```
SVG (preferred) → Unicode (fallback) → ASCII (last resort)
```

Configure fallback behavior:

```dart
CharacterConfig.useFallback = true; // Enable fallback (default)
```

## Testing

### Test All Render Modes

```dart
void testRenderModes() {
  for (final mode in RenderMode.values) {
    CharacterConfig.currentMode = mode;
    print('Mode: $mode');
    print('Player: ${GameCharacters.player.display}');
    print('Wolf: ${GameCharacters.wolf.display}');
    print('---');
  }
}
```

### Verify SVG Loading

```dart
void testSvgLoading() async {
  final image = await SvgCharacterLoader.loadCharacterImage(
    GameCharacters.player,
    size: 32,
  );
  
  if (image != null) {
    print('✓ SVG loaded successfully');
    print('  Size: ${image.width}x${image.height}');
  } else {
    print('✗ SVG failed to load');
  }
}
```

## Migration Checklist

- [x] Create character system with multi-mode support
- [x] Add SVG loader utility
- [x] Add flutter_svg dependency
- [x] Create example SVG assets (player, tree, wolf)
- [ ] Create complete SVG asset library
- [ ] Update LumberjackRPG game class to use SVG
- [ ] Update terminal version to use character system
- [ ] Add render mode configuration to settings
- [ ] Performance test with large maps
- [ ] Create SVG animation support
- [ ] Add documentation for artists

## Next Steps

### For Developers

1. **Update Game Code**: Integrate character system into main game
2. **Add Configuration**: Let users choose render mode
3. **Performance Tune**: Profile and optimize SVG loading
4. **Add Tests**: Test all render modes

### For Artists

1. **Create SVGs**: Design complete character set
2. **Follow Guidelines**: Use 100x100 viewBox
3. **Optimize Files**: Keep file sizes small
4. **Test Rendering**: Verify appearance in-game

## Resources

- **flutter_svg documentation**: https://pub.dev/packages/flutter_svg
- **SVG specification**: https://www.w3.org/TR/SVG2/
- **SVGO optimizer**: https://github.com/svg/svgo
- **Inkscape**: https://inkscape.org/

## Support

For questions or issues with the character system:
1. Check existing SVG examples in `assets/svg/`
2. Review `character_system.dart` for character definitions
3. See `svg_loader.dart` for loading implementation
4. Create an issue with reproduction steps

---

**Status**: Phase 2 - SVG support infrastructure complete, asset creation in progress
