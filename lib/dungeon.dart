import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'monster.dart';

enum DungeonLevel { entrance, depths, abyss }

class Dungeon {
  final String name;
  final Vector2 entrancePosition; // Position of the well entrance
  DungeonLevel currentLevel;
  final Map<DungeonLevel, List<Monster>> monsters = {};
  final Map<DungeonLevel, Map<String, int>> treasures = {};
  final Random random = Random();
  
  Dungeon({
    required this.name,
    required this.entrancePosition,
    this.currentLevel = DungeonLevel.entrance,
  }) {
    _generateDungeon();
  }

  void _generateDungeon() {
    // Generate monsters for each level
    monsters[DungeonLevel.entrance] = [
      Monster('goblin', level: 7),
      Monster('cave_troll', level: 8),
      Monster('goblin', level: 7),
    ];
    
    monsters[DungeonLevel.depths] = [
      Monster('cave_guardian', level: 9),
      Monster('dragon', level: 10),
      Monster('cave_troll', level: 8),
    ];
    
    monsters[DungeonLevel.abyss] = [
      Monster('abyssal_fiend', level: 11),
      Monster('deep_cave_overlord', level: 12),
      Monster('dragon', level: 10),
    ];

    // Generate treasures
    treasures[DungeonLevel.entrance] = {'gold': 50, 'iron': 10};
    treasures[DungeonLevel.depths] = {'gold': 100, 'steel': 15, 'ancient_artifact': 1};
    treasures[DungeonLevel.abyss] = {'gold': 200, 'titanium': 20, 'legendary_item': 1};
  }

  bool canDescend() {
    // Can only descend if all monsters on current level are defeated
    final currentMonsters = monsters[currentLevel] ?? [];
    return currentMonsters.every((monster) => monster.isDead);
  }

  void descend() {
    switch (currentLevel) {
      case DungeonLevel.entrance:
        currentLevel = DungeonLevel.depths;
        break;
      case DungeonLevel.depths:
        currentLevel = DungeonLevel.abyss;
        break;
      case DungeonLevel.abyss:
        // Already at the bottom
        break;
    }
  }

  void ascend() {
    switch (currentLevel) {
      case DungeonLevel.entrance:
        // Exit dungeon (handled by caller)
        break;
      case DungeonLevel.depths:
        currentLevel = DungeonLevel.entrance;
        break;
      case DungeonLevel.abyss:
        currentLevel = DungeonLevel.depths;
        break;
    }
  }

  List<Monster> getCurrentMonsters() {
    return monsters[currentLevel] ?? [];
  }

  Map<String, int>? collectTreasure() {
    if (!canDescend()) {
      return null; // Can't collect treasure until all monsters defeated
    }
    
    final treasure = treasures[currentLevel];
    treasures[currentLevel] = {}; // Clear treasure after collection
    return treasure;
  }

  String getInfo() {
    final buffer = StringBuffer();
    buffer.writeln('===== $name =====');
    buffer.writeln('Current Level: ${_levelName(currentLevel)}');
    buffer.writeln('Entrance: Well at (${entrancePosition.x.toInt()}, ${entrancePosition.y.toInt()})');
    
    final currentMonsters = getCurrentMonsters();
    final aliveMonsters = currentMonsters.where((m) => !m.isDead).toList();
    
    buffer.writeln('\n--- Monsters on this level ---');
    if (aliveMonsters.isEmpty) {
      buffer.writeln('All monsters defeated!');
      if (canDescend() && currentLevel != DungeonLevel.abyss) {
        buffer.writeln('You can descend deeper...');
      }
    } else {
      for (var i = 0; i < aliveMonsters.length; i++) {
        final monster = aliveMonsters[i];
        buffer.writeln('${i + 1}. ${monster.name} (Level ${monster.level}) - HP: ${monster.health}/${monster.maxHealth}');
      }
    }
    
    final treasure = treasures[currentLevel];
    if (treasure != null && treasure.isNotEmpty) {
      buffer.writeln('\n--- Treasure ---');
      treasure.forEach((item, amount) {
        buffer.writeln('$item: $amount');
      });
    }
    
    return buffer.toString();
  }

  String _levelName(DungeonLevel level) {
    switch (level) {
      case DungeonLevel.entrance:
        return 'Entrance Level';
      case DungeonLevel.depths:
        return 'The Depths';
      case DungeonLevel.abyss:
        return 'The Abyss';
    }
  }
}
