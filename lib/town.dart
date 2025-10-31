import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'building.dart';

class Town {
  final String name;
  final Vector2 position;
  final Map<String, Building> buildings = {};
  final Map<String, int> resources = {};
  final bool hasWell;
  final bool wellHasDungeon;
  
  Town({
    required this.name,
    required this.position,
    this.hasWell = true,
    this.wellHasDungeon = true,
  });

  bool canConstructBuilding(Building building) {
    for (var entry in building.constructionCost.entries) {
      final resource = entry.key;
      final required = entry.value;
      if (!resources.containsKey(resource) || resources[resource]! < required) {
        return false;
      }
    }
    return true;
  }

  bool constructBuilding(String buildingId, Building building) {
    if (!canConstructBuilding(building)) {
      return false;
    }

    // Deduct resources
    for (var entry in building.constructionCost.entries) {
      final resource = entry.key;
      final required = entry.value;
      resources[resource] = resources[resource]! - required;
      if (resources[resource]! <= 0) {
        resources.remove(resource);
      }
    }

    buildings[buildingId] = building;
    return true;
  }

  void produceResources() {
    for (var building in buildings.values) {
      final produced = building.produce();
      produced.forEach((resource, amount) {
        resources[resource] = (resources[resource] ?? 0) + amount;
      });
    }
  }

  void addResource(String resource, int amount) {
    resources[resource] = (resources[resource] ?? 0) + amount;
  }

  String getInfo() {
    final buffer = StringBuffer();
    buffer.writeln('===== $name =====');
    buffer.writeln('Position: (${position.x.toInt()}, ${position.y.toInt()})');
    
    if (hasWell) {
      buffer.writeln('Town Well: Yes${wellHasDungeon ? " (Contains dungeon entrance!)" : ""}');
    }
    
    buffer.writeln('\n--- Resources ---');
    if (resources.isEmpty) {
      buffer.writeln('No resources');
    } else {
      resources.forEach((resource, amount) {
        buffer.writeln('$resource: $amount');
      });
    }
    
    buffer.writeln('\n--- Buildings ---');
    if (buildings.isEmpty) {
      buffer.writeln('No buildings constructed yet');
    } else {
      buildings.forEach((id, building) {
        buffer.writeln('[$id] ${building.name} (Level ${building.level})');
      });
    }
    
    return buffer.toString();
  }

  List<String> getBuildingsList() {
    final list = <String>[];
    buildings.forEach((id, building) {
      list.add('[$id] ${building.name} - Level ${building.level} - ${building.isOperational ? "Active" : "Inactive"}');
    });
    return list;
  }
}
