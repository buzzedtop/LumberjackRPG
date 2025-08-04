import 'dart:math';
import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_noise/flame_noise.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'lumberjack.dart';
import 'game_map.dart';
import 'monster.dart';

class LumberjackRPG extends FlameGame with TapDetector, KeyboardEvents {
  late Lumberjack player;
  late GameMap gameMap;
  final List<Monster> monsters = [];
  Vector2 playerPosition = Vector2(50, 50);
  bool isAttacking = false;
  bool isChopping = false;
  bool isMining = false;
  final Random random = Random(42);
  final PerlinNoise noise = PerlinNoise(frequency: 0.1, seed: 42);

  // Toggle between pre-generated and runtime-generated assets
  static const bool usePreGeneratedAssets = false; // Runtime generation

  // Cache for generated images
  final Map<String, ui.Image> _imageCache = {};

  @override
  Future<void> onLoad() async {
    player = Lumberjack();
    gameMap = GameMap(42);

    // Generate player sprite
    final playerImage = await _generateEntityImage('player');
    add(SpriteComponent.fromImage(
      playerImage,
      position: playerPosition,
      size: Vector2(32, 32),
    ));

    // Map tiles
    final tileTypes = {
      TileType.forest: 'forest',
      TileType.mountain: 'mountain',
      TileType.cave: 'cave',
      TileType.deepCave: 'deep_cave',
      TileType.water: 'water',
      TileType.road: 'road',
    };
    final mapColors = {
      'forest': img.ColorRgb8(34, 139, 34),
      'mountain': img.ColorRgb8(128, 128, 128),
      'cave': img.ColorRgb8(105, 105, 105),
      'deep_cave': img.ColorRgb8(47, 79, 79),
      'water': img.ColorRgb8(0, 105, 148),
      'road': img.ColorRgb8(139, 69, 19), // Brown for dirt roads
    };
    for (int x = 0; x < gameMap.width; x++) {
      for (int y = 0; y < gameMap.height; y++) {
        String biome = tileTypes[gameMap.tiles[x][y]]!;
        int subX = (x % 2);
        int subY = (y % 2);
        String key = '${biome}_${subX}_${subY}';
        ui.Image tileImage;
        if (!_imageCache.containsKey(key)) {
          final mapImage = _generateMapImage(biome, mapColors[biome]!);
          final subImage = img.copyCrop(mapImage, subX * 32, subY * 32, 32, 32);
          _imageCache[key] = await _convertToUiImage(subImage);
        }
        tileImage = _imageCache[key]!;
        add(SpriteComponent.fromImage(
          tileImage,
          position: Vector2(x * 32.0, y * 32.0),
          size: Vector2(32, 32),
        ));
      }
    }

    // Generate wood resources
    gameMap.woodResources.forEach((pos, wood) async {
      final name = wood.name.toLowerCase().replaceAll(' ', '_');
      final image = await _generateResourceImage(name, wood.biome);
      add(SpriteComponent.fromImage(
        image,
        position: pos * 32,
        size: Vector2(16, 16),
      ));
    });

    // Generate metal resources
    gameMap.metalResources.forEach((pos, metal) async {
      final name = metal.name.toLowerCase();
      final image = await _generateResourceImage(name, metal.biome);
      add(SpriteComponent.fromImage(
        image,
        position: pos * 32,
        size: Vector2(16, 16),
      ));
    });

    // Spawn initial monsters
    await spawnMonsters();
  }

