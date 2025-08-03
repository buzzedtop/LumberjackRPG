import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class CraftingSystem {
  static Axe? craftAxe(Lumberjack player, Wood wood, Metal metal, AxeType type) {
    // Resource requirements for each axe type
    Map<AxeType, Map<String, int>> requirements = {
      AxeType.handAxe: {'wood': 1, 'metal': 1},
      AxeType.dualHandAxes: {'wood': 2, 'metal': 2},
      AxeType.throwingAxe: {'wood': 1, 'metal': 1},
      AxeType.battleAxe: {'wood': 2, 'metal': 3},
      AxeType.doubleBittedAxe: {'wood': 2, 'metal': 2},
      AxeType.fellingAxe: {'wood': 2, 'metal': 1},
      AxeType.broadAxe: {'wood': 2, 'metal': 2},
      AxeType.tomahawk: {'wood': 1, 'metal': 1},
      AxeType.splittingMaul: {'wood': 3, 'metal': 3},
      AxeType.adze: {'wood': 1, 'metal': 2},
    };

    // Level requirements for rare resources
    if (wood.rarity == 'Rare' && player.level < 50 || wood.rarity == 'Very Rare' && player.level < 200) {
      return null;
    }
    if (metal.rarity == 'Rare' && player.level < 70 || metal.rarity == 'Very Rare' && player.level < 400) {
      return null;
    }

    // Check if player has enough resources
    if (requirements[type]!['wood']! > (player.woodInventory[wood] ?? 0) ||
        requirements[type]!['metal']! > (player.metalInventory[metal] ?? 0)) {
      return null;
    }

    // Base stats for each axe type
    Map<AxeType, Map<String, dynamic>> baseStats = {
      AxeType.handAxe: {
        'damage': 10 + player.level ~/ 10,
        'speed': 1.0,
        'range': 'Melee',
        'durability': 50,
        'chopBonus': 0.0,
        'craftBonus': 0.0
      },
      AxeType.dualHandAxes: {
        'damage': 8 + player.level ~/ 10,
        'speed': 0.7,
        'range': 'Melee',
        'durability': 40,
        'chopBonus': 0.0,
        'craftBonus': 0.0
      },
      AxeType.throwingAxe: {
        'damage': 12 + player.level ~/ 10,
        'speed': 1.5,
        'range': 'Short',
        'durability': 20,
        'chopBonus': 0.0,
        'craftBonus': 0.0
      },
      AxeType.battleAxe: {
        'damage': 20 + player.level ~/ 5,
        'speed': 2.0,
        'range': 'Melee',
        'durability': 80,
        'chopBonus': 0.0,
        'craftBonus': 0.0
      },
      AxeType.doubleBittedAxe: {
        'damage': 18 + player.level ~/ 5,
        'speed': 1.5,
        'range': 'Melee',
        'durability': 70,
        'chopBonus': 0.2,
        'craftBonus': 0.0
      },
      AxeType.fellingAxe: {
        'damage': 8 + player.level ~/ 10,
        'speed': 2.0,
        'range': 'Melee',
        'durability': 100,
        'chopBonus': 0.5,
        'craftBonus': 0.0
      },
      AxeType.broadAxe: {
        'damage': 15 + player.level ~/ 5,
        'speed': 1.5,
        'range': 'Melee',
        'durability': 70,
        'chopBonus': 0.1,
        'craftBonus': 0.1
      },
      AxeType.tomahawk: {
        'damage': 12 + player.level ~/ 10,
        'speed': 1.0,
        'range': 'Short',
        'durability': 50,
        'chopBonus': 0.1,
        'craftBonus': 0.0
      },
      AxeType.splittingMaul: {
        'damage': 25 + player.level ~/ 5,
        'speed': 2.5,
        'range': 'Melee',
        'durability': 90,
        'chopBonus': 0.3,
        'craftBonus': 0.0
      },
      AxeType.adze: {
        'damage': 8 + player.level ~/ 10,
        'speed': 1.2,
        'range': 'Melee',
        'durability': 60,
        'chopBonus': 0.0,
        'craftBonus': 0.2
      },
    };

    // Consume resources
    player.woodInventory[wood] = player.woodInventory[wood]! - requirements[type]!['wood']!;
    player.metalInventory[metal] = player.metalInventory[metal]! - requirements[type]!['metal']!;

    // Calculate final stats
    int finalDamage = baseStats[type]!['damage'] + wood.damageBonus + metal.damageBonus;
    int finalDurability =
        ((baseStats[type]!['durability'] * (wood.jankaHardness / 1000) * (metal.mohsHardness / 4)).round());
    double finalSpeed = baseStats[type]!['speed'] * (wood.rarity == 'Very Rare' ? 1.1 : 1.0);
    double weightModifier = (wood.rarity == 'Very Rare' ? 1.1 : 1.0) * metal.weightModifier;

    return Axe(
      type: type,
      wood: wood,
      metal: metal,
      damage: finalDamage,
      durability: finalDurability,
      speed: finalSpeed,
      range: baseStats[type]!['range'],
      chopBonus: baseStats[type]!['chopBonus'],
      craftBonus: baseStats[type]!['craftBonus'],
      weightModifier: weightModifier,
    );
  }
}

