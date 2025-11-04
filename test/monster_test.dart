import 'package:flutter_test/flutter_test.dart';
import 'package:lumberjack_rpg/monster.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  group('Monster Mechanics', () {
    test('Monster initializes with correct level-based stats', () {
      final monster = Monster('wolf', level: 1);
      
      expect(monster.name, equals('wolf'));
      expect(monster.level, equals(1));
      expect(monster.maxHealth, equals(60)); // 50 + (1 * 10)
      expect(monster.health, equals(monster.maxHealth));
      expect(monster.damage, equals(7)); // 5 + (1 * 2)
      expect(monster.isDead, isFalse);
    });

    test('Higher level monsters have more health and damage', () {
      final monster1 = Monster('wolf', level: 1);
      final monster5 = Monster('bear', level: 5);
      
      expect(monster5.maxHealth, greaterThan(monster1.maxHealth));
      expect(monster5.damage, greaterThan(monster1.damage));
    });

    test('Monster takes damage correctly', () {
      final monster = Monster('wolf', level: 1);
      final initialHealth = monster.health;
      
      monster.takeDamage(20);
      
      expect(monster.health, equals(initialHealth - 20));
    });

    test('Monster health does not go below 0', () {
      final monster = Monster('wolf', level: 1);
      
      monster.takeDamage(1000);
      
      expect(monster.health, equals(0));
    });

    test('Monster dies when health reaches 0', () {
      final monster = Monster('wolf', level: 1);
      
      monster.takeDamage(monster.maxHealth);
      
      expect(monster.isDead, isTrue);
    });

    test('Monster can be healed', () {
      final monster = Monster('wolf', level: 1);
      
      monster.takeDamage(30);
      final damagedHealth = monster.health;
      monster.heal(10);
      
      expect(monster.health, equals(damagedHealth + 10));
    });

    test('Monster health does not exceed max health when healed', () {
      final monster = Monster('wolf', level: 1);
      
      monster.takeDamage(10);
      monster.heal(100);
      
      expect(monster.health, equals(monster.maxHealth));
    });

    test('Monster position can be set', () {
      final position = Vector2(10, 20);
      final monster = Monster('wolf', level: 1, position: position);
      
      expect(monster.position.x, equals(10));
      expect(monster.position.y, equals(20));
    });

    test('Monster info string contains correct information', () {
      final monster = Monster('wolf', level: 1);
      final info = monster.getInfo();
      
      expect(info, contains('wolf'));
      expect(info, contains('Level 1'));
      expect(info, contains('HP:'));
      expect(info, contains('Damage:'));
    });

    test('Monster stats scale properly with level', () {
      for (int level = 1; level <= 10; level++) {
        final monster = Monster('test', level: level);
        
        expect(monster.maxHealth, equals(50 + (level * 10)));
        expect(monster.damage, equals(5 + (level * 2)));
      }
    });

    test('Dead monster cannot be damaged further', () {
      final monster = Monster('wolf', level: 1);
      
      monster.takeDamage(monster.maxHealth);
      expect(monster.isDead, isTrue);
      
      final zeroHealth = monster.health;
      monster.takeDamage(50);
      
      expect(monster.health, equals(zeroHealth));
    });
  });
}
