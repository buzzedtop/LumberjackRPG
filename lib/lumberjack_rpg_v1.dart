import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'lumberjack.dart';
import 'game_map.dart';
import 'crafting_system.dart';
import 'monster.dart';
import 'wood.dart';
import 'metal.dart';
import 'axe.dart';

class LumberjackRPG extends FlameGame with TapDetector, KeyboardEvents {
  late Lumberjack player;
  late GameMap gameMap;
  final List<Monster> monsters = [];
  Vector2 playerPosition = Vector2(50, 50);
  bool isAttacking = false;
  bool isChopping = false;
  bool isMining = false;

  @override
  Future<void> onLoad() async {
    player = Lumberjack();
    gameMap = GameMap(42); // Fixed seed for consistent map generation
    add(SpriteComponent.fromImage(
      await images.load('player.png'),
      position: playerPosition,
      size: Vector2(32, 32),
    ));

    // Load map tiles
    for (int x = 0; x < gameMap.width; x++) {
      for (int y = 0; y < gameMap.height; y++) {
        String asset;
        switch (gameMap.tiles[x][y]) {
          case TileType.forest:
            asset = 'forest.png';
            break;
          case TileType.mountain:
            asset = 'mountain.png';
            break;
          case TileType.cave:
            asset = 'cave.png';
            break;
          case TileType.deepCave:
            asset = 'deep_cave.png';
            break;
          case TileType.water:
            asset = 'water.png';
            break;
        }
        add(SpriteComponent.fromImage(
          await images.load(asset),
          position: Vector2(x * 32.0, y * 32.0),
          size: Vector2(32, 32),
        ));
      }
    }

    // Load resources
    gameMap.woodResources.forEach((pos, wood) {
      add(SpriteComponent.fromImage(
        await images.load('${wood.name.toLowerCase().replaceAll(' ', '_')}.png'),
        position: pos * 32,
        size: Vector2(16, 16),
      ));
    });
    gameMap.metalResources.forEach((pos, metal) {
      add(SpriteComponent.fromImage(
        await images.load('${metal.name.toLowerCase()}.png'),
        position: pos * 32,
        size: Vector2(16, 16),
      ));
    });

    // Spawn initial monsters
    spawnMonsters();
  }

  void spawnMonsters() {
    TileType currentBiome = gameMap.tiles[playerPosition.x.toInt()][playerPosition.y.toInt()];
    monsters.addAll(gameMap.generateMonsters(player, currentBiome, 5));
    for (var monster in monsters) {
      add(SpriteComponent.fromImage(
        images.fromCache('${monster.name.toLowerCase().replaceAll(' ', '_')}.png'),
        position: Vector2(
          playerPosition.x + (Random().nextDouble() - 0.5) * 100,
          playerPosition.y + (Random().nextDouble() - 0.5) * 100,
        ),
        size: Vector2(32, 32),
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    player.updatePlayTime(dt);

    // Handle resource interactions
    Vector2 playerTile = playerPosition ~/ 32;
    if (isChopping && gameMap.woodResources.containsKey(playerTile)) {
      Wood wood = gameMap.woodResources[playerTile]!;
      int hitsRequired = gameMap.resourceHitsRequired[playerTile]!;
      if (player.equippedAxe != null) {
        hitsRequired -= (player.strength * (1 + player.equippedAxe!.chopBonus)).round();
        if (hitsRequired <= 0) {
          player.addWood(wood, 1);
          gameMap.woodResources.remove(playerTile);
          gameMap.resourceHitsRequired.remove(playerTile);
          removeAll(children.where((c) => c is SpriteComponent && c.position ~/ 32 == playerTile));
        } else {
          gameMap.resourceHitsRequired[playerTile] = hitsRequired;
        }
      }
    }
    if (isMining && gameMap.metalResources.containsKey(playerTile)) {
      Metal metal = gameMap.metalResources[playerTile]!;
      int hitsRequired = gameMap.resourceHitsRequired[playerTile]!;
      if (player.equippedAxe != null) {
        hitsRequired -= (player.strength * (1 + player.equippedAxe!.chopBonus)).round();
        if (hitsRequired <= 0) {
          player.addMetal(metal, 1);
          gameMap.metalResources.remove(playerTile);
          gameMap.resourceHitsRequired.remove(playerTile);
          removeAll(children.where((c) => c is SpriteComponent && c.position ~/ 32 == playerTile));
        } else {
          gameMap.resourceHitsRequired[playerTile] = hitsRequired;
        }
      }
    }

    // Handle combat
    if (isAttacking) {
      for (var monster in monsters) {
        if ((monster.position - playerPosition).length < 32) {
          int damage = player.equippedAxe?.damage ?? player.strength;
          monster.health -= damage;
          if (monster.health <= 0) {
            player.gainExperience(monster.xpReward);
            monsters.remove(monster);
            removeAll(children.where((c) => c is SpriteComponent && c.position == monster.position));
            if (monster.name == 'Cave Guardian') {
              gameMap.caveGuardianDefeated = true;
            } else if (monster.name == 'Deep Cave Overlord') {
              gameMap.deepCaveOverlordDefeated = true;
            }
          }
        }
      }
    }

    // Respawn monsters if needed
    if (monsters.length < 5) {
      spawnMonsters();
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    Vector2 tapTile = info.eventPosition.game ~/ 32;
    if (gameMap.woodResources.containsKey(tapTile)) {
      isChopping = true;
      isMining = false;
      isAttacking = false;
    } else if (gameMap.metalResources.containsKey(tapTile)) {
      isMining = true;
      isChopping = false;
      isAttacking = false;
    } else {
      isAttacking = true;
      isChopping = false;
      isMining = false;
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    isChopping = false;
    isMining = false;
    isAttacking = false;
  }

  void craftAxe(Wood wood, Metal metal, AxeType type) {
    Axe? newAxe = CraftingSystem.craftAxe(player, wood, metal, type);
    if (newAxe != null) {
      player.equippedAxe = newAxe;
    }
  }
}
