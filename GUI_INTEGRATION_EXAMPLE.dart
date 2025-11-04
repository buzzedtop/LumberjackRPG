// Example: Integrating GameState with Flutter/Flame GUI
// This file demonstrates how to use the new GameState class
// with the existing Flutter/Flame visualization

import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'lib/game_state.dart';
import 'lib/building.dart';

// Example 1: Simple integration - using GameState with existing rendering
class EnhancedLumberjackRPG extends FlameGame {
  late GameState gameState;
  
  @override
  Future<void> onLoad() async {
    // Create game state instead of managing entities separately
    gameState = GameState(mapSize: 42);
    
    // Render the map (same as before)
    await _renderMap();
    
    // NEW: Render town
    await _renderTown();
    
    // NEW: Render town buildings
    await _renderBuildings();
    
    // Render player (using gameState.player instead of separate player)
    await _renderPlayer();
  }
  
  Future<void> _renderMap() async {
    // Use gameState.gameMap instead of separate gameMap instance
    for (int x = 0; x < gameState.gameMap.width; x++) {
      for (int y = 0; y < gameState.gameMap.height; y++) {
        // Existing rendering code...
        // final tileType = gameState.gameMap.tiles[x][y];
        // ... render tile ...
      }
    }
  }
  
  Future<void> _renderTown() async {
    // NEW: Visualize the town
    final townPos = gameState.town.position;
    
    // Draw town boundary (3x3 area)
    final townComponent = RectangleComponent(
      position: Vector2(townPos.x * 32 - 48, townPos.y * 32 - 48),
      size: Vector2(96, 96),
      paint: Paint()..color = Colors.brown.withOpacity(0.3),
    );
    add(townComponent);
    
    // Draw well in center
    if (gameState.town.hasWell) {
      final wellComponent = CircleComponent(
        position: Vector2(townPos.x * 32, townPos.y * 32),
        radius: 8,
        paint: Paint()..color = Colors.grey,
      );
      add(wellComponent);
      
      if (gameState.town.wellHasDungeon) {
        // Add visual indicator for dungeon entrance
        final dungeonIndicator = TextComponent(
          text: '⚔',
          position: Vector2(townPos.x * 32 - 4, townPos.y * 32 - 4),
        );
        add(dungeonIndicator);
      }
    }
  }
  
  Future<void> _renderBuildings() async {
    // NEW: Visualize each building in the town
    final buildings = gameState.town.buildings;
    int index = 0;
    
    buildings.forEach((id, building) {
      // Position buildings around the town
      final offset = _getBuildingOffset(index++);
      final buildingPos = gameState.town.position + offset;
      
      // Draw building sprite based on type
      final buildingComponent = _createBuildingSprite(building, buildingPos);
      add(buildingComponent);
    });
  }
  
  Vector2 _getBuildingOffset(int index) {
    // Arrange buildings in a circle around town center
    final positions = [
      Vector2(-2, -2), Vector2(0, -2), Vector2(2, -2),
      Vector2(-2, 0),                  Vector2(2, 0),
      Vector2(-2, 2),  Vector2(0, 2),  Vector2(2, 2),
    ];
    return positions[index % positions.length];
  }
  
  SpriteComponent _createBuildingSprite(Building building, Vector2 pos) {
    // Create appropriate sprite based on building type
    final color = _getBuildingColor(building.type);
    
    return SpriteComponent(
      position: pos * 32,
      size: Vector2(24, 24),
      paint: Paint()..color = color,
    );
  }
  
  Color _getBuildingColor(BuildingType type) {
    switch (type) {
      case BuildingType.sawmill:
        return Colors.brown;
      case BuildingType.waterWheel:
        return Colors.blue;
      case BuildingType.inn:
        return Colors.orange;
      case BuildingType.blacksmith:
        return Colors.grey;
      case BuildingType.workshop:
        return Colors.yellow;
      case BuildingType.storehouse:
        return Colors.green;
    }
  }
  
  Future<void> _renderPlayer() async {
    // Use gameState.player instead of separate player instance
    final playerSprite = await _generatePlayerSprite();
    add(SpriteComponent.fromImage(
      playerSprite,
      position: gameState.playerPosition,
      size: Vector2(32, 32),
    ));
  }
}

// Example 2: UI Overlay showing game state
class GameStateOverlay extends StatelessWidget {
  final GameState gameState;
  
