import 'package:vector_math/vector_math.dart';

class Monster {
  final String name;
  final int level;
  int health;
  int maxHealth;
  int damage;
  Vector2 position;
  bool isDead = false;

  Monster(
    this.name, {
    required this.level,
    Vector2? position,
  }) : position = position ?? Vector2.zero() {
    // Calculate stats based on level
    maxHealth = 50 + (level * 10);
    health = maxHealth;
    damage = 5 + (level * 2);
  }

  void takeDamage(int amount) {
    health = (health - amount).clamp(0, maxHealth);
    if (health <= 0) {
      isDead = true;
    }
  }

  void heal(int amount) {
    health = (health + amount).clamp(0, maxHealth);
  }

  String getInfo() {
    return '$name (Level $level) - HP: $health/$maxHealth - Damage: $damage';
  }
}
