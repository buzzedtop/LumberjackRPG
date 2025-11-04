import 'package:vector_math/vector_math.dart';
import 'lumberjack.dart';
import 'game_map.dart';
import 'monster.dart';
import 'town.dart';
import 'dungeon.dart';
import 'building.dart';
import 'wood.dart';
import 'metal.dart';

enum GameMode { exploration, town, dungeon }

class GameTime {
  int day = 1;
  int hour = 8; // Start at 8 AM
  int minute = 0;
  int totalMinutes = 0; // Total game time in minutes
  
  void advanceTime(int minutes) {
    minute += minutes;
    totalMinutes += minutes;
    
    while (minute >= 60) {
      minute -= 60;
      hour++;
    }
    
    while (hour >= 24) {
      hour -= 24;
      day++;
    }
  }
  
  String getTimeString() {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return 'Day $day, $displayHour:${minute.toString().padLeft(2, '0')} $period';
  }
  
  String getTimeOfDay() {
    if (hour >= 5 && hour < 12) return 'Morning';
    if (hour >= 12 && hour < 17) return 'Afternoon';
    if (hour >= 17 && hour < 21) return 'Evening';
    return 'Night';
  }
  
  bool isNight() => hour < 6 || hour >= 22;
  bool isDaytime() => !isNight();
}

class GameState {
  late Lumberjack player;
  late GameMap gameMap;
  late Town town;
  late Dungeon dungeon;
  final List<Monster> monsters = [];
  Vector2 playerPosition = Vector2(50, 50);
  GameMode currentMode = GameMode.exploration;
  int turnCount = 0;
  late GameTime gameTime;
  
  GameState({int mapSize = 42, int? seed}) {
    player = Lumberjack();
    gameMap = GameMap(mapSize, mapSize);
    gameTime = GameTime();
    
    // Create town at the center of the map
    final townPos = Vector2((mapSize / 2).floorToDouble(), (mapSize / 2).floorToDouble());
    town = Town(
      name: 'Ironwood Village',
      position: townPos,
      hasWell: true,
      wellHasDungeon: true,
    );
    
    // Initialize town with starting resources
    town.addResource('wood', 100);
    town.addResource('gold', 50);
    
    // Create dungeon entrance at the well
    dungeon = Dungeon(
      name: 'The Ancient Well Dungeon',
      entrancePosition: townPos,
    );
  }

  // Advance turn - called after EVERY player action
  void advanceTurn({int timeMinutes = 10}) {
    turnCount++;
    gameTime.advanceTime(timeMinutes);
    
    // Check if a new day started
    final wasNight = gameTime.hour >= 22 || gameTime.hour < 6;
    
    // Produce resources in town every hour (6 game hours = 1 production cycle)
    if (gameTime.totalMinutes % 360 == 0) {
      town.produceResources();
    }
    
    // Night time: increased monster danger (could spawn more monsters)
    if (gameTime.isNight() && currentMode == GameMode.exploration) {
      // Night-time effects (monsters more dangerous, etc.)
      // This is a placeholder for future enhancement
    }
    
    // Day transitions
    if (gameTime.hour == 0 && gameTime.minute < timeMinutes) {
      // New day started - could trigger special events
      _onNewDay();
    }
  }
  
  void _onNewDay() {
    // New day effects
    // Buildings produce accumulated resources
    town.produceResources();
    
    // Player could get a small health regeneration
    if (currentMode == GameMode.town) {
      player.health = (player.health + 10).clamp(0, player.maxHealth);
    }
  }
  
  // Move action - costs 10 minutes
  void movePlayer(int dx, int dy) {
    final newPos = Vector2(
      playerPosition.x + (dx * 32),
      playerPosition.y + (dy * 32),
    );
    
    final targetTile = (newPos / 32).floor();
    if (targetTile.x >= 0 && targetTile.x < gameMap.width &&
        targetTile.y >= 0 && targetTile.y < gameMap.height &&
        gameMap.tiles[targetTile.x.toInt()][targetTile.y.toInt()] != TileType.water) {
      playerPosition = newPos;
      advanceTurn(timeMinutes: 10); // Moving takes 10 minutes
    }
  }
  
  // Chop wood - costs 30 minutes
  void chopWood() {
    final playerTile = (playerPosition / 32).floor();
    final wood = gameMap.woodResources[Vector2(playerTile.x, playerTile.y)];
    
    if (wood != null && !wood.isDepleted) {
      player.chopWood(wood);
      advanceTurn(timeMinutes: 30); // Chopping takes 30 minutes
      
      if (wood.isDepleted) {
        gameMap.woodResources.remove(Vector2(playerTile.x, playerTile.y));
      }
    }
  }
  