  // Generate map tile (64x64)
  img.Image _generateMapImage(String name, img.ColorRgb8 color) {
    final image = img.Image(width: 64, height: 64);
    img.fill(image, color: img.ColorRgb8(0, 0, 0, 0));
    if (name == 'forest') {
      img.fillRect(image, 0, 0, 63, 63, color);
      _addPerlinNoise(image, color, 0.05);
      img.fillCircle(image, 20, 20, 8, img.ColorRgb8(0, 100, 0));
      img.fillCircle(image, 44, 28, 10, img.ColorRgb8(0, 100, 0));
      img.fillRect(image, 20, 24, 20, 28, img.ColorRgb8(139, 69, 19));
      img.fillRect(image, 44, 32, 44, 36, img.ColorRgb8(139, 69, 19));
      img.drawRect(image, 0, 0, 63, 63, img.ColorRgb8(20, 80, 20));
    } else if (name == 'mountain') {
      img.fillRect(image, 0, 0, 63, 63, color);
      _addPerlinNoise(image, color, 0.1);
      img.fillTriangle(image, 16, 48, 32, 16, 48, 48, img.ColorRgb8(100, 100, 100));
      img.drawLine(image, 20, 50, 44, 50, img.ColorRgb8(80, 80, 80));
    } else if (name == 'cave') {
      img.fillRect(image, 0, 0, 63, 63, color);
      _addPerlinNoise(image, color, 0.08);
      img.drawCircle(image, 32, 32, 16, img.ColorRgb8(80, 80, 80));
      img.fillRect(image, 28, 40, 36, 44, img.ColorRgb8(60, 60, 60));
    } else if (name == 'deep_cave') {
      img.fillRect(image, 0, 0, 63, 63, color);
      _addPerlinNoise(image, color, 0.08);
      img.drawCircle(image, 32, 32, 20, img.ColorRgb8(60, 60, 60));
      img.drawPixel(image, 32, 32, img.ColorRgb8(255, 255, 255));
    } else if (name == 'water') {
      img.fillRect(image, 0, 0, 63, 63, color);
      _addPerlinNoise(image, color, 0.05);
      img.drawLine(image, 16, 20, 48, 20, img.ColorRgb8(0, 150, 200));
      img.drawLine(image, 12, 28, 52, 28, img.ColorRgb8(0, 150, 200));
      img.drawRect(image, 0, 0, 63, 63, img.ColorRgb8(0, 80, 120));
    } else if (name == 'road') {
      img.fillRect(image, 0, 0, 63, 63, color);
      _addPerlinNoise(image, color, 0.05);
      img.drawLine(image, 16, 0, 16, 63, img.ColorRgb8(100, 50, 10));
      img.drawLine(image, 48, 0, 48, 63, img.ColorRgb8(100, 50, 10));
      img.drawRect(image, 0, 0, 63, 63, img.ColorRgb8(80, 40, 10));
    }
    return image;
  }

  // Generate resource image (16x16)
  Future<ui.Image> _generateResourceImage(String name, String biome) async {
    final woodColors = {
      'balsa': img.ColorRgb8(245, 245, 220),
      'cedar': img.ColorRgb8(205, 133, 63),
      'pine': img.ColorRgb8(210, 180, 140),
      'walnut': img.ColorRgb8(92, 64, 51),
      'oak': img.ColorRgb8(143, 101, 35),
      'maple': img.ColorRgb8(210, 180, 140),
      'mahogany': img.ColorRgb8(139, 69, 19),
      'hickory': img.ColorRgb8(160, 82, 45),
      'wenge': img.ColorRgb8(56, 44, 36),
      'ipe': img.ColorRgb8(72, 60, 50),
      'black_ironwood': img.ColorRgb8(30, 30, 30),
      'lignum_vitae': img.ColorRgb8(46, 39, 32),
      'australian_buloke': img.ColorRgb8(40, 30, 20),
      'quebracho': img.ColorRgb8(100, 50, 30),
      'snakewood': img.ColorRgb8(80, 40, 20),
    };
    final metalColors = {
      'iron': img.ColorRgb8(169, 169, 169),
      'steel': img.ColorRgb8(192, 192, 192),
      'titanium': img.ColorRgb8(135, 135, 135),
      'vanadium': img.ColorRgb8(150, 150, 150),
      'tungsten': img.ColorRgb8(100, 100, 100),
      'osmium': img.ColorRgb8(80, 80, 120),
      'iridium': img.ColorRgb8(175, 175, 175),
      'chromium': img.ColorRgb8(200, 200, 200),
    };

    final image = img.Image(width: 16, height: 16);
    img.fill(image, color: img.ColorRgb8(0, 0, 0, 0));
    if (woodColors.containsKey(name)) {
      var color = woodColors[name]!;
      if (biome == 'cave' || biome == 'deep_cave') {
        color = img.ColorRgb8(
          (color.r * 0.7).round(),
          (color.g * 0.7).round(),
          (color.b * 0.7).round(),
        );
      }
      img.fillRect(image, 6, 10, 9, 14, img.ColorRgb8(139, 69, 19));
      img.fillCircle(image, 7, 6, 4, color);
      _addPerlinNoise(image, color, 0.2);
      _drawPixelText(image, name[0].toUpperCase(), 2, 2, img.ColorRgb8(255, 255, 255));
      img.drawRect(image, 5, 5, 10, 14, img.ColorRgb8(50, 50, 50));
    } else if (metalColors.containsKey(name)) {
      var color = metalColors[name]!;
      if (biome == 'cave' || biome == 'deep_cave') {
        color = img.ColorRgb8(
          (color.r * 0.8).round(),
          (color.g * 0.8).round(),
          (color.b * 0.8).round(),
        );
      }
      img.fillPolygon(image, [4, 4, 12, 4, 10, 10, 6, 10], color);
      _addPerlinNoise(image, color, 0.2);
      img.drawPixel(image, 5, 5, img.ColorRgb8(255, 255, 255));
      _drawPixelText(image, name[0].toUpperCase(), 2, 2, img.ColorRgb8(255, 255, 255));
      img.drawPolygon(image, [4, 4, 12, 4, 10, 10, 6, 10], img.ColorRgb8(50, 50, 50));
    }
    return _convertToUiImage(image);
  }

