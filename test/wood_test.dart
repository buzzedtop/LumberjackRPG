import 'package:flutter_test/flutter_test.dart';
import 'package:lumberjack_rpg/wood.dart';
import 'package:lumberjack_rpg/constants.dart';

void main() {
  group('Wood Resource Mechanics', () {
    test('Wood initializes with correct properties', () {
      final wood = Wood('balsa', 'forest');
      
      expect(wood.name, equals('balsa'));
      expect(wood.biome, equals('forest'));
      expect(wood.durability, greaterThan(0));
      expect(wood.amount, greaterThan(0));
      expect(wood.isDepleted, isFalse);
    });

    test('Wood durability decreases when chopped', () {
      final wood = Wood('balsa', 'forest');
      final initialDurability = wood.durability;
      
      wood.chop();
      
      expect(wood.durability, lessThan(initialDurability));
    });

    test('Wood becomes depleted after enough chops', () {
      final wood = Wood('balsa', 'forest');
      
      // Chop until depleted
      while (!wood.isDepleted) {
        wood.chop();
      }
      
      expect(wood.isDepleted, isTrue);
      expect(wood.durability, equals(0));
    });

    test('All wood types are defined in constants', () {
      expect(woodTypes, isNotEmpty);
      expect(woodTypes.containsKey('balsa'), isTrue);
      expect(woodTypes.containsKey('cedar'), isTrue);
      expect(woodTypes.containsKey('pine'), isTrue);
    });

    test('Wood types have valid biome associations', () {
      woodTypes.forEach((name, data) {
        expect(data['biome'], isNotNull);
        expect(data['durability'], isNotNull);
        expect(data['amount'], isNotNull);
      });
    });

    test('Different wood types have different durabilities', () {
      final balsa = Wood('balsa', 'forest');
      final snakewood = Wood('snakewood', 'deepCave');
      
      // Snakewood should be much harder to chop than balsa
      expect(balsa.durability, lessThan(snakewood.durability));
    });

    test('Rare woods yield more resources', () {
      final balsa = Wood('balsa', 'forest');
      final snakewood = Wood('snakewood', 'deepCave');
      
      // Rare woods should give more materials
      expect(balsa.amount, lessThanOrEqualTo(snakewood.amount));
    });
  });
}
