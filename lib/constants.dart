import 'wood.dart';
import 'metal.dart';

final List<Wood> woodTypes = [
  Wood('Balsa', 90, 'Common', 'Forest', 1, 1.0),
  Wood('Cedar', 900, 'Common', 'Forest', 3, 1.0),
  Wood('Pine', 950, 'Common', 'Forest', 3, 1.0),
  Wood('Walnut', 1010, 'Common', 'Forest', 4, 1.0),
  Wood('Oak', 1080, 'Common', 'Forest', 5, 1.0),
  Wood('Maple', 1450, 'Uncommon', 'Forest', 8, 1.0),
  Wood('Mahogany', 2200, 'Uncommon', 'Forest', 10, 1.0),
  Wood('Hickory', 2540, 'Uncommon', 'Forest,Mountain', 12, 1.0),
  Wood('Wenge', 3260, 'Rare', 'Mountain', 15, 1.0),
  Wood('Ipe', 3684, 'Rare', 'Mountain', 18, 1.0),
  Wood('Black Ironwood', 3660, 'Rare', 'Cave', 18, 1.0),
  Wood('Lignum Vitae', 4390, 'Very Rare', 'Cave', 22, 1.1),
  Wood('Australian Buloke', 5060, 'Very Rare', 'Cave', 25, 1.1),
  Wood('Quebracho', 4570, 'Very Rare', 'Cave', 23, 1.1),
  Wood('Snakewood', 3800, 'Very Rare', 'Cave', 20, 1.1),
];

final List<Metal> metalTypes = [
  Metal('Iron', 4.0, 'Common', 'Forest,Mountain', 5, 20, 1.0),
  Metal('Steel', 5.0, 'Common', 'Mountain', 8, 30, 1.0),
  Metal('Titanium', 6.0, 'Uncommon', 'Mountain', 10, 40, 0.9),
  Metal('Vanadium', 6.7, 'Uncommon', 'Mountain', 12, 50, 1.0),
  Metal('Tungsten', 7.5, 'Rare', 'Cave', 20, 80, 1.2),
  Metal('Osmium', 7.0, 'Very Rare', 'Cave', 18, 70, 1.3),
  Metal('Iridium', 6.5, 'Very Rare', 'Cave', 15, 60, 1.2),
  Metal('Chromium', 8.5, 'Very Rare', 'Deep Cave', 25, 90, 1.1),
];
