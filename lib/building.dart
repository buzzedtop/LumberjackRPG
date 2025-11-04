import 'dart:math';

enum BuildingType {
  sawmill,
  waterWheel,
  inn,
  blacksmith,
  workshop,
  storehouse,
}

class Building {
  final BuildingType type;
  final String name;
  final Map<String, int> constructionCost;
  final Map<String, double> productionRate; // Resources per turn
  int level;
  bool isOperational;
  int productionTicks;

  Building({
    required this.type,
    required this.name,
    required this.constructionCost,
    required this.productionRate,
    this.level = 1,
    this.isOperational = true,
    this.productionTicks = 0,
  });

  Map<String, int> produce() {
    if (!isOperational) return {};
    
    productionTicks++;
    final Map<String, int> produced = {};
    
    productionRate.forEach((resource, rate) {
      final amount = (rate * level).floor();
      if (amount > 0) {
        produced[resource] = amount;
      }
    });
    
    return produced;
  }

  void upgrade() {
    level++;
  }

  String getInfo() {
    final buffer = StringBuffer();
    buffer.writeln('$name (Level $level)');
    buffer.writeln('Type: ${type.toString().split('.').last}');
    buffer.writeln('Status: ${isOperational ? "Operational" : "Inactive"}');
    
    if (productionRate.isNotEmpty) {
      buffer.writeln('Production:');
      productionRate.forEach((resource, rate) {
        final amount = (rate * level).floor();
        buffer.writeln('  - $resource: $amount per turn');
      });
    }
    
    buffer.writeln('Construction Cost:');
    constructionCost.forEach((resource, amount) {
      buffer.writeln('  - $resource: $amount');
    });
    
    return buffer.toString();
  }

  static Building createSawmill() {
    return Building(
      type: BuildingType.sawmill,
      name: 'Sawmill',
      constructionCost: {'wood': 50, 'iron': 20},
      productionRate: {'planks': 5.0},
    );
  }

  static Building createWaterWheel() {
    return Building(
      type: BuildingType.waterWheel,
      name: 'Water Wheel',
      constructionCost: {'wood': 30, 'iron': 15},
      productionRate: {'power': 10.0},
    );
  }

  static Building createInn() {
    return Building(
      type: BuildingType.inn,
      name: 'Inn',
      constructionCost: {'wood': 40, 'planks': 20},
      productionRate: {'gold': 2.0},
    );
  }

  static Building createBlacksmith() {
    return Building(
      type: BuildingType.blacksmith,
      name: 'Blacksmith',
      constructionCost: {'wood': 30, 'iron': 25},
      productionRate: {'tools': 3.0},
    );
  }

  static Building createWorkshop() {
    return Building(
      type: BuildingType.workshop,
      name: 'Workshop',
      constructionCost: {'wood': 35, 'planks': 15, 'iron': 10},
      productionRate: {'goods': 4.0},
    );
  }

  static Building createStorehouse() {
    return Building(
      type: BuildingType.storehouse,
      name: 'Storehouse',
      constructionCost: {'wood': 60, 'planks': 30},
      productionRate: {}, // No production, just storage
    );
  }
}