class Lumberjack {
  String name = "Lumberjack";
  int strength = 10;
  int stamina = 10;
  int baseAgility = 10;
  int level = 1;
  int experience = 0;
  int maxHealth = 100;
  int health = 100;
  Map<Wood, int> woodInventory = {};
  Map<Metal, int> metalInventory = {};
  Axe? equippedAxe;
  double totalPlayTime = 0.0;

  int get agility => (baseAgility * (equippedAxe?.wood.weightModifier ?? 1.0) * (equippedAxe?.metal.weightModifier ?? 1.0)).round();
  int get xpToNextLevel => 100 * level * level;

  void addWood(Wood wood, int amount) {
    woodInventory[wood] = (woodInventory[wood] ?? 0) + amount;
  }

  void addMetal(Metal metal, int amount) {
    metalInventory[metal] = (metalInventory[metal] ?? 0) + amount;
  }

  void levelUp() {
    level++;
    strength += 2 + (level ~/ 100);
    stamina += 2 + (level ~/ 100);
    baseAgility += 1 + (level ~/ 200);
    maxHealth = stamina * 10;
    health = maxHealth;
  }

  void gainExperience(int exp) {
    experience += exp;
    while (experience >= xpToNextLevel) {
      experience -= xpToNextLevel;
      levelUp();
    }
  }

  void updatePlayTime(double delta) {
    totalPlayTime += delta / 3600;
  }
}

class Wood {
  final String name;
  final int jankaHardness;
  final String rarity;
  final String biome;
  final int damageBonus;
  final double weightModifier;

  Wood(this.name, this.jankaHardness, this.rarity, this.biome, this.damageBonus, this.weightModifier);
}

class Metal {
  final String name;
  final double mohsHardness;
  final String rarity;
  final String biome;
  final int damageBonus;
  final int durabilityBonus;
  final double weightModifier;

  Metal(this.name, this.mohsHardness, this.rarity, this.biome, this.damageBonus, this.durabilityBonus, this.weightModifier);
}

class Axe {
  final AxeType type;
  final Wood wood;
  final Metal metal;
  final int damage;
  final int durability;
  final double speed;
  final String range;
  final double chopBonus;
  final double craftBonus;
  final double weightModifier;

  Axe({
    required this.type,
    required this.wood,
    required this.metal,
    required this.damage,
    required this.durability,
    required this.speed,
    required this.range,
    required this.chopBonus,
    required this.craftBonus,
    required this.weightModifier,
  });
}

enum AxeType {
  handAxe,
  dualHandAxes,
  throwingAxe,
  battleAxe,
  doubleBittedAxe,
  fellingAxe,
  broadAxe,
  tomahawk,
  splittingMaul,
  adze,
}
