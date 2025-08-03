class CraftingSystem {
  static Axe? craftAxe(Lumberjack player, Wood wood, Metal metal, AxeType type) {
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

    if (wood.rarity == 'Rare' && player.level < 50 || wood.rarity == 'Very Rare' && player.level < 200) return null;
    if (metal.rarity == 'Rare' && player.level < 70 || metal.rarity == 'Very Rare' && player.level < 400) return null;
    if (requirements[type]!['wood']! > (player.woodInventory[wood] ?? 0) ||
        requirements[type]!['metal']! > (player.metalInventory[metal] ?? 0)) return null;

    Map<AxeType, Map<String, dynamic>> baseStats = {
      AxeType.handAxe: {'damage': 10 + player.level ~/ 10, 'speed': 1.0, 'range': 'Melee', 'durability': 50, 'chopBonus': 0.0, 'craftBonus': 0.0},
      AxeType.dualHandAxes: {'damage': 8 + player.level ~/ 10, 'speed': 0.7, 'range': 'Melee', 'durability': 40, 'chopBonus': 0.0, 'craftBonus': 0.0},
      AxeType.throwingAxe: {'damage': 12 + player.level ~/ 10, 'speed': 1.5, 'range': 'Short', 'durability': 20, 'chopBonus': 0.0, 'craftBonus': 0.0},
      AxeType.battleAxe: {'damage': 20 + player.level ~/ 5, 'speed': 2.0, 'range': 'Melee', 'durability': 80, 'chopBonus': 0.0, 'craftBonus': 0.0},
      AxeType.doubleBittedAxe: {'damage': 18 + player.level ~/ 5, 'speed': 1.5, 'range': 'Melee', 'durability': 70, 'chopBonus': 0.2, 'craftBonus': 0.0},
      AxeType.fellingAxe: {'damage': 8 + player.level ~/ 10, 'speed': 2.0, 'range': 'Melee', 'durability': 100, 'chopBonus': 0.5, 'craftBonus': 0.0},
      AxeType.broadAxe: {'damage': 15 + player.level ~/ 5, 'speed': 1.5, 'range': 'Melee', 'durability': 70, 'chopBonus': 0.1, 'craftBonus': 0.1},
      AxeType.tomahawk: {'damage': 12 + player.level ~/ 10, 'speed': 1.0, 'range': 'Short', 'durability': 50, 'chopBonus': 0.1, 'craftBonus': 0.0},
      AxeType.splittingMaul: {'damage': 25 + player.level ~/ 5, 'speed': 2.5, 'range': 'Melee', 'durability': 90, 'chopBonus': 0.3, 'craftBonus': 0.0},
      AxeType.adze: {'damage': 8 + player.level ~/ 10, 'speed': 1.2, 'range': 'Melee', 'durability': 60, 'chopBonus': 0.0, 'craftBonus': 0.2},
    };

    player.woodInventory[wood] = player.woodInventory[wood]! - requirements[type]!['wood']!;
    player.metalInventory[metal] = player.metalInventory[metal]! - requirements[type]!['metal']!;

    int finalDamage = baseStats[type]!['damage'] + wood.damageBonus + metal.damageBonus;
    int finalDurability = ((baseStats[type]!['durability'] * (wood.jankaHardness / 1000) * (metal.mohsHardness / 4)).round());
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
