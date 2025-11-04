import 'package:flutter_test/flutter_test.dart';
import 'package:lumberjack_rpg/game_map.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  group('Game Map Generation', () {
    test('Game map initializes with correct dimensions', () {
      final map = GameMap(42, 42);
      
      expect(map.width, equals(42));
      expect(map.height, equals(42));
      expect(map.tiles.length, equals(42));
      expect(map.tiles[0].length, equals(42));
    });

    test('Game map contains various tile types', () {
      final map = GameMap(42, 42);
      
      final tileTypes = <TileType>{};
      for (int x = 0; x < map.width; x++) {
        for (int y = 0; y < map.height; y++) {
          tileTypes.add(map.tiles[x][y]);
        }
      }
      
      // Map should have multiple biome types
      expect(tileTypes.length, greaterThan(1));
    });

    test('Game map places wood resources', () {
      final map = GameMap(42, 42);
      
      expect(map.woodResources.isNotEmpty, isTrue);
    });

    test('Game map places metal resources', () {
      final map = GameMap(42, 42);
      
      expect(map.metalResources.isNotEmpty, isTrue);
    });

    test('Resources are not placed on water tiles', () {
      final map = GameMap(42, 42);
      
      map.woodResources.forEach((pos, wood) {
        final x = pos.x.toInt();
        final y = pos.y.toInt();
        expect(map.tiles[x][y], isNot(equals(TileType.water)));
      });
      
      map.metalResources.forEach((pos, metal) {
        final x = pos.x.toInt();
        final y = pos.y.toInt();
        expect(map.tiles[x][y], isNot(equals(TileType.water)));
      });
    });

    test('Resources are not placed on road tiles', () {
      final map = GameMap(42, 42);
      
      map.woodResources.forEach((pos, wood) {
        final x = pos.x.toInt();
        final y = pos.y.toInt();
        expect(map.tiles[x][y], isNot(equals(TileType.road)));
      });
      
      map.metalResources.forEach((pos, metal) {
        final x = pos.x.toInt();
        final y = pos.y.toInt();
        expect(map.tiles[x][y], isNot(equals(TileType.road)));
      });
    });

    test('Wood resources match their biome', () {
      final map = GameMap(42, 42);
      
      map.woodResources.forEach((pos, wood) {
        final x = pos.x.toInt();
        final y = pos.y.toInt();
        final tileBiome = map.tiles[x][y].toString().split('.').last;
        expect(wood.biome, equals(tileBiome));
      });
    });

    test('Metal resources match their biome', () {
      final map = GameMap(42, 42);
      
      map.metalResources.forEach((pos, metal) {
        final x = pos.x.toInt();
        final y = pos.y.toInt();
        final tileBiome = map.tiles[x][y].toString().split('.').last;
        expect(metal.biome, equals(tileBiome));
      });
    });

    test('Map has spawn point', () {
      final map = GameMap(42, 42);
      
      expect(map.spawnPoint, isNotNull);
      expect(map.spawnPoint.x, greaterThanOrEqualTo(0));
      expect(map.spawnPoint.y, greaterThanOrEqualTo(0));
    });

    test('Map generates roads', () {
      final map = GameMap(42, 42);
      
      int roadCount = 0;
      for (int x = 0; x < map.width; x++) {
        for (int y = 0; y < map.height; y++) {
          if (map.tiles[x][y] == TileType.road) {
            roadCount++;
          }
        }
      }
      
      expect(roadCount, greaterThan(0));
    });

    test('Smaller maps generate correctly', () {
      final map = GameMap(10, 10);
      
      expect(map.width, equals(10));
      expect(map.height, equals(10));
      expect(map.tiles.length, equals(10));
    });

    test('Larger maps generate correctly', () {
      final map = GameMap(100, 100);
      
      expect(map.width, equals(100));
      expect(map.height, equals(100));
      expect(map.tiles.length, equals(100));
    });
  });
}
