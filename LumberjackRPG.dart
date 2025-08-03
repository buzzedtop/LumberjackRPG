class LumberjackRPG extends FlameGame with KeyboardHandler, TapDetector {
  late Lumberjack player;
  late GameMap gameMap;
  late SpriteComponent playerSprite;
  List<Monster> monsters = [];
  Vector2 playerPosition = Vector2(50, 50);
  Map<Vector2, SpriteComponent> resourceSprites = {};
  Vector2? targetedResource;
  int hitsOnResource = 0;

  @override
  Future<void> onLoad() async {
    player = Lumberjack();
    gameMap = GameMap(12345);
    monsters = gameMap.generateMonsters(player, gameMap.tiles[50][50], 5);

    playerSprite = SpriteComponent(
      sprite: Sprite(await images.load('player.png')),
      position: playerPosition * 32,
      size: Vector2(32, 32),
    );
    add(playerSprite);

    for (int x = 0; x < gameMap.width; x++) {
      for (int y = 0; y < gameMap.height; y++) {
        String tileImage = gameMap.tiles[x][y] == TileType.forest
            ? 'forest.png'
            : gameMap.tiles[x][y] == TileType.mountain
                ? 'mountain.png'
                : gameMap.tiles[x][y] == TileType.cave
                    ? 'cave.png'
                    : 'deep_cave.png';
        add(SpriteComponent(
          sprite: Sprite(await images.load(tileImage)),
          position: Vector2(x * 32, y * 32),
          size: Vector2(32, 32),
        ));
        Vector2 pos = Vector2(x.toDouble(), y.toDouble());
        if (gameMap.woodResources.containsKey(pos)) {
          Wood wood = gameMap.woodResources[pos]!;
          var sprite = SpriteComponent(
            sprite: Sprite(await images.load('${wood.name.toLowerCase()}.png')),
            position: Vector2(x * 32, y * 32),
            size: Vector2(16, 16),
          );
          add(sprite);
          resourceSprites[pos] = sprite;
        }
        if (gameMap.metalResources.containsKey(pos)) {
          Metal metal = gameMap.metalResources[pos]!;
          var sprite = SpriteComponent(
            sprite: Sprite(await images.load('${metal.name.toLowerCase()}.png')),
            position: Vector2(x * 32, y * 32),
            size: Vector2(16, 16),
          );
          add(sprite);
          resourceSprites[pos] = sprite;
        }
      }
    }

    for (var monster in monsters) {
      add(SpriteComponent(
        sprite: Sprite(await images.load('${monster.name.toLowerCase()}.png')),
        position: Vector2(rand.nextDouble() * 100 * 32, rand.nextDouble() * 100 * 32),
        size: Vector2(32, 32),
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    player.updatePlayTime(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    Vector2 newPosition = playerPosition;
    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      newPosition.y -= 1;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      newPosition.y += 1;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      newPosition.x -= 1;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      newPosition.x += 1;
    } else if (keysPressed.contains(LogicalKeyboardKey.space)) {
      Vector2 pos = Vector2(playerPosition.x, playerPosition.y);
      if (gameMap.woodResources.containsKey(pos) || gameMap.metalResources.containsKey(pos)) {
        targetedResource = pos;
        hitsOnResource++;
        double chopBonus = player.equippedAxe?.chopBonus ?? 0.0;
        int hitsRequired = (gameMap.resourceHitsRequired[pos]! * (1.0 - chopBonus)).round().clamp(1, 10);
        if (hitsOnResource >= hitsRequired) {
          if (gameMap.woodResources.containsKey(pos)) {
            player.addWood(gameMap.woodResources[pos]!, 1);
            gameMap.woodResources.remove(pos);
          } else if (gameMap.metalResources.containsKey(pos)) {
            player.addMetal(gameMap.metalResources[pos]!, 1);
            gameMap.metalResources.remove(pos);
          }
          remove(resourceSprites[pos]!);
          resourceSprites.remove(pos);
          gameMap.resourceHitsRequired.remove(pos);
          targetedResource = null;
          hitsOnResource = 0;
        }
      }
      return true;
    }
    if (gameMap.tiles[newPosition.x.toInt()][newPosition.y.toInt()] != TileType.water) {
      playerPosition = newPosition;
      playerSprite.position = playerPosition * 32;
      targetedResource = null;
      hitsOnResource = 0;
    }
    return true;
  }

  @override
  void onTapDown(TapDownInfo info) {
    Wood? hardestWood = player.woodInventory.keys.isNotEmpty
        ? player.woodInventory.keys.reduce((a, b) => a.jankaHardness > b.jankaHardness ? a : b)
        : null;
    Metal? hardestMetal = player.metalInventory.keys.isNotEmpty
        ? player.metalInventory.keys.reduce((a, b) => a.mohsHardness > b.mohsHardness ? a : b)
        : null;
    if (hardestWood != null && hardestMetal != null) {
      Axe? newAxe = CraftingSystem.craftAxe(player, hardestWood, hardestMetal, AxeType.battleAxe);
      if (newAxe != null) {
        player.equippedAxe = newAxe;
      }
    }
    for (var monster in monsters.toList()) {
      int damage = player.strength + (player.equippedAxe?.damage ?? 0);
      if (player.equippedAxe?.range == 'Short' && player.equippedAxe?.type == AxeType.throwingAxe) {
        player.equippedAxe = null;
      }
      monster.health -= damage;
      if (player.equippedAxe != null) {
        player.equippedAxe = Axe(
          type: player.equippedAxe!.type,
          wood: player.equippedAxe!.wood,
          metal: player.equippedAxe!.metal,
          durability: player.equippedAxe!.durability - 1,
          damage: player.equippedAxe!.damage,
          speed: player.equippedAxe!.speed,
          range: player.equippedAxe!.range,
          chopBonus: player.equippedAxe!.chopBonus,
          craftBonus: player.equippedAxe!.craftBonus,
          weightModifier: player.equippedAxe!.weightModifier,
        );
        if (player.equippedAxe!.durability <= 0) {
          player.equippedAxe = null;
        }
      }
      if (monster.health <= 0) {
        player.gainExperience(monster.xpReward);
        if (monster.name == 'Cave Guardian') {
          gameMap.caveGuardianDefeated = true;
          gameMap.generateWoodResources();
        } else if (monster.name == 'Deep Cave Overlord') {
          gameMap.deepCaveOverlordDefeated = true;
          gameMap.generateMetalResources();
        }
        monsters.remove(monster);
      }
    }
  }
}
