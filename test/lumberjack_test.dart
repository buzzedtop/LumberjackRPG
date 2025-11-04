import 'package:flutter_test/flutter_test.dart';
import 'package:lumberjack_rpg/lumberjack.dart';
import 'package:lumberjack_rpg/wood.dart';
import 'package:lumberjack_rpg/metal.dart';
import 'package:lumberjack_rpg/monster.dart';
import 'package:lumberjack_rpg/axe.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  group('Lumberjack Core Mechanics', () {
    late Lumberjack player;

    setUp(() {
      player = Lumberjack();
    });

    test('Lumberjack initializes with correct default values', () {
      expect(player.level, equals(1));
      expect(player.experience, equals(0));
      expect(player.maxHealth, equals(100));
      expect(player.health, equals(100));
      expect(player.axe.type, equals(AxeType.stone));
      expect(player.woodInventory.isEmpty, isTrue);
      expect(player.metalInventory.isEmpty, isTrue);
    });

    test('Lumberjack can chop wood and gain experience', () {
      final wood = Wood('balsa', 'forest');
      
      // Chop wood until depleted
      while (!wood.isDepleted) {
        player.chopWood(wood);
      }
      
      expect(player.woodInventory.containsKey('balsa'), isTrue);
      expect(player.woodInventory['balsa'], greaterThan(0));
      expect(player.experience, equals(10));
    });

    test('Lumberjack can mine metal and gain experience', () {
      final metal = Metal('iron', 'mountain');
      
      // Mine until depleted
      while (!metal.isDepleted) {
        player.mineMetal(metal);
      }
      
      expect(player.metalInventory.containsKey('iron'), isTrue);
      expect(player.metalInventory['iron'], greaterThan(0));
      expect(player.experience, equals(15));
    });

    test('Lumberjack levels up when gaining enough experience', () {
      // Add enough experience to level up (100 XP needed for level 2)
      for (int i = 0; i < 10; i++) {
        final wood = Wood('balsa', 'forest');
        while (!wood.isDepleted) {
          player.chopWood(wood);
        }
      }
      
      expect(player.level, greaterThan(1));
      expect(player.maxHealth, greaterThan(100));
    });

    test('Lumberjack takes damage in combat', () {
      final initialHealth = player.health;
      player.takeDamage(20);
      
      expect(player.health, equals(initialHealth - 20));
      expect(player.health, greaterThanOrEqualTo(0));
    });

    test('Lumberjack health does not go below 0', () {
      player.takeDamage(200);
      expect(player.health, equals(0));
    });

    test('Lumberjack can attack monsters', () {
      final monster = Monster('wolf', level: 1);
      final initialMonsterHealth = monster.health;
      
      player.attack(monster);
      
      expect(monster.health, lessThan(initialMonsterHealth));
    });

    test('Lumberjack gains XP from defeating monsters', () {
      final monster = Monster('wolf', level: 1);
      final initialXP = player.experience;
      
      // Attack until monster is dead
      while (!monster.isDead) {
        player.attack(monster);
      }
      
      expect(player.experience, greaterThan(initialXP));
    });

    test('Lumberjack receives counter-attack damage', () {
      final monster = Monster('wolf', level: 1);
      final initialHealth = player.health;
      
      player.attack(monster);
      
      if (!monster.isDead) {
        expect(player.health, lessThan(initialHealth));
      }
    });

    test('Level up increases max health and heals player', () {
      final initialMaxHealth = player.maxHealth;
      
      // Damage player first
      player.takeDamage(50);
      final damagedHealth = player.health;
      
      // Force level up
      player.experience = 100;
      player.checkLevelUp();
      
      expect(player.level, equals(2));
      expect(player.maxHealth, greaterThan(initialMaxHealth));
      expect(player.health, equals(player.maxHealth)); // Should be fully healed
    });

    test('Multiple wood resources accumulate in inventory', () {
      final wood1 = Wood('balsa', 'forest');
      final wood2 = Wood('balsa', 'forest');
      
      while (!wood1.isDepleted) {
        player.chopWood(wood1);
      }
      
      final firstAmount = player.woodInventory['balsa'] ?? 0;
      
      while (!wood2.isDepleted) {
        player.chopWood(wood2);
      }
      
      expect(player.woodInventory['balsa'], equals(firstAmount + wood2.amount));
    });

    test('Different wood types are tracked separately', () {
      final balsa = Wood('balsa', 'forest');
      final cedar = Wood('cedar', 'forest');
      
      while (!balsa.isDepleted) {
        player.chopWood(balsa);
      }
      while (!cedar.isDepleted) {
        player.chopWood(cedar);
      }
      
      expect(player.woodInventory.containsKey('balsa'), isTrue);
      expect(player.woodInventory.containsKey('cedar'), isTrue);
      expect(player.woodInventory['balsa'], isNot(equals(player.woodInventory['cedar'])));
    });
  });
}
