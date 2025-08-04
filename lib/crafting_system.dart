import 'lumberjack.dart';
import 'axe.dart';

class CraftingSystem {
  final Map<AxeType, Map<String, int>> axeRecipes = {
    AxeType.stone: {'wood': 5},
    AxeType.iron: {'wood': 10, 'iron': 5},
    AxeType.steel: {'wood': 15, 'steel': 10},
    AxeType.titanium: {'wood': 20, 'titanium': 15},
    AxeType.vanadium: {'wood': 25, 'vanadium': 20},
  };

  bool canCraftAxe(Lumberjack lumberjack, AxeType type) {
    final recipe = axeRecipes[type]!;
    for (var entry in recipe.entries) {
      final resource = entry.key;
      final requiredAmount = entry.value;
      final inventory = resource == 'wood'
          ? lumberjack.woodInventory
          : lumberjack.metalInventory;
      if (!inventory.containsKey(resource) || inventory[resource]! < requiredAmount) {
        return false;
      }
    }
    return true;
  }

  void craftAxe(Lumberjack lumberjack, AxeType type) {
    final recipe = axeRecipes[type]!;
    for (var entry in recipe.entries) {
      final resource = entry.key;
      final requiredAmount = entry.value;
      final inventory = resource == 'wood'
          ? lumberjack.woodInventory
          : lumberjack.metalInventory;
      inventory[resource] = inventory[resource]! - requiredAmount;
      if (inventory[resource]! <= 0) {
        inventory.remove(resource);
      }
    }
  }
}