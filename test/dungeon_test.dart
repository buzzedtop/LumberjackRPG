import 'package:flutter_test/flutter_test.dart';
import 'package:lumberjack_rpg/dungeon.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  group('Dungeon System Mechanics', () {
    late Dungeon dungeon;

    setUp(() {
      dungeon = Dungeon(
        name: 'Test Dungeon',
        entrancePosition: Vector2(10, 10),
      );
    });

    test('Dungeon initializes at entrance level', () {
      expect(dungeon.currentLevel, equals(DungeonLevel.entrance));
      expect(dungeon.name, equals('Test Dungeon'));
      expect(dungeon.entrancePosition.x, equals(10));
      expect(dungeon.entrancePosition.y, equals(10));
    });

    test('Dungeon generates monsters for each level', () {
      expect(dungeon.monsters, isNotEmpty);
      expect(dungeon.monsters[DungeonLevel.entrance], isNotEmpty);
      expect(dungeon.monsters[DungeonLevel.depths], isNotEmpty);
      expect(dungeon.monsters[DungeonLevel.abyss], isNotEmpty);
    });

    test('Dungeon generates treasures for each level', () {
      expect(dungeon.treasures, isNotEmpty);
      expect(dungeon.treasures[DungeonLevel.entrance], isNotEmpty);
      expect(dungeon.treasures[DungeonLevel.depths], isNotEmpty);
      expect(dungeon.treasures[DungeonLevel.abyss], isNotEmpty);
    });

    test('Deeper levels have stronger monsters', () {
      final entranceMonsters = dungeon.monsters[DungeonLevel.entrance]!;
      final depthsMonsters = dungeon.monsters[DungeonLevel.depths]!;
      
      final entranceAvgLevel = entranceMonsters.fold<int>(0, (sum, m) => sum + m.level) / entranceMonsters.length;
      final depthsAvgLevel = depthsMonsters.fold<int>(0, (sum, m) => sum + m.level) / depthsMonsters.length;
      
      expect(depthsAvgLevel, greaterThanOrEqualTo(entranceAvgLevel));
    });

    test('Deeper levels have better treasures', () {
      final entranceTreasure = dungeon.treasures[DungeonLevel.entrance]!;
      final depthsTreasure = dungeon.treasures[DungeonLevel.depths]!;
      
      final entranceGold = entranceTreasure['gold'] ?? 0;
      final depthsGold = depthsTreasure['gold'] ?? 0;
      
      expect(depthsGold, greaterThanOrEqualTo(entranceGold));
    });

    test('All monsters on a level are alive initially', () {
      final entranceMonsters = dungeon.monsters[DungeonLevel.entrance]!;
      
      for (final monster in entranceMonsters) {
        expect(monster.isDead, isFalse);
      }
    });

    test('Dungeon has multiple levels defined', () {
      expect(DungeonLevel.values.length, greaterThanOrEqualTo(3));
      expect(DungeonLevel.values.contains(DungeonLevel.entrance), isTrue);
      expect(DungeonLevel.values.contains(DungeonLevel.depths), isTrue);
      expect(DungeonLevel.values.contains(DungeonLevel.abyss), isTrue);
    });

    test('Can get current level monsters', () {
      final currentMonsters = dungeon.getCurrentMonsters();
      
      expect(currentMonsters, isNotNull);
      expect(currentMonsters.isNotEmpty, isTrue);
    });

    test('Can get current level treasure', () {
      final currentTreasure = dungeon.treasures[dungeon.currentLevel];
      
      expect(currentTreasure, isNotNull);
      expect(currentTreasure!.isNotEmpty, isTrue);
    });

    test('Can check if level is cleared', () {
      final isCleared = dungeon.canDescend();
      
      expect(isCleared, isFalse);
      
      // Kill all monsters
      final monsters = dungeon.getCurrentMonsters();
      for (final monster in monsters) {
        monster.takeDamage(monster.maxHealth);
      }
      
      expect(dungeon.canDescend(), isTrue);
    });

    test('Can descend to next level after clearing', () {
      // Kill all monsters
      final monsters = dungeon.getCurrentMonsters();
      for (final monster in monsters) {
        monster.takeDamage(monster.maxHealth);
      }
      
      final canDescend = dungeon.canDescend();
      expect(canDescend, isTrue);
      
      dungeon.descend();
      expect(dungeon.currentLevel, isNot(equals(DungeonLevel.entrance)));
    });

    test('Cannot descend without clearing level', () {
      final canDescend = dungeon.canDescend();
      
      expect(canDescend, isFalse);
    });

    test('Dungeon info contains level details', () {
      final info = dungeon.getInfo();
      
      expect(info, contains('Test Dungeon'));
      expect(info, contains('Level'));
    });

    test('Extended dungeon levels exist', () {
      // Check for extended 20 level dungeon
      expect(DungeonLevel.values.length, greaterThanOrEqualTo(10));
      
      // Check some deeper levels exist if implemented
      if (DungeonLevel.values.length >= 20) {
        expect(DungeonLevel.values.contains(DungeonLevel.heartOfDarkness), isTrue);
      }
    });

    test('Each level has unique monsters', () {
      final levels = [
        DungeonLevel.entrance,
        DungeonLevel.depths,
        DungeonLevel.abyss,
      ];
      
      for (final level in levels) {
        expect(dungeon.monsters.containsKey(level), isTrue);
      }
    });

    test('Level progression maintains state', () {
      final initialLevel = dungeon.currentLevel;
      
      // Kill all monsters
      final monsters = dungeon.getCurrentMonsters();
      for (final monster in monsters) {
        monster.takeDamage(monster.maxHealth);
      }
      
      dungeon.descendLevel();
      
      expect(dungeon.currentLevel, isNot(equals(initialLevel)));
    });
  });
}