  // Generate entity image (32x32)
  Future<ui.Image> _generateEntityImage(String name) async {
    final entityColors = {
      'player': img.ColorRgb8(0, 128, 0),
      'wolf': img.ColorRgb8(128, 128, 128),
      'boar': img.ColorRgb8(139, 69, 19),
      'bandit': img.ColorRgb8(255, 0, 0),
      'bear': img.ColorRgb8(101, 67, 33),
      'mountain_troll': img.ColorRgb8(85, 107, 47),
      'golem': img.ColorRgb8(112, 128, 144),
      'goblin': img.ColorRgb8(0, 100, 0),
      'cave_troll': img.ColorRgb8(70, 90, 70),
      'cave_guardian': img.ColorRgb8(50, 50, 50),
      'dragon': img.ColorRgb8(178, 34, 34),
      'abyssal_fiend': img.ColorRgb8(75, 0, 130),
      'deep_cave_overlord': img.ColorRgb8(25, 25, 112),
    };

    final image = img.Image(width: 32, height: 32);
    img.fill(image, color: img.ColorRgb8(0, 0, 0, 0));
    final color = entityColors[name]!;
    if (name == 'player') {
      img.fillCircle(image, 16, 8, 4, color);
      img.fillRect(image, 12, 12, 19, 24, color);
      img.drawLine(image, 20, 12, 24, 16, img.ColorRgb8(100, 100, 100));
      _addPerlinNoise(image, color, 0.1);
      img.drawRect(image, 12, 12, 19, 24, img.ColorRgb8(50, 50, 50));
    } else if (name == 'bandit') {
      img.fillCircle(image, 16, 8, 4, color);
      img.fillRect(image, 12, 12, 19, 24, color);
      img.drawLine(image, 20, 12, 24, 12, img.ColorRgb8(0, 0, 0));
      _addPerlinNoise(image, color, 0.1);
      img.drawRect(image, 12, 12, 19, 24, img.ColorRgb8(50, 50, 50));
    } else if (['wolf', 'boar', 'bear'].contains(name)) {
      img.fillRect(image, 8, 12, 23, 20, color);
      img.fillCircle(image, 10, 10, 3, color);
      img.drawPixel(image, 8, 8, img.ColorRgb8(255, 255, 255));
      _addPerlinNoise(image, color, 0.1);
      img.drawRect(image, 8, 12, 23, 20, img.ColorRgb8(50, 50, 50));
    } else if (name == 'dragon') {
      img.fillRect(image, 10, 14, 22, 22, color);
      img.drawLine(image, 8, 12, 10, 10, color);
      img.drawLine(image, 24, 12, 22, 10, color);
      img.fillCircle(image, 10, 10, 4, color);
      _addPerlinNoise(image, color, 0.1);
      img.drawRect(image, 10, 14, 22, 22, img.ColorRgb8(50, 50, 50));
    } else if (['cave_guardian', 'deep_cave_overlord'].contains(name)) {
      img.fillCircle(image, 16, 16, 12, color);
      img.fillCircle(image, 16, 8, 6, color);
      img.drawPixel(image, 14, 6, img.ColorRgb8(255, 255, 255));
      _addPerlinNoise(image, color, 0.1);
      img.drawCircle(image, 16, 16, 12, img.ColorRgb8(50, 50, 50));
    } else {
      img.fillRect(image, 10, 10, 21, 21, color);
      img.fillCircle(image, 12, 8, 4, color);
      img.drawPixel(image, 10, 6, img.ColorRgb8(255, 255, 255));
      _addPerlinNoise(image, color, 0.1);
      img.drawRect(image, 10, 10, 21, 21, img.ColorRgb8(50, 50, 50));
    }
    return _convertToUiImage(image);
  }

