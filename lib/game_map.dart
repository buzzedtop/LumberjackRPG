import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/noise.dart';
import 'lumberjack.dart';
import 'wood.dart';
import 'metal.dart';
import 'monster.dart';
import 'constants.dart';

enum TileType { water, forest, mountain, cave, deepCave }

class GameMap {
  final int width = 100;
  final int height = 100;
  late List<List<TileType>> tiles;
  final int seed;
  Map<Vector2, Wood> woodResources = {};
  Map<Vector2, Metal> metalResources = {};
  Map<Vector2, int> resourceHitsRequired = {};
  bool caveGuardianDefeated = false;
  bool deepCaveOverlordDefeated = false;

  GameMap(this.seed) {
    tiles = List.generate(width, (_) => List.filled(height, TileType.forest));
    generateMap();
    generateWoodResources();
    generateMetalResources();
  }

  void generateMap() {
    final noise = SimplexNoise(seed: seed);
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        double value = noise.getNoise2(x / 20.0, y / 20.0);
        if (value < -0.2) {
          tiles[x][y] = TileType.water;
        } else if (value < 0.2) {
          tiles[x][y] = TileType.forest;
        } else if (value < 0.5) {
          tiles[x][y] = TileType.mountain;
        } else if (value < 0.7) {
          tiles[x][y] = TileType.cave;
        } else {
          tiles[x][y] = TileType.deepCave;
        }
      }
    }
  }

  void generateWoodResources() {
    Random rand = Random(seed);
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        if (tiles[x][y] == TileType.water) continue;
        if (rand.nextDouble() < 0.05) {
          List<Wood> biomeWoods = woodTypes.where((wood) => wood.biome.contains(tiles[x][y].toString().split('.').last)).toList();
          if (tiles[x][y] == TileType.cave && biomeWoods.any((wood) => wood.name == 'Australian Buloke') && !caveGuardianDefeated) {
            biomeWoods.removeWhere((wood) => wood.name == 'Australian Buloke');
          }
          if (biomeWoods.isNotEmpty) {
            double totalWeight = biomeWoods.fold(0, (sum, wood) => sum + (wood.rarity == 'Common' ? 0.5 : wood.rarity == 'Uncommon' ? 0.3 : wood.rarity == 'Rare' ? 0.15 : wood.name == 'Australian Buloke' ? 0.01 : 0.05));
            double roll = rand.nextDouble() * totalWeight;
            double current = 0;
            for (var wood in biomeWoods) {
              double weight = wood.rarity == 'Common' ? 0.5 : wood.rarity == 'Uncommon' ? 0.3 : wood.rarity == 'Rare' ? 0.15 : wood.name == 'Australian Buloke' ? 0.01 : 0.05;
              current += weight;
              if (roll <= current) {
                Vector2 pos = Vector2(x.toDouble(), y.toDouble());
                woodResources[pos] = wood;
                resourceHitsRequired[pos] = wood.rarity == 'Common' ? 1 : wood.rarity == 'Uncommon' ? 2 : wood.rarity == 'Rare' ? 3 : wood.name == 'Australian Buloke' ? 5 : 4;
                break;
              }
            }
          }
        }
      }
    }
  }

  void generateMetalResources() {
    Random rand = Random(seed + 1);
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        if (tiles[x][y] != TileType.mountain && tiles[x][y] != TileType.cave && tiles[x][y] != TileType.deepCave) continue;
        double spawnChance = tiles[x][y] == TileType.deepCave ? 0.01 : 0.03;
        if (rand.nextDouble() < spawnChance) {
          List<Metal> biomeMetals = metalTypes.where((metal) => metal.biome.contains(tiles[x][y].toString().split('.').last)).toList();
          if (tiles[x][y] == TileType.deepCave && biomeMetals.any((metal) => metal.name == 'Chromium') && !deepCaveOverlordDefeated) {
            biomeMetals.removeWhere((metal) => metal.name == 'Chromium');
          }
          if (biomeMetals.isNotEmpty) {
            double totalWeight = biomeMetals.fold(0, (sum, metal) => sum + (metal.rarity == 'Common' ? 0.5 : metal.rarity == 'Uncommon' ? 0.3 : metal.rarity == 'Rare' ? 0.15 : metal.name == 'Chromium' ? 0.005 : 0.05));
            double roll = rand.nextDouble() * totalWeight;
            double current = 0;
            for (var metal in biomeMetals) {
              double weight = metal.rarity == 'Common' ? 0.5 : metal.rarity == 'Uncommon' ? 0.3 : metal.rarity == 'Rare' ? 0.15 : metal.name == 'Chromium' ? 0.005 : 0.05;
              current += weight;
              if (roll <= current) {
                Vector2 pos = Vector2(x.toDouble(), y.toDouble());
                metalResources[pos] = metal;
                resourceHitsRequired[pos] = metal.rarity == 'Common' ? 2 : metal.rarity == 'Uncommon' ? 3 : metal.rarity == 'Rare' ? 4 : metal.name == 'Chromium' ? 6 : 5;
                break;
              }
            }
          }
        }
      }
    }
  }

  List<Monster> generateMonsters(Lumberjack player, TileType biome, int count) {
    List<String> names;
    if (biome == TileType.forest) {
      names = ['Wolf', 'Boar', 'Bandit'];
    } else if (biome == TileType.mountain) {
      names = ['Bear', 'Mountain Troll', 'Golem'];
    } else if (biome == TileType.cave) {
      names = ['Goblin', 'Cave Troll'];
      if (player.level >= 200) names.add('Cave Guardian');
    } else {
      names = ['Dragon', 'Abyssal Fiend'];
      if (player.level >= 400) names.add('Deep Cave Overlord');
    }
    Random rand = Random(player.level);
    return List.generate(count, (_) => Monster(names[rand.nextInt(names.length)], biome, player));
  }
}
