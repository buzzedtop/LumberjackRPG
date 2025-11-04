import 'package:flutter_test/flutter_test.dart';
import 'package:lumberjack_rpg/town.dart';
import 'package:lumberjack_rpg/building.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  group('Town System Mechanics', () {
    late Town town;

    setUp(() {
      town = Town(
        name: 'Test Village',
        position: Vector2(10, 10),
        hasWell: true,
        wellHasDungeon: true,
      );
    });

    test('Town initializes with correct properties', () {
      expect(town.name, equals('Test Village'));
      expect(town.position.x, equals(10));
      expect(town.position.y, equals(10));
      expect(town.hasWell, isTrue);
      expect(town.wellHasDungeon, isTrue);
      expect(town.buildings.isEmpty, isTrue);
      expect(town.resources.isEmpty, isTrue);
    });

    test('Town can add resources', () {
      town.addResource('wood', 50);
      
      expect(town.resources['wood'], equals(50));
    });

    test('Adding resources accumulates correctly', () {
      town.addResource('wood', 50);
      town.addResource('wood', 30);
      
      expect(town.resources['wood'], equals(80));
    });

    test('Town cannot construct building without resources', () {
      final sawmill = Building.createSawmill();
      
      final canConstruct = town.canConstructBuilding(sawmill);
      
      expect(canConstruct, isFalse);
    });

    test('Town can construct building with sufficient resources', () {
      town.addResource('wood', 100);
      town.addResource('iron', 50);
      
      final sawmill = Building.createSawmill();
      final canConstruct = town.canConstructBuilding(sawmill);
      
      expect(canConstruct, isTrue);
    });

    test('Constructing building consumes resources', () {
      town.addResource('wood', 100);
      town.addResource('iron', 50);
      
      final sawmill = Building.createSawmill();
      town.constructBuilding('sawmill1', sawmill);
      
      expect(town.resources['wood'], lessThan(100));
      expect(town.resources['iron'], lessThan(50));
    });

    test('Constructing building adds it to town', () {
      town.addResource('wood', 100);
      town.addResource('iron', 50);
      
      final sawmill = Building.createSawmill();
      town.constructBuilding('sawmill1', sawmill);
      
      expect(town.buildings.containsKey('sawmill1'), isTrue);
      expect(town.buildings['sawmill1']!.type, equals(BuildingType.sawmill));
    });

    test('Cannot construct without sufficient wood', () {
      town.addResource('iron', 50);
      // Not enough wood
      
      final sawmill = Building.createSawmill();
      final success = town.constructBuilding('sawmill1', sawmill);
      
      expect(success, isFalse);
    });

    test('Cannot construct without sufficient metal', () {
      town.addResource('wood', 100);
      // Not enough iron
      
      final sawmill = Building.createSawmill();
      final success = town.constructBuilding('sawmill1', sawmill);
      
      expect(success, isFalse);
    });

    test('Town produces resources from buildings', () {
      town.addResource('wood', 100);
      town.addResource('iron', 50);
      
      final sawmill = Building.createSawmill();
      town.constructBuilding('sawmill1', sawmill);
      
      town.produceResources();
      
      expect(town.resources.containsKey('planks'), isTrue);
      expect(town.resources['planks'], greaterThan(0));
    });

    test('Multiple buildings produce independently', () {
      town.addResource('wood', 200);
      town.addResource('iron', 100);
      
      final sawmill = Building.createSawmill();
      final blacksmith = Building.createBlacksmith();
      
      town.constructBuilding('sawmill1', sawmill);
      town.constructBuilding('blacksmith1', blacksmith);
      
      town.produceResources();
      
      expect(town.resources.containsKey('planks'), isTrue);
      expect(town.resources.containsKey('tools'), isTrue);
    });

    test('Production accumulates over multiple turns', () {
      town.addResource('wood', 100);
      town.addResource('iron', 50);
      
      final sawmill = Building.createSawmill();
      town.constructBuilding('sawmill1', sawmill);
      
      town.produceResources();
      final firstProduction = town.resources['planks'] ?? 0;
      
      town.produceResources();
      final secondProduction = town.resources['planks'] ?? 0;
      
      expect(secondProduction, greaterThan(firstProduction));
    });

    test('Town info contains all relevant data', () {
      final info = town.getInfo();
      
      expect(info, contains('Test Village'));
      expect(info, contains('Position'));
      expect(info, contains('Town Well'));
      expect(info, contains('Resources'));
      expect(info, contains('Buildings'));
    });

    test('Buildings list shows correct information', () {
      town.addResource('wood', 100);
      town.addResource('iron', 50);
      
      final sawmill = Building.createSawmill();
      town.constructBuilding('sawmill1', sawmill);
      
      final buildingsList = town.getBuildingsList();
      
      expect(buildingsList.isNotEmpty, isTrue);
      expect(buildingsList[0], contains('sawmill1'));
      expect(buildingsList[0], contains('Sawmill'));
    });

    test('Can construct multiple buildings of same type', () {
      town.addResource('wood', 200);
      town.addResource('iron', 100);
      
      final sawmill1 = Building.createSawmill();
      final sawmill2 = Building.createSawmill();
      
      town.constructBuilding('sawmill1', sawmill1);
      town.constructBuilding('sawmill2', sawmill2);
      
      expect(town.buildings.length, equals(2));
    });

    test('Resources are removed when depleted by construction', () {
      town.addResource('wood', 50);
      town.addResource('iron', 20);
      
      final sawmill = Building.createSawmill();
      town.constructBuilding('sawmill1', sawmill);
      
      // Exact match should remove the resource entry
      expect(town.resources.containsKey('wood'), isFalse);
      expect(town.resources.containsKey('iron'), isFalse);
    });
  });
}
