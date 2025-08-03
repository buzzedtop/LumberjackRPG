import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  // Create assets directory if it doesn't exist
  Directory('assets').createSync();

  // Map tiles (32x32)
  final mapTiles = {
    'forest.png': img.ColorRgb8(34, 139, 34), // Forest green
    'mountain.png': img.ColorRgb8(128, 128, 128), // Gray
    'cave.png': img.ColorRgb8(105, 105, 105), // Dark gray
    'deep_cave.png': img.ColorRgb8(47, 79, 79), // Dark slate gray
    'water.png': img.ColorRgb8(0, 105, 148), // Blue
  };

  // Wood resources (16x16)
  final woodResources = {
    'balsa.png': img.ColorRgb8(245, 245, 220), // Light beige
    'cedar.png': img.ColorRgb8(205, 133, 63), // Cedar brown
    'pine.png': img.ColorRgb8(210, 180, 140), // Pine tan
    'walnut.png': img.ColorRgb8(92, 64, 51), // Dark brown
    'oak.png': img.ColorRgb8(143, 101, 35), // Oak brown
    'maple.png': img.ColorRgb8(210, 180, 140), // Light tan
    'mahogany.png': img.ColorRgb8(139, 69, 19), // Deep reddish-brown
    'hickory.png': img.ColorRgb8(160, 82, 45), // Medium brown
    'wenge.png': img.ColorRgb8(56, 44, 36), // Very dark brown
    'ipe.png': img.ColorRgb8(72, 60, 50), // Dark reddish-brown
    'black_ironwood.png': img.ColorRgb8(30, 30, 30), // Near black
    'lignum_vitae.png': img.ColorRgb8(46, 39, 32), // Dark greenish-brown
    'australian_buloke.png': img.ColorRgb8(40, 30, 20), // Very dark brown
    'quebracho.png': img.ColorRgb8(100, 50, 30), // Reddish-brown
    'snakewood.png': img.ColorRgb8(80, 40, 20), // Patterned brown
  };

  // Metal resources (16x16)
  final metalResources = {
    'iron.png': img.ColorRgb8(169, 169, 169), // Iron gray
    'steel.png': img.ColorRgb8(192, 192, 192), // Steel silver
    'titanium.png': img.ColorRgb8(135, 135, 135), // Titanium gray
    'vanadium.png': img.ColorRgb8(150, 150, 150), // Vanadium gray
    'tungsten.png': img.ColorRgb8(100, 100, 100), // Dark gray
    'osmium.png': img.ColorRgb8(80, 80, 120), // Bluish-gray
    'iridium.png': img.ColorRgb8(175, 175, 175), // Bright silver
    'chromium.png': img.ColorRgb8(200, 200, 200), // Shiny silver
  };

  // Player and monsters (32x32)
  final entities = {
    'player.png': img.ColorRgb8(0, 128, 0), // Green for player
    'wolf.png': img.ColorRgb8(128, 128, 128), // Gray
    'boar.png': img.ColorRgb8(139, 69, 19), // Brown
    'bandit.png': img.ColorRgb8(255, 0, 0), // Red
    'bear.png': img.ColorRgb8(101, 67, 33), // Dark brown
    'mountain_troll.png': img.ColorRgb8(85, 107, 47), // Olive green
    'golem.png': img.ColorRgb8(112, 128, 144), // Slate gray
    'goblin.png': img.ColorRgb8(0, 100, 0), // Dark green
    'cave_troll.png': img.ColorRgb8(70, 90, 70), // Gray-green
    'cave_guardian.png': img.ColorRgb8(50, 50, 50), // Dark gray
    'dragon.png': img.ColorRgb8(178, 34, 34), // Firebrick red
    'abyssal_fiend.png': img.ColorRgb8(75, 0, 130), // Indigo
    'deep_cave_overlord.png': img.ColorRgb8(25, 25, 112), // Midnight blue
  };

  // Generate map tiles (32x32)
  mapTiles.forEach((name, color) {
    final image = img.Image(width: 32, height: 32);
    img.fill(image, color: color);
    File('assets/$name').writeAsBytesSync(img.encodePng(image));
    print('Generated assets/$name');
  });

  // Generate wood resources (16x16)
  woodResources.forEach((name, color) {
    final image = img.Image(width: 16, height: 16);
    img.fill(image, color: color);
    File('assets/$name').writeAsBytesSync(img.encodePng(image));
    print('Generated assets/$name');
  });

  // Generate metal resources (16x16)
  metalResources.forEach((name, color) {
    final image = img.Image(width: 16, height: 16);
    img.fill(image, color: color);
    File('assets/$name').writeAsBytesSync(img.encodePng(image));
    print('Generated assets/$name');
  });

  // Generate player and monster sprites (32x32)
  entities.forEach((name, color) {
    final image = img.Image(width: 32, height: 32);
    img.fill(image, color: color);
    File('assets/$name').writeAsBytesSync(img.encodePng(image));
    print('Generated assets/$name');
  });
}
