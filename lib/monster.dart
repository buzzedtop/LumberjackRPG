import 'dart:math';
import 'package:flame/components.dart';
import 'lumberjack.dart';
import 'wood.dart';
import 'metal.dart';
import 'constants.dart';

enum TileType { water, forest, mountain, cave, deepCave }

class Monster {
  String name;
  Wood? wood;
  Metal? metal;
  int health;
  int damage;
  int agility;
  TileType biome;
  Vector2 position; // Added for positioning in lumberjack_rpg.dart

  Monster(this.name, this.biome, Lumberjack player, {this.wood, this.metal, Vector2? position})
      : position = position ?? Vector2.zero() {
    int baseLevel = player.level;
    bool isBoss = name == 'Cave Guardian' || name == 'Deep Cave Overlord';
    List<Wood> biomeWoods = woodTypes.where((w) => w.biome.contains(biome.toString().split('.').last) && baseLevel >= w.levelRange.start).toList();
    List<Metal> biomeMetals = metalTypes.where((m) => m.biome.contains(biome.toString().split('.').last) && baseLevel >= m.levelRange.start).toList();

    Random rand = Random(baseLevel);
    if (biomeWoods.isNotEmpty && biomeMetals.isNotEmpty && !isBoss) {
      double woodWeight = biomeWoods.fold(0, (sum, w) => sum + (w.rarity == 'Common' ? 0.5 : w.rarity == 'Uncommon' ? 0.3 : w.rarity == 'Rare' ? 0.15 : w.name == 'Australian Buloke' ? 0.01 : 0.05));
      double metalWeight = biomeMetals.fold(0, (sum, m) => sum + (m.rarity == 'Common' ? 0.5 : m.rarity == 'Uncommon' ? 0.3 : m.rarity == 'Rare' ? 0.15 : m.name == 'Chromium' ? 0.005 : 0.05));
      double woodRoll = rand.nextDouble() * woodWeight;
      double metalRoll = rand.nextDouble() * metalWeight;
      double currentWood = 0, currentMetal = 0;

      for (var w in biomeWoods) {
        currentWood += (w.rarity == 'Common' ? 0.5 : w.rarity == 'Uncommon' ? 0.3 : w.rarity == 'Rare' ? 0.15 : w.name == 'Australian Buloke' ? 0.01 : 0.05);
        if (woodRoll <= currentWood) {
          wood = w;
          break;
        }
      }
      for (var m in biomeMetals) {
        currentMetal += (m.rarity == 'Common' ? 0.5 : m.rarity == 'Uncommon' ? 0.3 : m.rarity == 'Rare' ? 0.15 : m.name == 'Chromium' ? 0.005 : 0.05);
        if (metalRoll <= currentMetal) {
          metal = m;
          break;
        }
      }
    } else if (isBoss) {
      wood = isBoss && name == 'Deep Cave Overlord' ? woodTypes.firstWhere((w) => w.name == 'Australian Buloke') : woodTypes.firstWhere((w) => w.name == 'Black Ironwood');
      metal = isBoss && name == 'Deep Cave Overlord' ? metalTypes.firstWhere((m) => m.name == 'Chromium') : metalTypes.firstWhere((m) => m.name == 'Tungsten');
    }

    health = isBoss
        ? 500000 + baseLevel * 50 + (wood?.jankaHardness ?? 1000) / 100 + (metal?.mohsHardness ?? 5) * 100
        : 50 + baseLevel * 20 + (wood?.jankaHardness ?? 1000) / 100 + (metal?.mohsHardness ?? 5) * 100;
    damage = isBoss
        ? 500 + baseLevel * 5 + (wood?.jankaHardness ?? 1000) / 500 + (metal?.mohsHardness ?? 5) * 20
        : 5 + baseLevel * 2 + (wood?.jankaHardness ?? 1000) / 500 + (metal?.mohsHardness ?? 5) * 20;
    agility = isBoss
        ? 10 + baseLevel * 2 + (metal?.mohsHardness ?? 5) * 10
        : 5 + baseLevel + (metal?.mohsHardness ?? 5) * 10;
  }

  int get xpReward => name == 'Cave Guardian' || name == 'Deep Cave Overlord'
      ? 500000 + health * 10
      : 1000 + health * 5;

  String get fullName => wood != null && metal != null ? '${wood!.name} ${metal!.name} $name' : name;
}
