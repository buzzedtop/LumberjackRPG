enum AxeType { stone, iron, steel, titanium, vanadium }

class Axe {
  final AxeType type;
  int durability;
  int damage;

  Axe(this.type)
      : durability = _getInitialDurability(type),
        damage = _getDamage(type);

  static int _getInitialDurability(AxeType type) {
    switch (type) {
      case AxeType.stone:
        return 50;
      case AxeType.iron:
        return 100;
      case AxeType.steel:
        return 150;
      case AxeType.titanium:
        return 200;
      case AxeType.vanadium:
        return 250;
    }
  }

  static int _getDamage(AxeType type) {
    switch (type) {
      case AxeType.stone:
        return 10;
      case AxeType.iron:
        return 15;
      case AxeType.steel:
        return 20;
      case AxeType.titanium:
        return 25;
      case AxeType.vanadium:
        return 30;
    }
  }

  void use() {
    durability--;
    if (durability <= 0) {
      // Handle axe breaking (e.g., revert to stone axe)
    }
  }
}