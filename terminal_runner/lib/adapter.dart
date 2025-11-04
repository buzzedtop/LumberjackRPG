import 'package:vector_math/vector_math.dart';

enum GameMode { exploration, town, dungeon }

class MiniGameTime {
  int day = 1;
  int hour = 8;
  int minute = 0;
  int totalMinutes = 0;

  void advanceTime(int minutes) {
    minute += minutes;
    totalMinutes += minutes;
    while (minute >= 60) {
      minute -= 60;
      hour++;
    }
    while (hour >= 24) {
      hour -= 24;
      day++;
    }
  }

  String getTimeString() {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return 'Day $day, $displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  bool isNight() => hour < 6 || hour >= 22;
  String getTimeOfDay() {
    if (hour >= 5 && hour < 12) return 'Morning';
    if (hour >= 12 && hour < 17) return 'Afternoon';
    if (hour >= 17 && hour < 21) return 'Evening';
    return 'Night';
  }
}

class MiniTown {
  String name;
  Vector2 position;
  bool hasWell;
  bool wellHasDungeon;
  final Map<String, int> resources = {};
  final Map<String, dynamic> buildings = {};

  MiniTown({required this.name, required this.position, this.hasWell = true, this.wellHasDungeon = true});

  void addResource(String key, int amount) {
    resources.update(key, (v) => v + amount, ifAbsent: () => amount);
  }

  bool constructBuilding(String id, dynamic building) {
    buildings[id] = building;
    return true; // For the runner we accept all constructions
  }

  String getInfo() {
    final buffer = StringBuffer();
    buffer.writeln('Town: $name');
    buffer.writeln('Resources:');
    if (resources.isEmpty) buffer.writeln('  (none)');
    resources.forEach((k, v) => buffer.writeln('  $k: $v'));
    return buffer.toString();
  }
}

class MiniGameMap {
  final int width;
  final int height;
  MiniGameMap(this.width, this.height);
}

class Axe {
  final String type;
  final int damage;
  Axe(this.type, this.damage);
}

class MiniPlayer {
  int level = 1;
  int experience = 0;
  int maxHealth = 100;
  int health = 100;
  Axe axe = Axe('stone', 5);
  final Map<String, int> woodInventory = {};
  final Map<String, int> metalInventory = {};

  void _levelUp() {
    // Increase level, bump max health, and heal to full on level up.
    level += 1;
    maxHealth += 20;
    health = maxHealth;
  }

  void _checkLevelUp() {
    // Allow multiple level-ups if experience exceeds requirements.
    while (experience >= _xpForNextLevel()) {
      experience -= _xpForNextLevel();
      _levelUp();
    }
  }

  int _xpForNextLevel() => level * 100;

  void addExperience(int amount) {
    experience += amount;
    _checkLevelUp();
  }

  void chopWood(String name, int amount) {
    woodInventory.update(name, (v) => v + amount, ifAbsent: () => amount);
    addExperience(10);
  }

  void mineMetal(String name, int amount) {
    metalInventory.update(name, (v) => v + amount, ifAbsent: () => amount);
    addExperience(15);
  }
}

class MiniMonster {
  String name;
  int level;
  int health;
  int maxHealth;
  int damage;
  bool isDead = false;
  MiniMonster(this.name, {this.level = 1}) : maxHealth = 50 + (level * 10), health = 50 + (level * 10), damage = 5 + (level * 2);

  void takeDamage(int amount) {
    health = (health - amount).clamp(0, maxHealth);
    if (health <= 0) isDead = true;
  }
}

class MiniGameState {
  late MiniPlayer player;
  late MiniGameMap gameMap;
  late MiniTown town;
  late MiniGameTime gameTime;
  Vector2 playerPosition = Vector2(50, 50);
  GameMode currentMode = GameMode.exploration;
  int turnCount = 0;

  MiniGameState({int mapSize = 42}) {
    player = MiniPlayer();
    gameMap = MiniGameMap(mapSize, mapSize);
    gameTime = MiniGameTime();
    final townPos = Vector2((mapSize / 2).floorToDouble(), (mapSize / 2).floorToDouble());
    town = MiniTown(name: 'Ironwood Village', position: townPos, hasWell: true, wellHasDungeon: true);
    town.addResource('wood', 100);
    town.addResource('gold', 50);
  }

  void advanceTurn({int timeMinutes = 10}) {
    turnCount++;
    gameTime.advanceTime(timeMinutes);
    if (gameTime.totalMinutes % 360 == 0) {
      // produce resources (no-op for simplicity)
    }
  }

  void movePlayer(int dx, int dy) {
    playerPosition = Vector2(playerPosition.x + (dx * 1), playerPosition.y + (dy * 1));
    advanceTurn(timeMinutes: 10);
  }

  void chopWood() {
    player.chopWood('common_wood', 5);
    advanceTurn(timeMinutes: 30);
  }

  void mineMetal() {
    player.mineMetal('common_ore', 3);
    advanceTurn(timeMinutes: 45);
  }

  bool isInTown() {
    final townX = town.position.x.toInt();
    final townY = town.position.y.toInt();
    final playerX = playerPosition.x.toInt();
    final playerY = playerPosition.y.toInt();
    return (playerX - townX).abs() <= 1 && (playerY - townY).abs() <= 1;
  }

  void enterTown() {
    currentMode = GameMode.town;
  }

  void exitTown() {
    currentMode = GameMode.exploration;
  }

  String getSummary() {
    final buffer = StringBuffer();
    buffer.writeln('╔════════════════════════════════════════════════════════════════════╗');
    buffer.writeln('║              LUMBERJACK RPG - Terminal Edition                     ║');
    buffer.writeln('╚════════════════════════════════════════════════════════════════════╝');
    buffer.writeln('');
    buffer.writeln('Time: ${gameTime.getTimeString()} (${gameTime.getTimeOfDay()})');
    buffer.writeln('Turn: $turnCount');
    buffer.writeln('Mode: ${currentMode.toString().split('.').last}');
    buffer.writeln('Position: (${playerPosition.x.toInt()}, ${playerPosition.y.toInt()})');
    buffer.writeln('');
    buffer.writeln('Player Status:');
    buffer.writeln('  Level: ${player.level}');
    buffer.writeln('  Health: ${player.health}/${player.maxHealth}');
    buffer.writeln('  XP: ${player.experience}/${player.level * 100}');
    buffer.writeln('  Axe: ${player.axe.type} (Damage: ${player.axe.damage})');

    if (gameTime.isNight()) {
      buffer.writeln('');
      buffer.writeln('⚠️  It is night! Monsters are more dangerous.');
    }

    return buffer.toString();
  }
}
