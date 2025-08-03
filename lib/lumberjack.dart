import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'axe.dart';
import 'wood.dart';
import 'metal.dart';

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
