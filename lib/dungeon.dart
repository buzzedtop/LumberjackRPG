import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'monster.dart';

enum DungeonLevel {
  // Original 3 levels
  entrance,        // Level 1
  depths,          // Level 2
  abyss,           // Level 3
  
  // New 17 levels - Themed progression
  forgottenCatacombs,    // Level 4
  cryptOfShadows,        // Level 5
  hallOfBones,           // Level 6
  chasmOfDespair,        // Level 7
  voidChamber,           // Level 8
  infernalPit,           // Level 9
  ashlands,              // Level 10
  moltenCore,            // Level 11
  dragonLair,            // Level 12
  ancientVault,          // Level 13
  cursedLibrary,         // Level 14
  nightmareRealm,        // Level 15
  voidNexus,             // Level 16
  elderSanctum,          // Level 17
  timelessPrison,        // Level 18
  abyssalThrone,         // Level 19
  heartOfDarkness,       // Level 20 - Final boss
}

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
    // Level 1: Entrance - Beginner area
    monsters[DungeonLevel.entrance] = [
      Monster('goblin', level: 7),
      Monster('cave_troll', level: 8),
      Monster('goblin', level: 7),
    ];
    treasures[DungeonLevel.entrance] = {'gold': 50, 'iron': 10};
    
    // Level 2: The Depths
    monsters[DungeonLevel.depths] = [
      Monster('cave_guardian', level: 9),
      Monster('dragon', level: 10),
      Monster('cave_troll', level: 8),
    ];
    treasures[DungeonLevel.depths] = {'gold': 100, 'steel': 15, 'ancient_artifact': 1};
    
    // Level 3: The Abyss
    monsters[DungeonLevel.abyss] = [
      Monster('abyssal_fiend', level: 11),
      Monster('deep_cave_overlord', level: 12),
      Monster('dragon', level: 10),
    ];
    treasures[DungeonLevel.abyss] = {'gold': 200, 'titanium': 20, 'legendary_item': 1};
    
    // Level 4: Forgotten Catacombs
    monsters[DungeonLevel.forgottenCatacombs] = [
      Monster('skeleton_warrior', level: 13),
      Monster('bandit', level: 12),
      Monster('skeleton_warrior', level: 13),
      Monster('cave_guardian', level: 14),
    ];
    treasures[DungeonLevel.forgottenCatacombs] = {'gold': 300, 'steel': 25, 'rare_gem': 2};
    
    // Level 5: Crypt of Shadows
    monsters[DungeonLevel.cryptOfShadows] = [
      Monster('shadow_beast', level: 15),
      Monster('abyssal_fiend', level: 14),
      Monster('shadow_beast', level: 15),
    ];
    treasures[DungeonLevel.cryptOfShadows] = {'gold': 400, 'titanium': 30, 'shadow_essence': 3};
    
    // Level 6: Hall of Bones
    monsters[DungeonLevel.hallOfBones] = [
      Monster('bone_lord', level: 16),
      Monster('skeleton_warrior', level: 15),
      Monster('bone_lord', level: 16),
      Monster('death_knight', level: 17),
    ];
    treasures[DungeonLevel.hallOfBones] = {'gold': 500, 'vanadium': 20, 'cursed_relic': 1};
    
    // Level 7: Chasm of Despair
    monsters[DungeonLevel.chasmOfDespair] = [
      Monster('despair_wraith', level: 18),
      Monster('shadow_beast', level: 17),
      Monster('despair_wraith', level: 18),
    ];
    treasures[DungeonLevel.chasmOfDespair] = {'gold': 600, 'tungsten': 25, 'void_crystal': 2};
    
    // Level 8: Void Chamber
    monsters[DungeonLevel.voidChamber] = [
      Monster('void_stalker', level: 19),
      Monster('abyssal_fiend', level: 18),
      Monster('void_stalker', level: 19),
      Monster('void_champion', level: 20),
    ];
    treasures[DungeonLevel.voidChamber] = {'gold': 750, 'tungsten': 30, 'void_shard': 3};
    
    // Level 9: Infernal Pit
    monsters[DungeonLevel.infernalPit] = [
      Monster('hellhound', level: 21),
      Monster('fire_demon', level: 22),
      Monster('hellhound', level: 21),
    ];
    treasures[DungeonLevel.infernalPit] = {'gold': 900, 'osmium': 20, 'infernal_core': 2};
    
    // Level 10: Ashlands
    monsters[DungeonLevel.ashlands] = [
      Monster('ash_revenant', level: 23),
      Monster('fire_demon', level: 22),
      Monster('ash_revenant', level: 23),
      Monster('lava_titan', level: 24),
    ];
    treasures[DungeonLevel.ashlands] = {'gold': 1100, 'osmium': 25, 'phoenix_feather': 1};
    
    // Level 11: Molten Core
    monsters[DungeonLevel.moltenCore] = [
      Monster('magma_elemental', level: 25),
      Monster('lava_titan', level: 24),
      Monster('magma_elemental', level: 25),
    ];
    treasures[DungeonLevel.moltenCore] = {'gold': 1300, 'iridium': 20, 'molten_heart': 2};
    
    // Level 12: Dragon's Lair
    monsters[DungeonLevel.dragonLair] = [
      Monster('elder_dragon', level: 27),
      Monster('dragon', level: 26),
      Monster('dragon_whelp', level: 25),
      Monster('elder_dragon', level: 27),
    ];
    treasures[DungeonLevel.dragonLair] = {'gold': 1600, 'iridium': 30, 'dragon_scale': 5, 'dragon_egg': 1};
    
    // Level 13: Ancient Vault
    monsters[DungeonLevel.ancientVault] = [
      Monster('vault_guardian', level: 28),
      Monster('golem', level: 27),
      Monster('vault_guardian', level: 28),
    ];
    treasures[DungeonLevel.ancientVault] = {'gold': 2000, 'chromium': 25, 'ancient_scroll': 3};
    
    // Level 14: Cursed Library
    monsters[DungeonLevel.cursedLibrary] = [
      Monster('corrupted_scholar', level: 29),
      Monster('possessed_tome', level: 28),
      Monster('corrupted_scholar', level: 29),
      Monster('knowledge_eater', level: 30),
    ];
    treasures[DungeonLevel.cursedLibrary] = {'gold': 2400, 'chromium': 30, 'forbidden_knowledge': 2};
    
    // Level 15: Nightmare Realm
    monsters[DungeonLevel.nightmareRealm] = [
      Monster('nightmare_horror', level: 31),
      Monster('dream_eater', level: 30),
      Monster('nightmare_horror', level: 31),
    ];
    treasures[DungeonLevel.nightmareRealm] = {'gold': 2900, 'mythril': 20, 'nightmare_essence': 3};
    
    // Level 16: Void Nexus
    monsters[DungeonLevel.voidNexus] = [
      Monster('void_lord', level: 33),
      Monster('void_champion', level: 32),
      Monster('void_lord', level: 33),
      Monster('reality_breaker', level: 34),
    ];
    treasures[DungeonLevel.voidNexus] = {'gold': 3500, 'mythril': 30, 'void_essence': 5};
    
    // Level 17: Elder Sanctum
    monsters[DungeonLevel.elderSanctum] = [
      Monster('elder_lich', level: 35),
      Monster('death_knight', level: 34),
      Monster('elder_lich', level: 35),
    ];
    treasures[DungeonLevel.elderSanctum] = {'gold': 4200, 'adamantite': 25, 'elder_artifact': 2};
    
    // Level 18: Timeless Prison
    monsters[DungeonLevel.timelessPrison] = [
      Monster('time_warden', level: 37),
      Monster('chrono_beast', level: 36),
      Monster('time_warden', level: 37),
      Monster('temporal_anomaly', level: 38),
    ];
    treasures[DungeonLevel.timelessPrison] = {'gold': 5000, 'adamantite': 35, 'time_shard': 3};
    
    // Level 19: Abyssal Throne
    monsters[DungeonLevel.abyssalThrone] = [
      Monster('throne_guardian', level: 39),
      Monster('abyssal_fiend', level: 38),
      Monster('throne_guardian', level: 39),
      Monster('abyssal_champion', level: 40),
    ];
    treasures[DungeonLevel.abyssalThrone] = {'gold': 6000, 'orichalcum': 30, 'throne_fragment': 2};
    
    // Level 20: Heart of Darkness - Final Boss
    monsters[DungeonLevel.heartOfDarkness] = [
      Monster('primordial_horror', level: 42),
      Monster('void_lord', level: 41),
      Monster('elder_dragon', level: 41),
      Monster('dark_god_avatar', level: 45), // Final Boss
    ];
    treasures[DungeonLevel.heartOfDarkness] = {
      'gold': 10000,
      'orichalcum': 50,
      'heart_of_darkness': 1,
      'godslayer_weapon': 1,
      'ultimate_artifact': 1
    };
  }

  bool canDescend() {
    // Can only descend if all monsters on current level are defeated
    final currentMonsters = monsters[currentLevel] ?? [];
    return currentMonsters.every((monster) => monster.isDead);
  }

  void descend() {
    final levelOrder = DungeonLevel.values;
    final currentIndex = levelOrder.indexOf(currentLevel);
    
    if (currentIndex < levelOrder.length - 1) {
      currentLevel = levelOrder[currentIndex + 1];
    }
    // If at the last level, stay there
  }

  void ascend() {
    final levelOrder = DungeonLevel.values;
    final currentIndex = levelOrder.indexOf(currentLevel);
    
    if (currentIndex > 0) {
      currentLevel = levelOrder[currentIndex - 1];
    }
    // If at first level, caller handles exit
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
    buffer.writeln('Current Level: ${_levelName(currentLevel)} (${_getLevelNumber(currentLevel)}/20)');
    buffer.writeln('Entrance: Well at (${entrancePosition.x.toInt()}, ${entrancePosition.y.toInt()})');
    
    final currentMonsters = getCurrentMonsters();
    final aliveMonsters = currentMonsters.where((m) => !m.isDead).toList();
    
    buffer.writeln('\n--- Monsters on this level ---');
    if (aliveMonsters.isEmpty) {
      buffer.writeln('All monsters defeated!');
      if (canDescend() && currentLevel != DungeonLevel.heartOfDarkness) {
        buffer.writeln('You can descend deeper...');
      } else if (currentLevel == DungeonLevel.heartOfDarkness) {
        buffer.writeln('🎉 CONGRATULATIONS! You have conquered the entire dungeon!');
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

  int _getLevelNumber(DungeonLevel level) {
    return DungeonLevel.values.indexOf(level) + 1;
  }

  String _levelName(DungeonLevel level) {
    switch (level) {
      case DungeonLevel.entrance:
        return 'Entrance Level';
      case DungeonLevel.depths:
        return 'The Depths';
      case DungeonLevel.abyss:
        return 'The Abyss';
      case DungeonLevel.forgottenCatacombs:
        return 'Forgotten Catacombs';
      case DungeonLevel.cryptOfShadows:
        return 'Crypt of Shadows';
      case DungeonLevel.hallOfBones:
        return 'Hall of Bones';
      case DungeonLevel.chasmOfDespair:
        return 'Chasm of Despair';
      case DungeonLevel.voidChamber:
        return 'Void Chamber';
      case DungeonLevel.infernalPit:
        return 'Infernal Pit';
      case DungeonLevel.ashlands:
        return 'The Ashlands';
      case DungeonLevel.moltenCore:
        return 'Molten Core';
      case DungeonLevel.dragonLair:
        return 'Dragon\'s Lair';
      case DungeonLevel.ancientVault:
        return 'Ancient Vault';
      case DungeonLevel.cursedLibrary:
        return 'Cursed Library';
      case DungeonLevel.nightmareRealm:
        return 'Nightmare Realm';
      case DungeonLevel.voidNexus:
        return 'Void Nexus';
      case DungeonLevel.elderSanctum:
        return 'Elder Sanctum';
      case DungeonLevel.timelessPrison:
        return 'Timeless Prison';
      case DungeonLevel.abyssalThrone:
        return 'Abyssal Throne';
      case DungeonLevel.heartOfDarkness:
        return 'Heart of Darkness';
    }
  }
}
