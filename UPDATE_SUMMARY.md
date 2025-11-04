# LumberjackRPG - Flame Engine Update & Test Suite

## 🎮 What's New

This update brings major improvements to the LumberjackRPG codebase:

1. **Updated Flame Engine** from version 1.8.0 to 1.17.0
2. **Comprehensive Test Suite** with 11 test files covering all game mechanics
3. **Automated Test Runner** for easy validation
4. **Complete Documentation** for tests and updates

## 🔥 Flame Engine Update

### Version Upgrade
- **From**: Flame 1.8.0
- **To**: Flame 1.17.0
- **flame_noise**: Updated to 0.1.1+6

### Why Update?
- Improved performance and rendering
- Better component lifecycle management
- Enhanced collision detection
- More utilities and features
- Bug fixes and stability improvements

### Compatibility
All existing game code is fully compatible with Flame 1.17.0. No breaking changes required!

## 🧪 Comprehensive Test Suite

### Test Coverage

The test suite includes **130+ individual test cases** across 11 test files:

#### Core Mechanics (6 test files)
1. **lumberjack_test.dart** (13 tests)
   - Player initialization and stats
   - Resource gathering (wood & metal)
   - Combat mechanics
   - Leveling system
   - Inventory management

2. **wood_test.dart** (7 tests)
   - Wood resource properties
   - Durability mechanics
   - Biome associations
   - Resource depletion

3. **metal_test.dart** (8 tests)
   - Metal ore properties
   - Mining mechanics
   - Rarity tiers
   - Durability system

4. **monster_test.dart** (12 tests)
   - Monster spawning
   - Level-based stat scaling
   - Combat damage
   - Death mechanics
   - Position tracking

5. **axe_test.dart** (7 tests)
   - Weapon types (stone → osmium)
   - Damage progression
   - Upgrade tiers

6. **game_map_test.dart** (12 tests)
   - Map generation
   - Biome diversity
   - Resource placement
   - Road generation
   - Spawn points

#### Game Systems (5 test files)
7. **crafting_system_test.dart** (8 tests)
   - Crafting requirements
   - Resource consumption
   - Axe crafting

8. **building_test.dart** (15 tests)
   - 6 building types
   - Resource production
   - Level/upgrade system
   - Operational state

9. **town_test.dart** (16 tests)
   - Town management
   - Resource storage
   - Building construction
   - Production cycles

10. **dungeon_test.dart** (15 tests)
    - 20-level dungeon system
    - Monster spawning
    - Treasure generation
    - Level progression

11. **game_state_test.dart** (20+ tests)
    - Game state integration
    - Time system
    - Mode transitions
    - Action timing
    - Complete gameplay flow

### Game Mechanics Validated

✅ **Player Progression**
- Starting stats (Level 1, 100 HP)
- Experience gain (10 XP wood, 15 XP metal, 20 XP per monster level)
- Leveling (requires level × 100 XP)
- Health increases (+10 HP per level)

✅ **Resource System**
- Wood: 15 types across 6 biomes
- Metal: 8 types from iron to osmium
- Durability: 3-15 hits to deplete
- Biome matching validation

✅ **Combat System**
- Monster stats scale by level
- Health: 50 + (level × 10)
- Damage: 5 + (level × 2)
- Player damage based on axe type

✅ **Weapon Progression**
- Stone (10 dmg) → Iron (15 dmg) → Steel (20 dmg) → Titanium (30 dmg) → Osmium (50 dmg)

✅ **Time System**
- Movement: 10 minutes
- Chopping: 30 minutes
- Mining: 45 minutes
- Combat: 15 minutes
- Building: 120 minutes
- Resting: 60 minutes

✅ **Building System**
- 6 building types: Sawmill, Water Wheel, Inn, Blacksmith, Workshop, Storehouse
- Resource production per turn
- Level upgrades increase production

✅ **Dungeon System**
- 20 progressive levels
- Increasing difficulty
- Treasure rewards
- Must clear level to descend

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (2.18.0+)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/buzzedtop/LumberjackRPG.git
cd LumberjackRPG
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Validate setup**
```bash
./validate.sh
```

This will check:
- Project structure
- Dependencies
- Test suite
- Code structure
- Flame integration

### Running Tests

#### Option 1: Use the test runner script (recommended)
```bash
./run_tests.sh
```

This script provides:
- Automatic dependency installation
- Individual test suite execution
- Detailed progress reporting
- Test coverage summary
- Success/failure statistics

#### Option 2: Run all tests at once
```bash
flutter test
```

#### Option 3: Run specific test files
```bash
flutter test test/lumberjack_test.dart
flutter test test/dungeon_test.dart
```

#### Option 4: Run tests with coverage
```bash
flutter test --coverage
```

### Running the Game

#### Desktop/Mobile
```bash
flutter run
```

#### Terminal Mode
```bash
dart run bin/main.dart
```

## 📊 Test Results

When all tests pass, you'll see:

