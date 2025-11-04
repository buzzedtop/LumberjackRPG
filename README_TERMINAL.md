# LumberjackRPG - Terminal Edition

> **Looking for the GUI version?** See [README.md](README.md) for instructions on running the Flame engine GUI with graphics.

## Overview
LumberjackRPG has been enhanced to support both terminal-based gameplay and GUI gameplay (Flutter). This allows you to:
- Play the game in a terminal with full building mechanics
- Use the same game logic for future GUI development
- Build medieval structures like sawmills, water wheels, and inns
- Explore dungeons through a well in the town center

## New Features

### Terminal Mode
Run the game from your terminal with a text-based interface:
```bash
dart run bin/main.dart
```

### Building System
Construct medieval buildings in your town:
- **Sawmill**: Converts wood into planks (requires: 50 wood, 20 iron)
- **Water Wheel**: Generates power for other buildings (requires: 30 wood, 15 iron)
- **Inn**: Generates gold from visitors (requires: 40 wood, 20 planks)
- **Blacksmith**: Produces tools (requires: 30 wood, 25 iron)
- **Workshop**: Produces goods (requires: 35 wood, 15 planks, 10 iron)
- **Storehouse**: Increases storage capacity (requires: 60 wood, 30 planks)

### Town System
- Town is centrally located on the map
- Buildings can be constructed using gathered resources
- Resources are produced automatically each turn
- Transfer inventory between player and town storage

### Dungeon System
- Enter the dungeon through the well in the town center
- Three dungeon levels: Entrance, The Depths, and The Abyss
- Fight progressively stronger monsters
- Collect treasure on each level
- Must defeat all monsters before descending deeper

## Installation & Running

### Prerequisites
- Dart SDK 2.18.0 or higher
- OR Flutter SDK (for GUI mode)

### Terminal Mode
1. Clone the repository
2. Navigate to the project directory
3. Run: `dart run bin/main.dart`

### GUI Mode (Flutter)
1. Install Flutter dependencies: `flutter pub get`
2. Run: `flutter run`

## Architecture

The code is structured to support both terminal and GUI interfaces:

### Core Game Logic (Shared)
- `lib/game_state.dart` - Central game state management
- `lib/lumberjack.dart` - Player character logic
- `lib/game_map.dart` - World generation
- `lib/monster.dart` - Monster entities
- `lib/building.dart` - Building system
- `lib/town.dart` - Town management
- `lib/dungeon.dart` - Dungeon system

### Interface Layers
- `bin/main.dart` - Terminal interface
- `lib/main.dart` + `lib/lumberjack_rpg.dart` - Flutter/Flame GUI

This separation allows you to:
- Develop game mechanics in the terminal (faster iteration)
- Add GUI visualization later without changing core logic
- Test gameplay balance quickly
- Support multiple platforms

## Gameplay

### Terminal Controls

#### Exploration Mode
- `m` - Move (then choose direction: w/a/s/d)
- `c` - Chop wood at current location
- `n` - Mine metal at current location
- `t` - Enter town (when nearby)
- `i` - Show inventory
- `s` - Show map info
- `q` - Quit game

#### Town Mode
- `b` - Build structure
- `v` - View buildings
- `d` - Deposit inventory to town
- `w` - Enter well (dungeon entrance)
- `e` - Exit town
- `q` - Quit game

#### Dungeon Mode
- `f` - Fight monster
- `t` - Collect treasure
- `d` - Descend deeper
- `u` - Ascend/Exit
- `q` - Quit game

## Development

### Adding New Buildings
1. Add building type to `BuildingType` enum in `lib/building.dart`
2. Create static factory method in `Building` class
3. Add construction option in `bin/main.dart` (buildStructure function)

### Adding New Dungeon Levels
1. Add level to `DungeonLevel` enum in `lib/dungeon.dart`
2. Update `_generateDungeon()` method with monsters and treasures
3. Update navigation logic in `descend()` and `ascend()` methods

### Supporting GUI
The GUI can access the same game state:
```dart
import 'package:lumberjack_rpg/game_state.dart';

void main() {
  final game = GameState(mapSize: 42);
  // Render game state in Flutter/Flame
}
```

## Future Enhancements
- Save/load game state
- More building types (chapel, barracks, farm)
- Resource trading system
- NPC villagers
- Quest system
- Multiplayer support
- Enhanced GUI with sprites and animations