  // Helper to add Perlin noise
  void _addPerlinNoise(img.Image image, img.ColorRgb8 baseColor, double scale) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        if (image.getPixel(x, y).a == 0) continue;
        double n = noise.noise2(x * scale, y * scale) * 20;
        int r = (baseColor.r + n).clamp(0, 255).round();
        int g = (baseColor.g + n).clamp(0, 255).round();
        int b = (baseColor.b + n).clamp(0, 255).round();
        if ((x + y) % 2 == 0 || random.nextDouble() > 0.5) {
          image.setPixelRgba(x, y, r, g, b, image.getPixel(x, y).a);
        }
      }
    }
  }

  // Helper for pixel-art text
  void _drawPixelText(img.Image image, String text, int x, int y, img.ColorRgb8 color) {
    img.drawString(image, text, img.arial_14, x, y, color);
    for (int sy = y; sy < y + 14 && sy < image.height; sy++) {
      for (int sx = x; sx < x + 10 && sx < image.width; sx++) {
        if (image.getPixel(sx, sy).a > 0) {
          image.setPixelRgba(sx, sy, color.r, color.g, color.b, color.a);
        }
      }
    }
  }

  // Convert img.Image to ui.Image for Flame
  Future<ui.Image> _convertToUiImage(img.Image image) async {
    final byteData = await img.encodePng(image).buffer.asByteData();
    final codec = await ui.instantiateImageCodec(byteData);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  Future<void> spawnMonsters() async {
    // Clear existing monsters
    monsters.clear();
    removeWhere((component) => component is SpriteComponent && component != children.firstWhere((c) => c is SpriteComponent && c.position == playerPosition));

    // Define monster spawn chances by biome
    final monsterSpawnChances = {
      TileType.forest: [
        {'name': 'wolf', 'chance': 0.4, 'level': 1},
        {'name': 'boar', 'chance': 0.3, 'level': 2},
        {'name': 'bandit', 'chance': 0.2, 'level': 3},
        {'name': 'bear', 'chance': 0.1, 'level': 4},
      ],
      TileType.mountain: [
        {'name': 'mountain_troll', 'chance': 0.5, 'level': 5},
        {'name': 'golem', 'chance': 0.3, 'level': 6},
        {'name': 'bandit', 'chance': 0.2, 'level': 3},
      ],
      TileType.cave: [
        {'name': 'goblin', 'chance': 0.4, 'level': 7},
        {'name': 'cave_troll', 'chance': 0.3, 'level': 8},
        {'name': 'cave_guardian', 'chance': 0.2, 'level': 9},
      ],
      TileType.deepCave: [
        {'name': 'dragon', 'chance': 0.3, 'level': 10},
        {'name': 'abyssal_fiend', 'chance': 0.4, 'level': 11},
        {'name': 'deep_cave_overlord', 'chance': 0.3, 'level': 12},
      ],
      TileType.water: [],
      TileType.road: [], // No monsters on roads
    };

    // Spawn monsters
    for (int x = 0; x < gameMap.width; x++) {
      for (int y = 0; y < gameMap.height; y++) {
        if (random.nextDouble() < 0.05) { // 5% chance to spawn a monster
          final tileType = gameMap.tiles[x][y];
          final spawnChances = monsterSpawnChances[tileType]!;
          if (spawnChances.isEmpty) continue;

          double roll = random.nextDouble();
          double cumulative = 0.0;
          for (var monsterData in spawnChances) {
            cumulative += monsterData['chance'] as double;
            if (roll <= cumulative) {
              final monsterName = monsterData['name'] as String;
              final monsterLevel = monsterData['level'] as int;
              final monster = Monster(monsterName, level: monsterLevel);
              monsters.add(monster);

              // Generate monster sprite
              final monsterImage = await _generateEntityImage(monsterName);
              add(SpriteComponent.fromImage(
                monsterImage,
                position: Vector2(x * 32.0, y * 32.0),
                size: Vector2(32, 32),
              ));
              break;
            }
          }
        }
      }
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    final tapPosition = info.eventPosition.game;
    final targetTile = (tapPosition / 32).floor();
    final dx = (targetTile.x - playerPosition.x).abs();
    final dy = (targetTile.y - playerPosition.y).abs();

    if (dx <= 1 && dy <= 1 && (dx + dy) > 0) {
      final targetPos = Vector2(targetTile.x * 32, targetTile.y * 32);

      // Check for monsters
      final monster = monsters.firstWhereOrNull(
        (m) => m.position.x == targetTile.x && m.position.y == targetTile.y,
      );
      if (monster != null) {
        isAttacking = true;
        player.attack(monster);
        if (monster.isDead) {
          monsters.remove(monster);
          removeWhere((component) => component is SpriteComponent && component.position == targetPos);
        }
        return;
      }

      // Check for wood resources
      final wood = gameMap.woodResources[Vector2(targetTile.x, targetTile.y)];
      if (wood != null) {
        isChopping = true;
        player.chopWood(wood);
        if (wood.isDepleted) {
          gameMap.woodResources.remove(Vector2(targetTile.x, targetTile.y));
          removeWhere((component) => component is SpriteComponent && component.position == targetPos && component.size == Vector2(16, 16));
        }
        return;
      }

      // Check for metal resources
      final metal = gameMap.metalResources[Vector2(targetTile.x, targetTile.y)];
      if (metal != null) {
        isMining = true;
        player.mineMetal(metal);
        if (metal.isDepleted) {
          gameMap.metalResources.remove(Vector2(targetTile.x, targetTile.y));
          removeWhere((component) => component is SpriteComponent && component.position == targetPos && component.size == Vector2(16, 16));
        }
        return;
      }

      // Move player if tile is not water
      if (gameMap.tiles[targetTile.x.toInt()][targetTile.y.toInt()] != TileType.water) {
        playerPosition = Vector2(targetTile.x * 32, targetTile.y * 32);
        final playerComponent = children.firstWhere((c) => c is SpriteComponent && c.position == playerPosition) as SpriteComponent;
        playerComponent.position = playerPosition;
      }
    }
  }

  @override
  void onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;
    if (!isKeyDown) return;

    Vector2? newPosition;
    if (keysPressed.contains(LogicalKeyboardKey.keyW) || keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      newPosition = Vector2(playerPosition.x, playerPosition.y - 32);
    } else if (keysPressed.contains(LogicalKeyboardKey.keyS) || keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      newPosition = Vector2(playerPosition.x, playerPosition.y + 32);
    } else if (keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      newPosition = Vector2(playerPosition.x - 32, playerPosition.y);
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      newPosition = Vector2(playerPosition.x + 32, playerPosition.y);
    }

    if (newPosition != null) {
      final targetTile = (newPosition / 32).floor();
      if (targetTile.x >= 0 &&
          targetTile.x < gameMap.width &&
          targetTile.y >= 0 &&
          targetTile.y < gameMap.height &&
          gameMap.tiles[targetTile.x.toInt()][targetTile.y.toInt()] != TileType.water) {
        playerPosition = newPosition;
        final playerComponent = children.firstWhere((c) => c is SpriteComponent && c.position == playerPosition) as SpriteComponent;
        playerComponent.position = playerPosition;
      }
    }

    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      final adjacentTiles = [
        Vector2(playerPosition.x + 32, playerPosition.y),
        Vector2(playerPosition.x - 32, playerPosition.y),
        Vector2(playerPosition.x, playerPosition.y + 32),
        Vector2(playerPosition.x, playerPosition.y - 32),
      ];

      for (var pos in adjacentTiles) {
        final targetTile = (pos / 32).floor();
        if (targetTile.x < 0 || targetTile.x >= gameMap.width || targetTile.y < 0 || targetTile.y >= gameMap.height) {
          continue;
        }

        final monster = monsters.firstWhereOrNull(
          (m) => m.position.x == targetTile.x && m.position.y == targetTile.y,
        );
        if (monster != null) {
          isAttacking = true;
          player.attack(monster);
          if (monster.isDead) {
            monsters.remove(monster);
            removeWhere((component) => component is SpriteComponent && component.position == pos);
          }
          return;
        }

        final wood = gameMap.woodResources[Vector2(targetTile.x, targetTile.y)];
        if (wood != null) {
          isChopping = true;
          player.chopWood(wood);
          if (wood.isDepleted) {
            gameMap.woodResources.remove(Vector2(targetTile.x, targetTile.y));
            removeWhere((component) => component is SpriteComponent && component.position == pos && component.size == Vector2(16, 16));
          }
          return;
        }

        final metal = gameMap.metalResources[Vector2(targetTile.x, targetTile.y)];
        if (metal != null) {
          isMining = true;
          player.mineMetal(metal);
          if (metal.isDepleted) {
            gameMap.metalResources.remove(Vector2(targetTile.x, targetTile.y));
            removeWhere((component) => component is SpriteComponent && component.position == pos && component.size == Vector2(16, 16));
          }
          return;
        }
      }
    }
  }
}

// Extension to allow null-safe firstWhere
extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}