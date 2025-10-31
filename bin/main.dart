import 'dart:io';
import 'package:vector_math/vector_math.dart';
import '../lib/game_state.dart';
import '../lib/building.dart';
import '../lib/wood.dart';
import '../lib/metal.dart';
import '../lib/monster.dart';
import '../lib/game_map.dart';

void main() {
  print('╔════════════════════════════════════════════════════════════════════╗');
  print('║         Welcome to LumberjackRPG - Terminal Edition!               ║');
  print('╚════════════════════════════════════════════════════════════════════╝');
  print('');
  print('A medieval lumberjack adventure with building mechanics and dungeons!');
  print('');
  
  final game = GameState(mapSize: 42);
  
  print('Initializing world...');
  print('✓ Map generated (${game.gameMap.width}x${game.gameMap.height})');
  print('✓ Town created: ${game.town.name}');
  print('✓ Dungeon entrance: Well in town center');
  print('');
  
  bool running = true;
  
  while (running) {
    displayGameState(game);
    
    switch (game.currentMode) {
      case GameMode.exploration:
        running = explorationMode(game);
        break;
      case GameMode.town:
        running = townMode(game);
        break;
      case GameMode.dungeon:
        running = dungeonMode(game);
        break;
    }
    
    game.advanceTurn();
  }
  
  print('\nThanks for playing LumberjackRPG!');
  print('Final Statistics:');
  print('  Turns played: ${game.turnCount}');
  print('  Player Level: ${game.player.level}');
  print('  Buildings constructed: ${game.town.buildings.length}');
}

void displayGameState(GameState game) {
  print('\n' + '═' * 70);
  print(game.getSummary());
  
  if (game.isInTown() && game.currentMode == GameMode.exploration) {
    print('>>> You are near ${game.town.name}! <<<');
  }
}

bool explorationMode(GameState game) {
  print('\n--- EXPLORATION MODE ---');
  print('Actions:');
  print('  [m] Move');
  print('  [c] Chop wood');
  print('  [n] Mine metal');
  print('  [a] Attack monster');
  print('  [t] Enter town (if nearby)');
  print('  [i] Show inventory');
  print('  [s] Show map info');
  print('  [q] Quit game');
  
  stdout.write('\nChoose action: ');
  final input = stdin.readLineSync()?.toLowerCase().trim() ?? '';
  
  switch (input) {
    case 'm':
      movePlayer(game);
      break;
    case 'c':
      chopWood(game);
      break;
    case 'n':
      mineMetal(game);
      break;
    case 'a':
      attackMonster(game);
      break;
    case 't':
      if (game.isInTown()) {
        game.enterTown();
        print('\n>>> Entering ${game.town.name}... <<<');
      } else {
        print('\nYou are not near the town!');
      }
      break;
    case 'i':
      showInventory(game);
      break;
    case 's':
      showMapInfo(game);
      break;
    case 'q':
      return false;
    default:
      print('\nInvalid action!');
  }
  
  return true;
}

bool townMode(GameState game) {
  print('\n--- TOWN: ${game.town.name.toUpperCase()} ---');
  print(game.town.getInfo());
  
  print('\nActions:');
  print('  [b] Build structure');
  print('  [v] View buildings');
  print('  [d] Deposit inventory to town');
  print('  [w] Enter well (dungeon entrance)');
  print('  [e] Exit town');
  print('  [q] Quit game');
  
  stdout.write('\nChoose action: ');
  final input = stdin.readLineSync()?.toLowerCase().trim() ?? '';
  
  switch (input) {
    case 'b':
      buildStructure(game);
      break;
    case 'v':
      viewBuildings(game);
      break;
    case 'd':
      game.transferInventoryToTown();
      print('\n✓ Inventory deposited to town storage!');
      break;
    case 'w':
      if (game.town.wellHasDungeon) {
        game.enterDungeon();
        print('\n>>> Descending into the ancient well... <<<');
      } else {
        print('\nThe well is just a normal well.');
      }
      break;
    case 'e':
      game.exitTown();
      print('\n>>> Leaving town... <<<');
      break;
    case 'q':
      return false;
    default:
      print('\nInvalid action!');
  }
  
  return true;
}

bool dungeonMode(GameState game) {
  print('\n--- DUNGEON MODE ---');
  print(game.dungeon.getInfo());
  
  print('\nActions:');
  print('  [f] Fight monster');
  print('  [t] Collect treasure');
  print('  [d] Descend deeper');
  print('  [u] Ascend/Exit');
  print('  [q] Quit game');
  
  stdout.write('\nChoose action: ');
  final input = stdin.readLineSync()?.toLowerCase().trim() ?? '';
  
  switch (input) {
    case 'f':
      fightDungeonMonster(game);
      break;
    case 't':
      collectTreasure(game);
      break;
    case 'd':
      if (game.dungeon.canDescend()) {
        game.dungeon.descend();
        print('\n>>> Descending deeper into the dungeon... <<<');
      } else {
        print('\nYou must defeat all monsters first!');
      }
      break;
    case 'u':
      if (game.dungeon.currentLevel == DungeonLevel.entrance) {
        game.exitDungeon();
        print('\n>>> Climbing out of the well... <<<');
      } else {
        game.dungeon.ascend();
        print('\n>>> Ascending to previous level... <<<');
      }
      break;
    case 'q':
      return false;
    default:
      print('\nInvalid action!');
  }
  
  return true;
}

