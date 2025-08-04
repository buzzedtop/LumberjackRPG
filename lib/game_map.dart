import 'dart:math';
import 'package:flame_noise/flame_noise.dart';
import 'package:vector_math/vector_math.dart';
import 'wood.dart';
import 'metal.dart';
import 'constants.dart';

enum TileType { forest, mountain, cave, deepCave, water, road }

class GameMap {
  final int width;
  final int height;
  late List<List<TileType>> tiles;
  final Map<Vector2, Wood> woodResources = {};
  final Map<Vector2, Metal> metalResources = {};
  final Random random = Random(42);
  final PerlinNoise noise = PerlinNoise(frequency: 0.05, seed: 42);
  Vector2 spawnPoint = Vector2(50, 50); // Default spawn point (center of 100x100 map)

  GameMap(this.width, this.height) {
    _generateMap();
    _placeResources();
  }

  void _generateMap() {
    tiles = List.generate(width, (_) => List.filled(height, TileType.forest));

    // Biome generation with Perlin noise for continuity
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        double noiseValue = noise.noise2(x * 0.1, y * 0.1);
        // Scale noise to create larger, continuous biome clusters
        if (noiseValue < -0.3) {
          tiles[x][y] = TileType.water;
        } else if (noiseValue < -0.1) {
          tiles[x][y] = TileType.deepCave;
        } else if (noiseValue < 0.1) {
          tiles[x][y] = TileType.cave;
        } else if (noiseValue < 0.4) {
          tiles[x][y] = TileType.mountain;
        } else {
          tiles[x][y] = TileType.forest;
        }
      }
    }

    // Generate roads from spawn point
    _generateRoads();
  }

  void _generateRoads() {
    // Start roads from spawn point (rounded to nearest tile)
    Vector2 start = Vector2(spawnPoint.x / 32, spawnPoint.y / 32).floorToDouble();
    if (start.x < 0 || start.x >= width || start.y < 0 || start.y >= height) {
      start = Vector2(width / 2, height / 2).floorToDouble(); // Fallback to center
    }

    // Define key points to connect (e.g., biome centers or resource clusters)
    List<Vector2> keyPoints = _findKeyPoints();

    // Generate roads to each key point
    for (var target in keyPoints) {
      _createRoad(start, target);
    }

    // Set spawn tile to road
    int startX = start.x.toInt();
    int startY = start.y.toInt();
    if (startX >= 0 && startX < width && startY >= 0 && startY < height) {
      tiles[startX][startY] = TileType.road;
    }
  }

  List<Vector2> _findKeyPoints() {
    // Find approximate centers of biome clusters or resource-heavy areas
    List<Vector2> points = [];
    final biomeTypes = [TileType.forest, TileType.mountain, TileType.cave, TileType.deepCave];
    
    for (var biome in biomeTypes) {
      int count = 0;
      double sumX = 0, sumY = 0;
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          if (tiles[x][y] == biome) {
            sumX += x;
            sumY += y;
            count++;
          }
        }
      }
      if (count > 0) {
        points.add(Vector2(sumX / count, sumY / count).floorToDouble());
      }
    }
    
    // Add a few random points for variety
    for (int i = 0; i < 2; i++) {
      points.add(Vector2(
        random.nextInt(width).toDouble(),
        random.nextInt(height).toDouble(),
      ));
    }
    
    return points;
  }

  void _createRoad(Vector2 start, Vector2 target) {
    // Simple pathfinding-like road generation (Manhattan-style with randomness)
    int x = start.x.toInt();
    int y = start.y.toInt();
    int targetX = target.x.toInt();
    int targetY = target.y.toInt();

    while (x != targetX || y != targetY) {
      if (x >= 0 && x < width && y >= 0 && y < height && tiles[x][y] != TileType.water) {
        tiles[x][y] = TileType.road;
      }

      // Move towards target with some randomness
      if (random.nextDouble() < 0.7) {
        // Prefer straight paths
        if (x < targetX) x++;
        else if (x > targetX) x--;
        else if (y < targetY) y++;
        else if (y > targetY) y--;
      } else {
        // Add slight meandering
        if (random.nextBool()) {
          if (x < width - 1) x++;
          else if (x > 0) x--;
        } else {
          if (y < height - 1) y++;
          else if (y > 0) y--;
        }
      }

      // Prevent infinite loops
      if (x < 0 || x >= width || y < 0 || y >= height) break;
    }
  }

  void _placeResources() {
    // Wood resources
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        if (tiles[x][y] == TileType.water || tiles[x][y] == TileType.road) continue;
        if (random.nextDouble() < 0.1) { // 10% chance for a resource
          String biome = tiles[x][y].toString().split('.').last;
          List<String> availableWoods = woodTypes.entries
              .where((entry) => entry.value['biome'] == biome)
              .map((entry) => entry.key)
              .toList();
          if (availableWoods.isNotEmpty) {
            String woodType = availableWoods[random.nextInt(availableWoods.length)];
            woodResources[Vector2(x.toDouble(), y.toDouble())] = Wood(woodType, biome);
          }
        }
      }
    }

    // Metal resources
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        if (tiles[x][y] == TileType.water || tiles[x][y] == TileType.road) continue;
        if (random.nextDouble() < 0.05) { // 5% chance for a metal
          String biome = tiles[x][y].toString().split('.').last;
          List<String> availableMetals = metalTypes.entries
              .where((entry) => entry.value['biome'] == biome)
              .map((entry) => entry.key)
              .toList();
          if (availableMetals.isNotEmpty) {
            String metalType = availableMetals[random.nextInt(availableMetals.length)];
            metalResources[Vector2(x.toDouble(), y.toDouble())] = Metal(metalType, biome);
          }
        }
      }
    }
  }
}