  const GameStateOverlay({required this.gameState});
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Turn: ${gameState.turnCount}',
                style: TextStyle(color: Colors.white)),
            Text('Mode: ${gameState.currentMode.toString().split('.').last}',
                style: TextStyle(color: Colors.white)),
            Text('Level: ${gameState.player.level}',
                style: TextStyle(color: Colors.white)),
            Text('HP: ${gameState.player.health}/${gameState.player.maxHealth}',
                style: TextStyle(color: Colors.white)),
            SizedBox(height: 10),
            if (gameState.currentMode == GameMode.town) ...[
              Text('--- ${gameState.town.name} ---',
                  style: TextStyle(color: Colors.yellow)),
              Text('Buildings: ${gameState.town.buildings.length}',
                  style: TextStyle(color: Colors.white)),
              Text('Resources:',
                  style: TextStyle(color: Colors.white)),
              ...gameState.town.resources.entries.map((e) =>
                Text('  ${e.key}: ${e.value}',
                    style: TextStyle(color: Colors.white, fontSize: 12))),
            ],
            if (gameState.currentMode == GameMode.dungeon) ...[
              Text('--- Dungeon ---',
                  style: TextStyle(color: Colors.red)),
              Text('Level: ${_getDungeonLevelName(gameState.dungeon.currentLevel)}',
                  style: TextStyle(color: Colors.white)),
              Text('Monsters: ${_countAliveMonsters(gameState.dungeon)}',
                  style: TextStyle(color: Colors.white)),
            ],
          ],
        ),
      ),
    );
  }
  
  String _getDungeonLevelName(DungeonLevel level) {
    switch (level) {
      case DungeonLevel.entrance:
        return 'Entrance';
      case DungeonLevel.depths:
        return 'The Depths';
      case DungeonLevel.abyss:
        return 'The Abyss';
    }
  }
  
  int _countAliveMonsters(Dungeon dungeon) {
    return dungeon.getCurrentMonsters()
        .where((m) => !m.isDead)
        .length;
  }
}

// Example 3: Building construction UI
class BuildingMenuOverlay extends StatelessWidget {
  final GameState gameState;
  final Function(BuildingType) onBuildingSelected;
  
  const BuildingMenuOverlay({
    required this.gameState,
    required this.onBuildingSelected,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.brown.shade800,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.yellow, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('BUILD STRUCTURE',
                style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ..._buildingOptions(),
          ],
        ),
      ),
    );
  }
  
  List<Widget> _buildingOptions() {
    return [
      _buildingOption('Sawmill', BuildingType.sawmill,
          'Cost: 50 wood, 20 iron\nProduces: 5 planks/turn'),
      _buildingOption('Water Wheel', BuildingType.waterWheel,
          'Cost: 30 wood, 15 iron\nProduces: 10 power/turn'),
      _buildingOption('Inn', BuildingType.inn,
          'Cost: 40 wood, 20 planks\nProduces: 2 gold/turn'),
      _buildingOption('Blacksmith', BuildingType.blacksmith,
          'Cost: 30 wood, 25 iron\nProduces: 3 tools/turn'),
      _buildingOption('Workshop', BuildingType.workshop,
          'Cost: 35 wood, 15 planks, 10 iron\nProduces: 4 goods/turn'),
      _buildingOption('Storehouse', BuildingType.storehouse,
          'Cost: 60 wood, 30 planks\nIncreases storage capacity'),
    ];
  }
  
  Widget _buildingOption(String name, BuildingType type, String description) {
    final canBuild = _canConstruct(type);
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: canBuild ? () => onBuildingSelected(type) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canBuild ? Colors.green : Colors.grey,
          padding: EdgeInsets.all(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(description, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
  
  bool _canConstruct(BuildingType type) {
    final building = _getBuilding(type);
    return gameState.town.canConstructBuilding(building);
  }
  
  Building _getBuilding(BuildingType type) {
    switch (type) {
      case BuildingType.sawmill:
        return Building.createSawmill();
      case BuildingType.waterWheel:
        return Building.createWaterWheel();
      case BuildingType.inn:
        return Building.createInn();
      case BuildingType.blacksmith:
        return Building.createBlacksmith();
      case BuildingType.workshop:
        return Building.createWorkshop();
      case BuildingType.storehouse:
        return Building.createStorehouse();
    }
  }
}

// Example 4: Main app integration
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Stack(
        children: [
          // Game canvas
          GameWidget(game: EnhancedLumberjackRPG()),
          
          // Overlays (can be toggled)
          // GameStateOverlay(gameState: gameState),
          // BuildingMenuOverlay(gameState: gameState, ...),
        ],
      ),
    ),
  ));
}