void movePlayer(GameState game) {
  print('\nMove direction: [w]up [s]down [a]left [d]right');
  stdout.write('Direction: ');
  final dir = stdin.readLineSync()?.toLowerCase().trim() ?? '';
  
  Vector2? newPos;
  switch (dir) {
    case 'w':
      newPos = Vector2(game.playerPosition.x, game.playerPosition.y - 32);
      break;
    case 's':
      newPos = Vector2(game.playerPosition.x, game.playerPosition.y + 32);
      break;
    case 'a':
      newPos = Vector2(game.playerPosition.x - 32, game.playerPosition.y);
      break;
    case 'd':
      newPos = Vector2(game.playerPosition.x + 32, game.playerPosition.y);
      break;
    default:
      print('Invalid direction!');
      return;
  }
  
  final targetTile = (newPos / 32).floor();
  if (targetTile.x >= 0 && targetTile.x < game.gameMap.width &&
      targetTile.y >= 0 && targetTile.y < game.gameMap.height &&
      game.gameMap.tiles[targetTile.x.toInt()][targetTile.y.toInt()] != TileType.water) {
    game.playerPosition = newPos;
    print('✓ Moved to (${targetTile.x.toInt()}, ${targetTile.y.toInt()})');
    
    final tileType = game.gameMap.tiles[targetTile.x.toInt()][targetTile.y.toInt()];
    print('  Terrain: ${tileType.toString().split('.').last}');
  } else {
    print('Cannot move there (water or out of bounds)!');
  }
}

void chopWood(GameState game) {
  final playerTile = (game.playerPosition / 32).floor();
  final wood = game.gameMap.woodResources[Vector2(playerTile.x, playerTile.y)];
  
  if (wood != null) {
    game.player.chopWood(wood);
    print('\n✓ Chopped ${wood.name}!');
    print('  Gained: ${wood.amount} wood');
    print('  Durability: ${wood.durability}/${wood.maxDurability}');
    
    if (wood.isDepleted) {
      game.gameMap.woodResources.remove(Vector2(playerTile.x, playerTile.y));
      print('  Resource depleted!');
    }
  } else {
    print('\nNo wood resource at this location!');
  }
}

void mineMetal(GameState game) {
  final playerTile = (game.playerPosition / 32).floor();
  final metal = game.gameMap.metalResources[Vector2(playerTile.x, playerTile.y)];
  
  if (metal != null) {
    game.player.mineMetal(metal);
    print('\n✓ Mined ${metal.name}!');
    print('  Gained: ${metal.amount} metal');
    print('  Durability: ${metal.durability}/${metal.maxDurability}');
    
    if (metal.isDepleted) {
      game.gameMap.metalResources.remove(Vector2(playerTile.x, playerTile.y));
      print('  Resource depleted!');
    }
  } else {
    print('\nNo metal resource at this location!');
  }
}

void attackMonster(GameState game) {
  print('\nNo monsters nearby in exploration mode.');
  print('(Monster encounters in dungeons!)');
}

void showInventory(GameState game) {
  print('\n--- PLAYER INVENTORY ---');
  print('Wood:');
  if (game.player.woodInventory.isEmpty) {
    print('  (empty)');
  } else {
    game.player.woodInventory.forEach((type, amount) {
      print('  $type: $amount');
    });
  }
  
  print('\nMetal:');
  if (game.player.metalInventory.isEmpty) {
    print('  (empty)');
  } else {
    game.player.metalInventory.forEach((type, amount) {
      print('  $type: $amount');
    });
  }
}

void showMapInfo(GameState game) {
  final playerTile = (game.playerPosition / 32).floor();
  print('\n--- MAP INFO ---');
  print('Current tile: (${playerTile.x.toInt()}, ${playerTile.y.toInt()})');
  
  final tileType = game.gameMap.tiles[playerTile.x.toInt()][playerTile.y.toInt()];
  print('Terrain: ${tileType.toString().split('.').last}');
  
  final wood = game.gameMap.woodResources[Vector2(playerTile.x, playerTile.y)];
  if (wood != null) {
    print('Wood: ${wood.name} (${wood.durability}/${wood.maxDurability})');
  }
  
  final metal = game.gameMap.metalResources[Vector2(playerTile.x, playerTile.y)];
  if (metal != null) {
    print('Metal: ${metal.name} (${metal.durability}/${metal.maxDurability})');
  }
}

