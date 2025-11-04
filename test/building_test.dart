import 'package:flutter_test/flutter_test.dart';
import 'package:lumberjack_rpg/building.dart';

void main() {
  group('Building System Mechanics', () {
    test('Sawmill initializes correctly', () {
      final sawmill = Building.createSawmill();
      
      expect(sawmill.type, equals(BuildingType.sawmill));
      expect(sawmill.name, equals('Sawmill'));
      expect(sawmill.level, equals(1));
      expect(sawmill.isOperational, isTrue);
      expect(sawmill.constructionCost, isNotEmpty);
      expect(sawmill.productionRate, isNotEmpty);
    });

    test('Water Wheel initializes correctly', () {
      final waterWheel = Building.createWaterWheel();
      
      expect(waterWheel.type, equals(BuildingType.waterWheel));
      expect(waterWheel.name, equals('Water Wheel'));
      expect(waterWheel.level, equals(1));
      expect(waterWheel.isOperational, isTrue);
    });

    test('Inn initializes correctly', () {
      final inn = Building.createInn();
      
      expect(inn.type, equals(BuildingType.inn));
      expect(inn.name, equals('Inn'));
      expect(inn.productionRate.containsKey('gold'), isTrue);
    });

    test('Blacksmith initializes correctly', () {
      final blacksmith = Building.createBlacksmith();
      
      expect(blacksmith.type, equals(BuildingType.blacksmith));
      expect(blacksmith.name, equals('Blacksmith'));
      expect(blacksmith.productionRate.containsKey('tools'), isTrue);
    });

    test('Workshop initializes correctly', () {
      final workshop = Building.createWorkshop();
      
      expect(workshop.type, equals(BuildingType.workshop));
      expect(workshop.name, equals('Workshop'));
      expect(workshop.productionRate.containsKey('goods'), isTrue);
    });

    test('Storehouse initializes correctly', () {
      final storehouse = Building.createStorehouse();
      
      expect(storehouse.type, equals(BuildingType.storehouse));
      expect(storehouse.name, equals('Storehouse'));
      // Storehouse doesn't produce resources, just storage
      expect(storehouse.productionRate.isEmpty, isTrue);
    });

    test('Building produces resources each turn', () {
      final sawmill = Building.createSawmill();
      
      final produced = sawmill.produce();
      
      expect(produced, isNotEmpty);
      expect(produced.containsKey('planks'), isTrue);
      expect(produced['planks'], greaterThan(0));
    });

    test('Building production scales with level', () {
      final sawmill = Building.createSawmill();
      
      final level1Production = sawmill.produce();
      sawmill.upgrade();
      final level2Production = sawmill.produce();
      
      expect(level2Production['planks'], greaterThan(level1Production['planks']!));
    });

    test('Inactive building does not produce', () {
      final sawmill = Building.createSawmill();
      sawmill.isOperational = false;
      
      final produced = sawmill.produce();
      
      expect(produced.isEmpty, isTrue);
    });

    test('Building can be upgraded', () {
      final sawmill = Building.createSawmill();
      final initialLevel = sawmill.level;
      
      sawmill.upgrade();
      
      expect(sawmill.level, equals(initialLevel + 1));
    });

    test('Building info contains correct data', () {
      final sawmill = Building.createSawmill();
      final info = sawmill.getInfo();
      
      expect(info, contains('Sawmill'));
      expect(info, contains('Level'));
      expect(info, contains('Production'));
      expect(info, contains('Construction Cost'));
    });

    test('All building types are defined', () {
      expect(BuildingType.values.length, equals(6));
      expect(BuildingType.values.contains(BuildingType.sawmill), isTrue);
      expect(BuildingType.values.contains(BuildingType.waterWheel), isTrue);
      expect(BuildingType.values.contains(BuildingType.inn), isTrue);
      expect(BuildingType.values.contains(BuildingType.blacksmith), isTrue);
      expect(BuildingType.values.contains(BuildingType.workshop), isTrue);
      expect(BuildingType.values.contains(BuildingType.storehouse), isTrue);
    });

    test('Building tracks production ticks', () {
      final sawmill = Building.createSawmill();
      
      expect(sawmill.productionTicks, equals(0));
      sawmill.produce();
      expect(sawmill.productionTicks, equals(1));
      sawmill.produce();
      expect(sawmill.productionTicks, equals(2));
    });

    test('Multiple upgrades increase production accordingly', () {
      final sawmill = Building.createSawmill();
      
      final level1Production = sawmill.produce()['planks']!;
      sawmill.upgrade();
      sawmill.upgrade();
      sawmill.upgrade();
      final level4Production = sawmill.produce()['planks']!;
      
      expect(level4Production, greaterThan(level1Production));
      expect(sawmill.level, equals(4));
    });
  });
}
