import 'constants.dart';

class Wood {
  final String name;
  final String biome;
  int durability;
  int amount;
  bool isDepleted = false;

  Wood(this.name, this.biome)
      : durability = woodTypes[name]!['durability'] as int,
        amount = woodTypes[name]!['amount'] as int;

  void chop() {
    if (!isDepleted) {
      durability--;
      if (durability <= 0) {
        isDepleted = true;
      }
    }
  }
}