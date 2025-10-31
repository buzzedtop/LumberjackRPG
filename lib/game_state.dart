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

class GameState {
  late Lumberjack player;
  late GameMap gameMap;
  late Town town;
  late Dungeon dungeon;
  final List<Monster> monsters = [];
  Vector2 playerPosition = Vector2(50, 50);
  GameMode currentMode = GameMode.exploration;
  int turnCount = 0;
  
  GameState({int mapSize = 42, int? seed}) {
    player = Lumberjack();
    gameMap = GameMap(mapSize, mapSize);
    
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

  void advanceTurn() {
    turnCount++;
    
    // Produce resources in town
    if (currentMode == GameMode.town || currentMode == GameMode.exploration) {
      town.produceResources();
    }
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
    buffer.writeln('Turn: $turnCount');
    buffer.writeln('Mode: ${currentMode.toString().split('.').last}');
    buffer.writeln('Position: (${(playerPosition.x / 32).floor()}, ${(playerPosition.y / 32).floor()})');
    buffer.writeln('');
    buffer.writeln('Player Status:');
    buffer.writeln('  Level: ${player.level}');
    buffer.writeln('  Health: ${player.health}/${player.maxHealth}');
    buffer.writeln('  XP: ${player.experience}/${player.level * 100}');
    buffer.writeln('  Axe: ${player.axe.type.toString().split('.').last} (Damage: ${player.axe.damage})');
    
    return buffer.toString();
  }
}
