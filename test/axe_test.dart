import 'package:flutter_test/flutter_test.dart';
import 'package:lumberjack_rpg/axe.dart';

void main() {
  group('Axe and Weapon Mechanics', () {
    test('Stone axe has correct base damage', () {
      final axe = Axe(AxeType.stone);
      
      expect(axe.type, equals(AxeType.stone));
      expect(axe.damage, equals(10));
    });

    test('All axe types have increasing damage', () {
      final axes = [
        Axe(AxeType.stone),
        Axe(AxeType.iron),
        Axe(AxeType.steel),
        Axe(AxeType.titanium),
        Axe(AxeType.osmium),
      ];
      
      for (int i = 0; i < axes.length - 1; i++) {
        expect(axes[i + 1].damage, greaterThan(axes[i].damage));
      }
    });

    test('Iron axe is stronger than stone', () {
      final stone = Axe(AxeType.stone);
      final iron = Axe(AxeType.iron);
      
      expect(iron.damage, greaterThan(stone.damage));
    });

    test('Steel axe is stronger than iron', () {
      final iron = Axe(AxeType.iron);
      final steel = Axe(AxeType.steel);
      
      expect(steel.damage, greaterThan(iron.damage));
    });

    test('Titanium axe is stronger than steel', () {
      final steel = Axe(AxeType.steel);
      final titanium = Axe(AxeType.titanium);
      
      expect(titanium.damage, greaterThan(steel.damage));
    });

    test('Osmium axe is the strongest', () {
      final osmium = Axe(AxeType.osmium);
      final allOtherAxes = [
        Axe(AxeType.stone),
        Axe(AxeType.iron),
        Axe(AxeType.steel),
        Axe(AxeType.titanium),
      ];
      
      for (final axe in allOtherAxes) {
        expect(osmium.damage, greaterThan(axe.damage));
      }
    });

    test('Axe type enum contains all expected types', () {
      expect(AxeType.values.length, greaterThanOrEqualTo(5));
      expect(AxeType.values.contains(AxeType.stone), isTrue);
      expect(AxeType.values.contains(AxeType.iron), isTrue);
      expect(AxeType.values.contains(AxeType.steel), isTrue);
      expect(AxeType.values.contains(AxeType.titanium), isTrue);
      expect(AxeType.values.contains(AxeType.osmium), isTrue);
    });
  });
}
