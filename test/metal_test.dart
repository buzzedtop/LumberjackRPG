import 'package:flutter_test/flutter_test.dart';
import 'package:lumberjack_rpg/metal.dart';
import 'package:lumberjack_rpg/constants.dart';

void main() {
  group('Metal Resource Mechanics', () {
    test('Metal initializes with correct properties', () {
      final metal = Metal('iron', 'mountain');
      
      expect(metal.name, equals('iron'));
      expect(metal.biome, equals('mountain'));
      expect(metal.durability, greaterThan(0));
      expect(metal.amount, greaterThan(0));
      expect(metal.isDepleted, isFalse);
    });

    test('Metal durability decreases when mined', () {
      final metal = Metal('iron', 'mountain');
      final initialDurability = metal.durability;
      
      metal.mine();
      
      expect(metal.durability, lessThan(initialDurability));
    });

    test('Metal becomes depleted after enough mining', () {
      final metal = Metal('iron', 'mountain');
      
      // Mine until depleted
      while (!metal.isDepleted) {
        metal.mine();
      }
      
      expect(metal.isDepleted, isTrue);
      expect(metal.durability, equals(0));
    });

    test('All metal types are defined in constants', () {
      expect(metalTypes, isNotEmpty);
      expect(metalTypes.containsKey('iron'), isTrue);
      expect(metalTypes.containsKey('steel'), isTrue);
      expect(metalTypes.containsKey('titanium'), isTrue);
    });

    test('Metal types have valid biome associations', () {
      metalTypes.forEach((name, data) {
        expect(data['biome'], isNotNull);
        expect(data['durability'], isNotNull);
        expect(data['amount'], isNotNull);
      });
    });

    test('Different metal types have different durabilities', () {
      final iron = Metal('iron', 'mountain');
      final osmium = Metal('osmium', 'deepCave');
      
      // Osmium should be much harder to mine than iron
      expect(iron.durability, lessThan(osmium.durability));
    });

    test('Rare metals yield more resources', () {
      final iron = Metal('iron', 'mountain');
      final osmium = Metal('osmium', 'deepCave');
      
      // Rare metals should give more materials
      expect(iron.amount, lessThanOrEqualTo(osmium.amount));
    });

    test('Mining metal does not go below zero durability', () {
      final metal = Metal('iron', 'mountain');
      
      // Mine many times
      for (int i = 0; i < 100; i++) {
        metal.mine();
      }
      
      expect(metal.durability, equals(0));
      expect(metal.isDepleted, isTrue);
    });
  });
}
