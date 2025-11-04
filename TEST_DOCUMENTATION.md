# LumberjackRPG Test Suite Documentation

## Overview

This comprehensive test suite validates all major game mechanics in the LumberjackRPG game. The tests cover core gameplay, resource management, combat systems, building mechanics, and more.

## Test Structure

### Core Mechanics Tests

#### 1. **lumberjack_test.dart** - Player Character Mechanics
Tests the fundamental player character functionality:
- Character initialization with default values
- Wood chopping and experience gain
- Metal mining and experience gain
- Level up mechanics and stat increases
- Combat mechanics and damage handling
- Health management (damage, healing, min/max bounds)
- Inventory management for resources
- XP rewards from defeating monsters

**Key Validations:**
- Player starts at level 1 with 100 HP
- Gathering resources grants appropriate XP
- Leveling up increases max health and fully heals
- Combat damage is correctly calculated
- Inventory properly tracks multiple resource types

#### 2. **wood_test.dart** - Wood Resource System
Tests the wood gathering mechanics:
- Wood resource initialization
- Durability system for resources
- Depletion mechanics
- Different wood types and their properties
- Biome-specific wood associations

**Key Validations:**
- All wood types from constants are valid
- Durability decreases with each chop
- Resources become depleted when durability reaches 0
- Rare woods (deep cave) are harder to chop
- Wood types have correct biome associations

#### 3. **metal_test.dart** - Metal Resource System
Tests the metal mining mechanics:
- Metal resource initialization
- Durability system for ores
- Depletion mechanics
- Different metal types and rarity
- Biome-specific metal associations

**Key Validations:**
- All metal types from constants are valid
- Mining reduces durability correctly
- Rare metals (osmium, iridium) require more mining
- Metal types match their biomes
- Resources cannot go below zero durability

#### 4. **monster_test.dart** - Monster & Combat System
Tests monster behavior and combat:
- Monster initialization with level-based stats
- Scaling of health and damage by level
- Taking damage and death mechanics
- Healing mechanics
- Position tracking
- Monster information display

**Key Validations:**
- Stats scale correctly: health = 50 + (level * 10), damage = 5 + (level * 2)
- Higher level monsters are stronger
- Health cannot go below 0 or above max
- Monsters die when health reaches 0
- Dead monsters stay dead

#### 5. **axe_test.dart** - Weapon System
Tests the weapon/axe mechanics:
- Different axe types (stone, iron, steel, titanium, osmium)
- Damage progression with better materials
- Weapon tier system

**Key Validations:**
- All axe types exist
- Better materials deal more damage
- Damage progression: stone < iron < steel < titanium < osmium
- Osmium axe is the most powerful

#### 6. **game_map_test.dart** - Map Generation
Tests world map generation:
- Map size and dimensions
- Biome diversity (forest, mountain, cave, deep cave, water, road)
- Resource placement
- Road generation
- Spawn point location

**Key Validations:**
- Maps generate with correct dimensions
- Multiple biome types exist
- Resources don't spawn on water or roads
- Resources match their biome types
- Roads connect key locations
- Different map sizes work correctly

### Game System Tests

#### 7. **crafting_system_test.dart** - Crafting System
Tests item crafting mechanics:
- Resource requirements for crafting
- Crafting validation (sufficient resources)
- Resource consumption during crafting
- Axe upgrades through crafting

**Key Validations:**
- Cannot craft without resources
- Crafting consumes correct amounts
- Player receives crafted item
- Different tiers require different resources

#### 8. **building_test.dart** - Building System
Tests the building construction and production:
- All 6 building types (sawmill, water wheel, inn, blacksmith, workshop, storehouse)
- Building initialization
- Resource production mechanics
- Level/upgrade system
- Operational state management

**Key Validations:**
- All building types initialize correctly
- Buildings produce resources each turn
- Production scales with building level
- Inactive buildings don't produce
- Production tracking works correctly

#### 9. **town_test.dart** - Town Management
Tests town mechanics:
- Town initialization
- Resource storage and accumulation
- Building construction requirements
- Resource deduction for construction
- Production from multiple buildings
- Resource transfer mechanics

**Key Validations:**
- Cannot build without sufficient resources
- Construction consumes correct resources
- Buildings added to town properly
- Multiple buildings produce independently
- Production accumulates over time

#### 10. **dungeon_test.dart** - Dungeon System
Tests the dungeon exploration mechanics:
- 20-level dungeon system
- Monster spawning per level
- Treasure generation
- Level progression (difficulty scaling)
- Level clearing mechanics
- Descent/ascent mechanics

**Key Validations:**
- All 20 levels generate correctly
- Deeper levels have stronger monsters
- Deeper levels have better treasure
- Cannot descend until level is cleared
- Treasure collection works properly

