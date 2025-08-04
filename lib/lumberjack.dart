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
  static const bool usePreGeneratedAssets = false; // Changed to runtime generation

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
      img.drawRect(image, 0, 0, 63, 63, img.ColorRgb8(0, 80,