void buildStructure(GameState game) {
  print('\n--- BUILD STRUCTURE ---');
  print('Available buildings:');
  print('  [1] Sawmill - Produces planks from wood');
  print('  [2] Water Wheel - Generates power');
  print('  [3] Inn - Generates gold from visitors');
  print('  [4] Blacksmith - Produces tools');
  print('  [5] Workshop - Produces goods');
  print('  [6] Storehouse - Increases storage capacity');
  print('  [0] Cancel');
  
  stdout.write('\nChoose building: ');
  final choice = stdin.readLineSync()?.trim() ?? '';
  
  BuildingType? type;
  String? name;
  
  switch (choice) {
    case '1':
      type = BuildingType.sawmill;
      name = 'sawmill';
      break;
    case '2':
      type = BuildingType.waterWheel;
      name = 'waterwheel';
      break;
    case '3':
      type = BuildingType.inn;
      name = 'inn';
      break;
    case '4':
      type = BuildingType.blacksmith;
      name = 'blacksmith';
      break;
    case '5':
      type = BuildingType.workshop;
      name = 'workshop';
      break;
    case '6':
      type = BuildingType.storehouse;
      name = 'storehouse';
      break;
    case '0':
      return;
    default:
      print('Invalid choice!');
      return;
  }
  
  // Generate unique building ID
  final buildingId = '$name-${game.town.buildings.length + 1}';
  
  if (game.constructBuilding(buildingId, type)) {
    print('\n✓ ${name} constructed successfully!');
    print('  Building ID: $buildingId');
  } else {
    print('\n✗ Not enough resources to build ${name}!');
    
    // Show requirements
    final building = _getBuilding(type);
    print('\nRequired resources:');
    building.constructionCost.forEach((resource, amount) {
      final available = game.town.resources[resource] ?? 0;
      print('  $resource: $available/$amount');
    });
  }
}

void viewBuildings(GameState game) {
  print('\n--- TOWN BUILDINGS ---');
  if (game.town.buildings.isEmpty) {
    print('No buildings constructed yet.');
  } else {
    game.town.buildings.forEach((id, building) {
      print('\n[$id]');
      print(building.getInfo());
    });
  }
}

void fightDungeonMonster(GameState game) {
  final monsters = game.dungeon.getCurrentMonsters();
  final aliveMonsters = monsters.where((m) => !m.isDead).toList();
  
  if (aliveMonsters.isEmpty) {
    print('\nNo monsters to fight!');
    return;
  }
  
  print('\n--- CHOOSE TARGET ---');
  for (var i = 0; i < aliveMonsters.length; i++) {
    final monster = aliveMonsters[i];
    print('${i + 1}. ${monster.name} (Level ${monster.level}) - HP: ${monster.health}/${monster.maxHealth}');
  }
  
  stdout.write('\nTarget (1-${aliveMonsters.length}): ');
  final choice = int.tryParse(stdin.readLineSync()?.trim() ?? '');
  
  if (choice == null || choice < 1 || choice > aliveMonsters.length) {
    print('Invalid target!');
    return;
  }
  
  final target = aliveMonsters[choice - 1];
  print('\n>>> Attacking ${target.name}! <<<');
  
  game.player.attack(target);
  print('Dealt ${game.player.axe.damage} damage!');
  print('${target.name} HP: ${target.health}/${target.maxHealth}');
  
  if (target.isDead) {
    print('\n✓ ${target.name} defeated!');
    print('  Gained ${target.level * 20} XP!');
  } else {
    // Monster counter-attacks
    final damage = target.damage;
    game.player.health -= damage;
    print('\n${target.name} counter-attacks for $damage damage!');
    print('Your HP: ${game.player.health}/${game.player.maxHealth}');
    
    if (game.player.health <= 0) {
      print('\n╔════════════════════════════════════════════════════════════════════╗');
      print('║                        GAME OVER                                   ║');
      print('╚════════════════════════════════════════════════════════════════════╝');
      print('You were defeated by ${target.name}!');
      exit(0);
    }
  }
}

void collectTreasure(GameState game) {
  final treasure = game.dungeon.collectTreasure();
  
  if (treasure == null) {
    print('\nNo treasure to collect! (Defeat all monsters first)');
    return;
  }
  
  if (treasure.isEmpty) {
    print('\nThe treasure chest is empty (already collected).');
    return;
  }
  
  print('\n✓ Treasure collected!');
  treasure.forEach((item, amount) {
    game.town.addResource(item, amount);
    print('  $item: $amount');
  });
}

Building _getBuilding(BuildingType type) {
  switch (type) {
    case BuildingType.sawmill:
      return Building.createSawmill();
    case BuildingType.waterWheel:
      return Building.createWaterWheel();
    case BuildingType.inn:
      return Building.createInn();
    case BuildingType.blacksmith:
      return Building.createBlacksmith();
    case BuildingType.workshop:
      return Building.createWorkshop();
    case BuildingType.storehouse:
      return Building.createStorehouse();
  }
}
