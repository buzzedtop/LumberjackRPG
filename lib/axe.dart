import 'wood.dart';
import 'metal.dart';

enum AxeType {
  handAxe,
  dualHandAxes,
  throwingAxe,
  battleAxe,
  doubleBittedAxe,
  fellingAxe,
  broadAxe,
  tomahawk,
  splittingMaul,
  adze,
}

class Axe {
  final AxeType type;
  final Wood wood;
  final Metal metal;
  final int damage;
  final int durability;
  final double speed;
  final String range;
  final double chopBonus;
  final double craftBonus;
  final double weightModifier;

  Axe({
    required this.type,
    required this.wood,
    required this.metal,
    required this.damage,
    required this.durability,
    required this.speed,
    required this.range,
    required this.chopBonus,
    required this.craftBonus,
    required this.weightModifier,
  });
}
