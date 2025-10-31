# Architecture and Design

## Problem Statement
The task was to:
1. Recreate the program to run in a terminal
2. Support future GUI efforts
3. Add building mechanics (sawmills, water wheels, inns, medieval elements)
4. Add resource production capabilities
5. Introduce a dungeon gateway in a well in the town center

## Solution Architecture

### Separation of Concerns

The solution follows a clean architecture pattern that separates:

1. **Core Game Logic** (platform-independent)
   - Game state management
   - Entity behavior
   - Resource mechanics
   - Building system
   - Dungeon system

2. **Presentation Layer** (platform-specific)
   - Terminal interface (`bin/main.dart`)
   - GUI interface (`lib/main.dart` + `lib/lumberjack_rpg.dart`)

### Key Design Decisions

#### 1. GameState Class
The `GameState` class acts as the central coordinator:
- Manages all game entities (player, map, town, dungeon, monsters)
- Handles mode transitions (exploration, town, dungeon)
- Provides turn-based progression
- Exposes game state for any interface to consume

**Benefits:**
- Both terminal and GUI can use the same game logic
- Easy to test game mechanics independently
- Future support for multiplayer or save/load
- Can add more interfaces (web, mobile) without changing core logic

#### 2. Building System
Buildings are represented as data objects with:
- Construction costs (resources needed)
- Production rates (resources generated per turn)
- Level system (upgradable)
- Operational state

**Medieval Buildings Implemented:**
- **Sawmill**: Converts raw wood into planks
- **Water Wheel**: Generates mechanical power
- **Inn**: Produces gold from travelers
- **Blacksmith**: Forges tools
- **Workshop**: Crafts various goods
- **Storehouse**: Increases storage capacity

#### 3. Town System
The town serves as:
- Central hub for the player
- Resource storage depot
- Building construction site
- Gateway to the dungeon (via well)

**Features:**
- Resource accumulation from buildings
- Inventory transfer between player and town
- Building management
- Production automation each turn

#### 4. Dungeon System
Three-tiered dungeon accessed via town well:
- **Entrance Level**: Basic monsters, modest treasure
- **The Depths**: Stronger monsters, better rewards
- **The Abyss**: Ultimate challenge, legendary items

**Mechanics:**
- Must defeat all monsters before descending
- Progressive difficulty
- Treasure collection after clearing each level
- Can retreat to town at any time

### Code Organization

```
lib/
  ├── game_state.dart      # Central game coordinator
  ├── lumberjack.dart      # Player character logic
  ├── monster.dart         # Monster entities
  ├── building.dart        # Building system
  ├── town.dart            # Town management
  ├── dungeon.dart         # Dungeon system
  ├── game_map.dart        # World generation
  ├── wood.dart            # Wood resources
  ├── metal.dart           # Metal resources
  ├── axe.dart             # Weapon system
  ├── crafting_system.dart # Crafting mechanics
  ├── constants.dart       # Game constants
  ├── main.dart            # Flutter/GUI entry point
  └── lumberjack_rpg.dart  # Flutter/Flame game engine

bin/
  └── main.dart            # Terminal interface
```

### Interface Implementations

#### Terminal Interface (`bin/main.dart`)
- Text-based interaction
- Command-driven gameplay
- Fast iteration for gameplay testing
- No dependencies on Flutter/Flame
- Pure Dart - can run anywhere

**Interaction Pattern:**
```
1. Display game state
2. Show available actions
3. Get user input
4. Process action
5. Update game state
6. Advance turn
7. Repeat
```

#### GUI Interface (`lib/main.dart`, `lib/lumberjack_rpg.dart`)
- Visual representation using Flutter/Flame
- Real-time rendering
- Mouse/keyboard controls
- Sprite-based graphics
- Can share the same GameState

**Potential Integration:**
```dart
// Future GUI enhancement
class EnhancedLumberjackRPG extends FlameGame {
  late GameState gameState;
  
  @override
  Future<void> onLoad() async {
    gameState = GameState(mapSize: 42);
    // Render gameState.town.buildings
    // Render gameState.dungeon
    // etc.
  }
}
```

## How It Works

### Starting the Game

**Terminal Mode:**
```bash
dart run bin/main.dart
```

The terminal interface:
1. Creates a new GameState
2. Initializes map, town, and dungeon
3. Enters main game loop
4. Displays state and accepts commands
5. Processes player actions
6. Updates game state

**GUI Mode (existing):**
```bash
flutter run
```

### Game Flow

```
Start
  ↓
Create GameState (map, player, town, dungeon)
  ↓
EXPLORATION MODE ←→ TOWN MODE ←→ DUNGEON MODE
  ↑                   ↓              ↓
  └─────────────── Exit ←───────────┘
```

### Resource Production Loop

Each turn:
1. Player takes actions (gather, fight, build)
2. `advanceTurn()` is called
3. All buildings produce resources
4. Resources added to town storage
5. State is updated for display

Example:
```dart
void advanceTurn() {
  turnCount++;
  town.produceResources(); // Buildings produce each turn
}
```

### Building Construction

1. Player deposits resources to town
2. Views available buildings
3. Selects building to construct
4. System checks if enough resources
5. Deducts costs and creates building
6. Building starts producing next turn

### Dungeon Exploration

1. Player enters town
2. Interacts with well
3. Enters dungeon (mode switch)
4. Fights monsters on current level
5. Collects treasure when level cleared
6. Descends deeper or exits
7. Returns to town with loot

## Benefits of This Architecture

### 1. Faster Development
- Test gameplay in terminal (instant startup)
- No need to wait for Flutter compilation
- Quick iteration on game mechanics

### 2. Platform Independence
- Core logic works anywhere Dart runs
- Can add web, mobile, desktop interfaces
- Easy to port to other languages

### 3. Testability
- Game logic separated from presentation
- Can write unit tests for mechanics
- Mock different interface behaviors

### 4. Maintainability
- Clear separation of concerns
- Each module has single responsibility
- Easy to add new features

### 5. Future-Proof
- GUI can be added/enhanced without breaking terminal
- Multiple UIs can coexist
- Save/load, multiplayer easy to add

## Extension Points

### Adding New Buildings
```dart
// In lib/building.dart
static Building createMine() {
  return Building(
    type: BuildingType.mine,
    name: 'Mine',
    constructionCost: {'wood': 40, 'iron': 30},
    productionRate: {'iron': 3.0, 'stone': 5.0},
  );
}
```

### Adding New Dungeon Levels
```dart
// In lib/dungeon.dart
enum DungeonLevel { entrance, depths, abyss, underworld }

// Then update _generateDungeon()
monsters[DungeonLevel.underworld] = [
  Monster('demon', level: 15),
  // ...
];
```

### Adding New Game Modes
```dart
// In lib/game_state.dart
enum GameMode { exploration, town, dungeon, trading, crafting }
```

## Conclusion

The solution successfully:
✅ Creates terminal-based gameplay
✅ Preserves existing GUI functionality
✅ Implements building mechanics (6 medieval buildings)
✅ Adds resource production system
✅ Creates dungeon with well entrance in town
✅ Separates core logic from presentation
✅ Enables future GUI enhancements

The architecture is clean, maintainable, and extensible.
