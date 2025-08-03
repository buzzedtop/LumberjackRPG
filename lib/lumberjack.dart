import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

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