  // Mine metal - costs 45 minutes
  void mineMetal() {
    final playerTile = (playerPosition / 32).floor();
    final metal = gameMap.metalResources[Vector2(playerTile.x, playerTile.y)];
    
    if (metal != null && !metal.isDepleted) {
      player.mineMetal(metal);
      advanceTurn(timeMinutes: 45); // Mining takes 45 minutes
      
      if (metal.isDepleted) {
        gameMap.metalResources.remove(Vector2(playerTile.x, playerTile.y));
      }
    }
  }
  
  // Combat action - costs 15 minutes per attack
  void attackMonster(Monster monster) {
    if (!monster.isDead) {
      player.attack(monster);
      advanceTurn(timeMinutes: 15); // Combat takes 15 minutes
    }
  }
  
  // Building construction - costs 2 hours (120 minutes)
  bool constructBuildingWithTime(String buildingId, BuildingType type) {
    final success = constructBuilding(buildingId, type);
    if (success) {
      advanceTurn(timeMinutes: 120); // Building takes 2 hours
    }
    return success;
  }
  
  // Resting - costs 1 hour, restores health
  void rest() {
    final healAmount = (player.maxHealth * 0.25).round();
    player.health = (player.health + healAmount).clamp(0, player.maxHealth);
    advanceTurn(timeMinutes: 60); // Resting takes 1 hour
  }

  bool isInTown() {
    final townX = town.position.x.toInt();
    final townY = town.position.y.toInt();
    final playerX = (playerPosition.x / 32).floor();
    final playerY = (playerPosition.y / 32).floor();
    
    // Town is a 3x3 area
    return (playerX - townX).abs() <= 1 && (playerY - townY).abs() <= 1;
  }

  void enterTown() {
    currentMode = GameMode.town;
  }

  void exitTown() {
    currentMode = GameMode.exploration;
  }

  void enterDungeon() {
    if (isInTown()) {
      currentMode = GameMode.dungeon;
    }
  }

  void exitDungeon() {
    dungeon.currentLevel = DungeonLevel.entrance;
    currentMode = GameMode.town;
  }

  void transferInventoryToTown() {
    // Transfer player's resources to town
    player.woodInventory.forEach((wood, amount) {
      town.addResource(wood, amount);
    });
    player.metalInventory.forEach((metal, amount) {
      town.addResource(metal, amount);
    });
    
    player.woodInventory.clear();
    player.metalInventory.clear();
  }

  bool constructBuilding(String buildingId, BuildingType type) {
    Building? building;
    
    switch (type) {
      case BuildingType.sawmill:
        building = Building.createSawmill();
        break;
      case BuildingType.waterWheel:
        building = Building.createWaterWheel();
        break;
      case BuildingType.inn:
        building = Building.createInn();
        break;
      case BuildingType.blacksmith:
        building = Building.createBlacksmith();
        break;
      case BuildingType.workshop:
        building = Building.createWorkshop();
        break;
      case BuildingType.storehouse:
        building = Building.createStorehouse();
        break;
    }
    
    return town.constructBuilding(buildingId, building);
  }

  String getSummary() {
    final buffer = StringBuffer();
    buffer.writeln('╔════════════════════════════════════════════════════════════════════╗');
    buffer.writeln('║              LUMBERJACK RPG - Terminal Edition                     ║');
    buffer.writeln('╚════════════════════════════════════════════════════════════════════╝');
    buffer.writeln('');
    buffer.writeln('Time: ${gameTime.getTimeString()} (${gameTime.getTimeOfDay()})');
    buffer.writeln('Turn: $turnCount');
    buffer.writeln('Mode: ${currentMode.toString().split('.').last}');
    buffer.writeln('Position: (${(playerPosition.x / 32).floor()}, ${(playerPosition.y / 32).floor()})');
    buffer.writeln('');
    buffer.writeln('Player Status:');
    buffer.writeln('  Level: ${player.level}');
    buffer.writeln('  Health: ${player.health}/${player.maxHealth}');
    buffer.writeln('  XP: ${player.experience}/${player.level * 100}');
    buffer.writeln('  Axe: ${player.axe.type.toString().split('.').last} (Damage: ${player.axe.damage})');
    
    // Add time-based warnings
    if (gameTime.isNight()) {
      buffer.writeln('');
      buffer.writeln('⚠️  It is night! Monsters are more dangerous.');
    }
    
    return buffer.toString();
  }
}