```
╔════════════════════════════════════════════════════════════════════╗
║                    🎉 ALL TESTS PASSED! 🎉                         ║
║           All game mechanics are working correctly!                ║
╚════════════════════════════════════════════════════════════════════╝

Total Test Suites: 11
Passed: 11
Failed: 0
Success Rate: 100%
```

## 📚 Documentation

### New Documentation Files

1. **TEST_DOCUMENTATION.md**
   - Detailed test descriptions
   - Coverage information
   - Adding new tests guide
   - Troubleshooting

2. **FLAME_UPDATE_GUIDE.md**
   - Update details
   - Compatibility notes
   - Migration path
   - Rollback instructions

3. **ARCHITECTURE.md** (existing)
   - System design
   - Code organization
   - Extension points

### Validation Scripts

1. **validate.sh**
   - Structure validation
   - Dependency checks
   - Test suite verification
   - Code validation

2. **run_tests.sh**
   - Comprehensive test execution
   - Progress tracking
   - Result summaries

## 🎯 What Was Tested

### Gameplay Mechanics
- ✅ Player movement and exploration
- ✅ Resource gathering (wood, metal)
- ✅ Monster combat and XP gain
- ✅ Weapon crafting and upgrades
- ✅ Building construction
- ✅ Town resource management
- ✅ Dungeon exploration (20 levels)
- ✅ Time system and day/night cycle

### Game Balance
- ✅ XP requirements for leveling
- ✅ Resource durability scaling
- ✅ Monster difficulty progression
- ✅ Weapon damage progression
- ✅ Building production rates
- ✅ Time costs for actions

### Edge Cases
- ✅ Health boundaries (0 to max)
- ✅ Resource depletion
- ✅ Inventory accumulation
- ✅ Multiple resource types
- ✅ Monster death state
- ✅ Map boundaries
- ✅ Water tile blocking

## 🔧 Development

### Project Structure
```
LumberjackRPG/
├── lib/                    # Source code
│   ├── main.dart          # Flutter entry point
│   ├── lumberjack_rpg.dart # Flame game engine
│   ├── game_state.dart    # Game state manager
│   ├── lumberjack.dart    # Player character
│   ├── monster.dart       # Monster entities
│   ├── game_map.dart      # World generation
│   ├── building.dart      # Building system
│   ├── town.dart          # Town management
│   ├── dungeon.dart       # Dungeon system
│   ├── crafting_system.dart # Crafting
│   ├── wood.dart          # Wood resources
│   ├── metal.dart         # Metal resources
│   ├── axe.dart           # Weapons
│   └── constants.dart     # Game constants
├── test/                  # Test suite
│   ├── lumberjack_test.dart
│   ├── wood_test.dart
│   ├── metal_test.dart
│   ├── monster_test.dart
│   ├── axe_test.dart
│   ├── game_map_test.dart
│   ├── crafting_system_test.dart
│   ├── building_test.dart
│   ├── town_test.dart
│   ├── dungeon_test.dart
│   └── game_state_test.dart
├── bin/                   # Terminal version
│   └── main.dart
├── docs/                  # Documentation
├── run_tests.sh          # Test runner
├── validate.sh           # Validation script
├── TEST_DOCUMENTATION.md
├── FLAME_UPDATE_GUIDE.md
└── ARCHITECTURE.md
```

### Adding New Features

1. Implement feature in `lib/`
2. Write tests in `test/`
3. Run `./validate.sh` to check structure
4. Run `./run_tests.sh` to verify functionality
5. Update documentation

### Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new features
4. Ensure all tests pass
5. Submit a pull request

## 🐛 Troubleshooting

### Tests Won't Run
```bash
# Clean and reinstall dependencies
flutter clean
flutter pub get
```

### Validation Fails
```bash
# Check detailed output
./validate.sh

# Verify Flutter installation
flutter doctor
```

### Import Errors
```bash
# Ensure package name matches pubspec.yaml
# Check all imports use: package:lumberjack_rpg/...
```

## 📈 Performance

The Flame 1.17.0 update includes:
- Faster rendering pipeline
- Improved memory management
- Better component pooling
- Optimized collision detection

## 🎮 Game Features

### Current Features
- 2D top-down RPG
- Procedural map generation
- Resource gathering system
- Combat with level scaling
- Crafting system
- Building construction
- Town management
- 20-level dungeon
- Day/night cycle
- Multiple game modes

### Platform Support
- ✅ Desktop (Windows, macOS, Linux)
- ✅ Mobile (iOS, Android)
- ✅ Web
- ✅ Terminal (command-line)

## 📝 License

Same license as the main LumberjackRPG project.

## 🙏 Acknowledgments

- Flame Engine team for the excellent game framework
- Flutter team for the amazing SDK
- All contributors to the project

---

**Ready to play?** Run `flutter run`

**Want to test?** Run `./run_tests.sh`

**Need validation?** Run `./validate.sh`

**Have fun! 🎮🪓**
