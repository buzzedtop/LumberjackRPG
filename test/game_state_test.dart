import 'package:flutter_test/flutter_test.dart';
import 'package:lumberjack_rpg/game_state.dart';
import 'package:lumberjack_rpg/game_map.dart';
import 'package:lumberjack_rpg/building.dart';
import 'package:lumberjack_rpg/monster.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  group('Game State Integration Tests', () {
    late GameState gameState;

    setUp(() {
      gameState = GameState(mapSize: 42);
    });

    test('Game state initializes correctly', () {
      expect(gameState.player, isNotNull);
      expect(gameState.gameMap, isNotNull);
      expect(gameState.town, isNotNull);
      expect(gameState.dungeon, isNotNull);
      expect(gameState.currentMode, equals(GameMode.exploration));
      expect(gameState.turnCount, equals(0));
      expect(gameState.gameTime, isNotNull);
    });

    test('Game time starts at day 1, 8 AM', () {
      expect(gameState.gameTime.day, equals(1));
      expect(gameState.gameTime.hour, equals(8));
      expect(gameState.gameTime.minute, equals(0));
    });

    test('Turn advances time correctly', () {
      final initialTurn = gameState.turnCount;
      final initialTime = gameState.gameTime.totalMinutes;
      
      gameState.advanceTurn(timeMinutes: 10);
      
      expect(gameState.turnCount, equals(initialTurn + 1));
      expect(gameState.gameTime.totalMinutes, equals(initialTime + 10));
    });

    test('Player can move on map', () {
      final initialPos = Vector2(gameState.playerPosition.x, gameState.playerPosition.y);
      
      gameState.movePlayer(1, 0);
      
      expect(gameState.playerPosition.x, isNot(equals(initialPos.x)));
    });

    test('Moving advances time', () {
      final initialTime = gameState.gameTime.totalMinutes;
      
      gameState.movePlayer(1, 0);
      
      expect(gameState.gameTime.totalMinutes, greaterThan(initialTime));
    });

    test('Chopping wood advances time', () {
      // Find a wood resource
      if (gameState.gameMap.woodResources.isNotEmpty) {
        final woodPos = gameState.gameMap.woodResources.keys.first;
        gameState.playerPosition = woodPos * 32;
        
        final initialTime = gameState.gameTime.totalMinutes;
        gameState.chopWood();
        
        expect(gameState.gameTime.totalMinutes, greaterThan(initialTime));
      }
    });

    test('Mining metal advances time', () {
      // Find a metal resource
      if (gameState.gameMap.metalResources.isNotEmpty) {
        final metalPos = gameState.gameMap.metalResources.keys.first;
        gameState.playerPosition = metalPos * 32;
        
        final initialTime = gameState.gameTime.totalMinutes;
        gameState.mineMetal();
        
        expect(gameState.gameTime.totalMinutes, greaterThan(initialTime));
      }
    });

    test('Can check if player is in town', () {
      // Move player to town
      gameState.playerPosition = gameState.town.position * 32;
      
      expect(gameState.isInTown(), isTrue);
    });

    test('Can enter and exit town mode', () {
      gameState.enterTown();
      expect(gameState.currentMode, equals(GameMode.town));
      
      gameState.exitTown();
      expect(gameState.currentMode, equals(GameMode.exploration));
    });

    test('Can enter dungeon from town', () {
      gameState.playerPosition = gameState.town.position * 32;
      gameState.enterTown();
      gameState.enterDungeon();
      
      expect(gameState.currentMode, equals(GameMode.dungeon));
    });

    test('Exiting dungeon returns to town', () {
      gameState.enterDungeon();
      gameState.exitDungeon();
      
      expect(gameState.currentMode, equals(GameMode.town));
    });

    test('Can transfer inventory to town', () {
      gameState.player.woodInventory['pine'] = 50;
      gameState.player.metalInventory['iron'] = 30;
      
      gameState.transferInventoryToTown();
      
      expect(gameState.player.woodInventory.isEmpty, isTrue);
      expect(gameState.player.metalInventory.isEmpty, isTrue);
      expect(gameState.town.resources['pine'], equals(50));
      expect(gameState.town.resources['iron'], equals(30));
    });

    test('Time of day changes correctly', () {
      expect(gameState.gameTime.getTimeOfDay(), equals('Morning'));
      
      // Advance to afternoon
      gameState.advanceTurn(timeMinutes: 300); // 5 hours
      expect(gameState.gameTime.getTimeOfDay(), equals('Afternoon'));
    });

    test('Day transitions correctly', () {
      final initialDay = gameState.gameTime.day;
      
      // Advance 16 hours
      gameState.advanceTurn(timeMinutes: 960);
      
      expect(gameState.gameTime.day, greaterThan(initialDay));
    });

    test('Night time is detected correctly', () {
      // Set to night time (10 PM)
      while (gameState.gameTime.hour < 22) {
        gameState.advanceTurn(timeMinutes: 60);
      }
      
      expect(gameState.gameTime.isNight(), isTrue);
    });

    test('Resting restores health and advances time', () {
      gameState.player.takeDamage(50);
      final damagedHealth = gameState.player.health;
      final initialTime = gameState.gameTime.totalMinutes;
      
      gameState.rest();
      
      expect(gameState.player.health, greaterThan(damagedHealth));
      expect(gameState.gameTime.totalMinutes, greaterThan(initialTime));
    });

    test('Building construction takes time', () {
      gameState.town.addResource('wood', 100);
      gameState.town.addResource('iron', 50);
      
      final initialTime = gameState.gameTime.totalMinutes;
      gameState.constructBuildingWithTime('sawmill1', BuildingType.sawmill);
      
      expect(gameState.gameTime.totalMinutes, greaterThan(initialTime));
    });

    test('Game summary contains all relevant information', () {
      final summary = gameState.getSummary();
      
      expect(summary, contains('LUMBERJACK RPG'));
      expect(summary, contains('Time:'));
      expect(summary, contains('Turn:'));
      expect(summary, contains('Mode:'));
      expect(summary, contains('Position:'));
      expect(summary, contains('Level:'));
      expect(summary, contains('Health:'));
    });

    test('Town produces resources periodically', () {
      gameState.town.addResource('wood', 100);
      gameState.town.addResource('iron', 50);
      gameState.constructBuilding('sawmill1', BuildingType.sawmill);
      
      // Advance time for production cycle (6 hours = 360 minutes)
      gameState.advanceTurn(timeMinutes: 360);
      
      expect(gameState.town.resources.containsKey('planks'), isTrue);
    });

    test('Multiple game modes work correctly', () {
      // Start in exploration
      expect(gameState.currentMode, equals(GameMode.exploration));
      
      // Enter town
      gameState.enterTown();
      expect(gameState.currentMode, equals(GameMode.town));
      
      // Enter dungeon
      gameState.enterDungeon();
      expect(gameState.currentMode, equals(GameMode.dungeon));
      
      // Exit back to town
      gameState.exitDungeon();
      expect(gameState.currentMode, equals(GameMode.town));
      
      // Exit to exploration
      gameState.exitTown();
      expect(gameState.currentMode, equals(GameMode.exploration));
    });

    test('Player cannot move into water tiles', () {
      // Find a position and try to move to water
      final initialPos = Vector2(gameState.playerPosition.x, gameState.playerPosition.y);
      
      // Try moving in all directions
      for (int dx = -1; dx <= 1; dx++) {
        for (int dy = -1; dy <= 1; dy++) {
          if (dx == 0 && dy == 0) continue;
          
          final testPos = initialPos;
          gameState.playerPosition = testPos;
          gameState.movePlayer(dx, dy);
          
          // If moved to water, position should not change
          final newTile = (gameState.playerPosition / 32).floor();
          // Bounds check BEFORE accessing array
          if (newTile.x >= 0 && newTile.x < gameState.gameMap.width &&
              newTile.y >= 0 && newTile.y < gameState.gameMap.height) {
            final tileType = gameState.gameMap.tiles[newTile.x.toInt()][newTile.y.toInt()];
            if (tileType == TileType.water) {
              expect(gameState.playerPosition, equals(testPos));
            }
          }
        }
      }
    });

    test('Combat advances time', () {
      final monster = Monster('test', level: 1);
      final initialTime = gameState.gameTime.totalMinutes;
      
      gameState.attackMonster(monster);
      
      expect(gameState.gameTime.totalMinutes, greaterThan(initialTime));
    });
  });
}
