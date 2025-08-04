import 'constants.dart';

class Metal {
  final String name;
  final String biome;
  int durability;
  int amount;
  bool isDepleted = false;

  Metal(this.name, this.biome)
      : durability = metalTypes[name]!['durability'] as int,
        amount = metalTypes[name]!['amount'] as int;

  void mine() {
    if (!isDepleted) {
      durability--;
      if (durability <= 0) {
        isDepleted = true;
      }
    }
  }
}