#### 11. **game_state_test.dart** - Game State Integration
Tests the complete game state system:
- Game initialization
- Time system (day/night cycle, turns)
- Mode transitions (exploration, town, dungeon)
- Action time costs (moving, gathering, combat)
- Town entry/exit
- Inventory transfers
- Rest and recovery
- Building construction timing

**Key Validations:**
- Game starts in correct state
- Time advances with all actions
- Mode transitions work correctly
- Day/night cycle functions properly
- Player cannot move into water
- All game systems integrate properly

## Running the Tests

### Using the Test Script

The easiest way to run all tests is using the provided shell script:

```bash
./run_tests.sh
```

This script will:
1. Check for Flutter/Dart installation
2. Install dependencies
3. Run all test suites individually
4. Run complete test suite
5. Display comprehensive results
6. Show test coverage summary

### Manual Test Execution

#### Run all tests:
```bash
flutter test
# or
dart test
```

#### Run a specific test file:
```bash
flutter test test/lumberjack_test.dart
# or
dart test test/lumberjack_test.dart
```

#### Run tests with verbose output:
```bash
flutter test --reporter expanded
```

#### Run tests with coverage:
```bash
flutter test --coverage
```

## Test Coverage

The test suite covers:

- ✅ **Player Mechanics**: Movement, combat, leveling, inventory
- ✅ **Resource Systems**: Wood chopping, metal mining, resource properties
- ✅ **Combat System**: Monster stats, damage calculation, death mechanics
- ✅ **Weapon System**: Crafting, upgrades, damage progression
- ✅ **Map Generation**: Biomes, resources, roads, spawn points
- ✅ **Crafting System**: Requirements, validation, consumption
- ✅ **Building System**: Construction, production, upgrades
- ✅ **Town Management**: Resources, buildings, production cycles
- ✅ **Dungeon System**: 20 levels, monsters, treasures, progression
- ✅ **Time System**: Day/night, turns, action timing
- ✅ **Game State**: Mode transitions, integration, persistence

## Expected Test Results

When all tests pass, you should see:
- **Total Test Suites**: 11
- **Individual Test Cases**: 100+
- **Success Rate**: 100%

Each test file contains multiple test cases:
- lumberjack_test.dart: 13 tests
- wood_test.dart: 7 tests
- metal_test.dart: 8 tests
- monster_test.dart: 12 tests
- axe_test.dart: 7 tests
- game_map_test.dart: 12 tests
- crafting_system_test.dart: 8 tests
- building_test.dart: 15 tests
- town_test.dart: 16 tests
- dungeon_test.dart: 15 tests
- game_state_test.dart: 20+ tests

## Adding New Tests

To add new tests:

1. Create a new test file in the `test/` directory
2. Follow the naming convention: `feature_test.dart`
3. Import required packages:
   ```dart
   import 'package:flutter_test/flutter_test.dart';
   import 'package:lumberjack_rpg/your_module.dart';
   ```
4. Structure tests with `group()` and `test()`:
   ```dart
   void main() {
     group('Feature Name', () {
       test('should do something', () {
         // Test code
         expect(actual, expected);
       });
     });
   }
   ```
5. Update `run_tests.sh` to include the new test file

## Troubleshooting

### Tests Fail to Run
- Ensure Flutter/Dart SDK is installed
- Run `flutter pub get` or `dart pub get`
- Check that all dependencies are up to date

### Specific Test Failures
- Read the error message carefully
- Check if game logic has changed
- Verify resource constants are correct
- Ensure test expectations match implementation

### Import Errors
- Verify package name in `pubspec.yaml`
- Ensure all source files are in `lib/` directory
- Check import paths in test files

## Continuous Integration

These tests are designed to run in CI/CD pipelines. The `run_tests.sh` script returns:
- **Exit code 0**: All tests passed
- **Exit code 1**: Some tests failed

## Game Mechanics Validation

These tests validate the following game balance:

### Experience & Leveling
- Wood chopping: 10 XP per resource
- Metal mining: 15 XP per resource
- Monster defeat: level * 20 XP
- Level up requirement: level * 100 XP

### Resource Durability
- Balsa (easiest): 3 durability
- Snakewood (hardest): 15 durability
- Iron (basic metal): 5 durability
- Osmium (rare metal): 12 durability

### Combat Stats
- Player base: 100 HP, +10 per level
- Monster base: 50 + (level * 10) HP
- Monster damage: 5 + (level * 2)
- Axe damage: 10 (stone) to 50 (osmium)

### Time Costs
- Moving: 10 minutes
- Chopping wood: 30 minutes
- Mining metal: 45 minutes
- Combat: 15 minutes per attack
- Building: 120 minutes
- Resting: 60 minutes

## Contributing

When adding new game features, please:
1. Write tests first (TDD approach)
2. Ensure existing tests still pass
3. Add documentation for new tests
4. Update this README with new coverage

## License

Same license as the main LumberjackRPG project.
