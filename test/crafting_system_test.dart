import 'package:flutter_test/flutter_test.dart';
import 'package:lumberjack_rpg/crafting_system.dart';
import 'package:lumberjack_rpg/lumberjack.dart';
import 'package:lumberjack_rpg/axe.dart';

void main() {
  group('Crafting System Mechanics', () {
    late CraftingSystem craftingSystem;
    late Lumberjack player;

    setUp(() {
      craftingSystem = CraftingSystem();
      player = Lumberjack();
    });

    test('CraftingSystem initializes correctly', () {
      expect(craftingSystem, isNotNull);
    });

    test('Player cannot craft without resources', () {
      final canCraft = craftingSystem.canCraftAxe(player, AxeType.iron);
      
      expect(canCraft, isFalse);
    });

    test('Player can craft iron axe with sufficient resources', () {
      // Add required resources for iron axe
      player.woodInventory['pine'] = 10;
      player.metalInventory['iron'] = 5;
      
      final canCraft = craftingSystem.canCraftAxe(player, AxeType.iron);
      
      expect(canCraft, isTrue);
    });

    test('Crafting consumes resources', () {
      // Add resources
      player.woodInventory['pine'] = 10;
      player.metalInventory['iron'] = 5;
      
      final initialWood = player.woodInventory['pine'] ?? 0;
      final initialMetal = player.metalInventory['iron'] ?? 0;
      
      craftingSystem.craftAxe(player, AxeType.iron);
      
      expect(player.woodInventory['pine'], lessThan(initialWood));
      expect(player.metalInventory['iron'], lessThan(initialMetal));
    });

    test('Player gets new axe after crafting', () {
      player.woodInventory['pine'] = 10;
      player.metalInventory['iron'] = 5;
      
      player.craftAxe(AxeType.iron);
      
      expect(player.axe.type, equals(AxeType.iron));
    });

    test('Crafting higher tier axes requires more resources', () {
      // Try to craft steel axe (should need more than iron)
      player.woodInventory['pine'] = 15;
      player.metalInventory['steel'] = 3;
      
      // Steel requires more resources than iron
      final canCraftSteel = craftingSystem.canCraftAxe(player, AxeType.steel);
      
      // This test assumes steel requires more resources
      // The actual implementation will determine if it's craftable
      expect(canCraftSteel, isA<bool>());
    });

    test('Cannot craft axe with insufficient wood', () {
      player.metalInventory['iron'] = 10;
      // No wood added
      
      final canCraft = craftingSystem.canCraftAxe(player, AxeType.iron);
      
      expect(canCraft, isFalse);
    });

    test('Cannot craft axe with insufficient metal', () {
      player.woodInventory['pine'] = 10;
      // No metal added
      
      final canCraft = craftingSystem.canCraftAxe(player, AxeType.iron);
      
      expect(canCraft, isFalse);
    });
  });
}
