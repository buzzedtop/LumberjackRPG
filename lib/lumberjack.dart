import 'package:vector_math/vector_math.dart';
import 'axe.dart';
import 'wood.dart';
import 'metal.dart';
import 'monster.dart';
import 'crafting_system.dart';

class Lumberjack {
  int level = 1;
  int experience = 0;
  int maxHealth = 100;
  int health = 100;
  Axe axe = Axe(AxeType.stone);
  final Map<String, int> woodInventory = {};
  final Map<String, int> metalInventory = {};
  final CraftingSystem craftingSystem = CraftingSystem();

  void chopWood(Wood wood) {
    if (!wood.isDepleted) {
      wood.chop();
      if (wood.isDepleted) {
        woodInventory.update(wood.name, (value) => value + wood.amount, ifAbsent: () => wood.amount);
        experience += 10;
        checkLevelUp();
      }
    }
  }

  void mineMetal(Metal metal) {
    if (!metal.isDepleted) {
      metal.mine();
      if (metal.isDepleted) {
        metalInventory.update(metal.name, (value) => value + metal.amount, ifAbsent: () => metal.amount);
        experience += 15;
        checkLevelUp();
      }
    }
  }

  void attack(Monster monster) {
    if (!monster.isDead) {
      monster.takeDamage(axe.damage);
      if (monster.isDead) {
        experience += monster.level * 20;
        checkLevelUp();
      } else {
        takeDamage(monster.damage);
      }
    }
  }

  void takeDamage(int damage) {
    health = (health - damage).clamp(0, maxHealth);
  }

  void checkLevelUp() {
    int requiredExp = level * 100;
    while (experience >= requiredExp) {
      level++;
      experience -= requiredExp;
      maxHealth += 10;
      health = maxHealth;
      requiredExp = level * 100;
    }
  }

  void craftAxe(AxeType newType) {
    if (craftingSystem.canCraftAxe(this, newType)) {
      craftingSystem.craftAxe(this, newType);
      axe = Axe(newType);
    }
  }
}