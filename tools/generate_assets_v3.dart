import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

void main() {
  // Create assets directory
  Directory('../assets').createSync();

  // Random for noise and variation
  final random = Random(42);

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

  // Helper to add dithered noise for pixel-art texture
  void addDitheredNoise(img.Image image, img.ColorRgb8 baseColor, int intensity) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        if (image.getPixel(x, y).a == 0) continue; // Skip transparent pixels
        int noise = (random.nextDouble() * intensity - intensity / 2).round();
        int r = (baseColor.r + noise).clamp(0, 255);
        int g = (baseColor.g + noise).clamp(0, 255);
        int b = (baseColor.b + noise).clamp(0, 255);
        // Apply dithering: set pixel only if noise pattern allows
        if ((x + y) % 2 == 0 || random.nextDouble() > 0.5) {
          image.setPixelRgba(x, y, r, g, b, image.getPixel(x, y).a);
        }
      }
    }
  }

  // Helper to simulate pixel-art font (scaled down)
  void drawPixelText(img.Image image, String text, int x, int y, img.ColorRgb8 color) {
    img.drawString(image, text, img.arial_14, x, y, color);
    // Simulate pixel-art by scaling down and sharpening
    for (int sy = y; sy < y + 14 && sy < image.height; sy++) {
      for (int sx = x; sx < x + 10 && sx < image.width; sx++) {
        if (image.getPixel(sx, sy).a > 0) {
          image.setPixelRgba(sx, sy, color.r, color.g, color.b, color.a);
        }
      }
    }
  }

  // Generate map tiles (32x32)
  mapTiles.forEach((name, color) {
    final image = img.Image(width: 32, height: 32);
    img.fill(image, color: img.ColorRgb8(0, 0, 0, 0)); // Transparent background
    if (name == 'forest.png') {
      img.fillRect(image, 0, 0, 31, 31, color); // Grass base
      addDitheredNoise(image, color, 20);
      img.fillCircle(image, 10, 10, 4, img.ColorRgb8(0, 100, 0)); // Tree 1
      img.fillCircle(image, 22, 14, 5, img.ColorRgb8(0, 100, 0)); // Tree 2
      img.fillRect(image, 10, 12, 10, 14, img.ColorRgb8(139, 69, 19)); // Trunk
      img.drawRect(image, 0, 0, 31, 31, img.ColorRgb8(20, 80, 20)); // Outline
    } else if (name == 'mountain.png') {
      img.fillRect(image, 0, 0, 31, 31, color);
      addDitheredNoise(image, color, 30);
      img.fillTriangle(image, 8, 20, 16, 8, 24, 20, img.ColorRgb8(100, 100, 100)); // Peak
      img.drawLine(image, 10, 22, 22, 22, img.ColorRgb8(80, 80, 80)); // Crevice
    } else if (name == 'cave.png') {
      img.fillRect(image, 0, 0, 31, 31, color);
      addDitheredNoise(image, color, 25);
      img.drawCircle(image, 16, 16, 8, img.ColorRgb8(80, 80, 80)); // Cave opening
    } else if (name == 'deep_cave.png') {
      img.fillRect(image, 0, 0, 31, 31, color);
      addDitheredNoise(image, color, 25);
      img.drawCircle(image, 16, 16, 10, img.ColorRgb8(60, 60, 60)); // Deeper cave
      img.drawPixel(image, 16, 16, img.ColorRgb8(255, 255, 255)); // Glow effect
    } else if (name == 'water.png') {
      img.fillRect(image, 0, 0, 31, 31, color);
      addDitheredNoise(image, color, 15);
      img.drawLine(image, 8, 10, 24, 10, img.ColorRgb8(0, 150, 200)); // Wave 1
      img.drawLine(image, 6, 14, 26, 14, img.ColorRgb8(0, 150, 200)); // Wave 2
      img.drawRect(image, 0, 0, 31, 31, img.ColorRgb8(0, 80, 120)); // Outline
    }
    File('../assets/$name').writeAsBytesSync(img.encodePng(image));
    print('Generated ../assets/$name');
  });

  // Generate wood resources (16x16)
  woodResources.forEach((name, color) {
    final image = img.Image(width: 16, height: 16);
    img.fill(image, color: img.ColorRgb8(0, 0, 0, 0)); // Transparent background
    img.fillRect(image, 6, 10, 9, 14, img.ColorRgb8(139, 69, 19)); // Trunk
    img.fillCircle(image, 7, 6, 4, color); // Foliage
    addDitheredNoise(image, color, 10);
    String label = name[0].toUpperCase();
    drawPixelText(image, label, 2, 2, img.ColorRgb8(255, 255, 255));
    img.drawRect(image, 5, 5, 10, 14, img.ColorRgb8(50, 50, 50)); // Outline
    File('../assets/$name').writeAsBytesSync(img.encodePng(image));
    print('Generated ../assets/$name');
  });

  // Generate metal resources (16x16)
  metalResources.forEach((name, color) {
    final image = img.Image(width: 16, height: 16);
    img.fill(image, color: img.ColorRgb8(0, 0, 0, 0)); // Transparent background
    img.fillPolygon(image, [4, 4, 12, 4, 10, 10, 6, 10], color); // Ore shape
    addDitheredNoise(image, color, 15);
    img.drawPixel(image, 5, 5, img.ColorRgb8(255, 255, 255)); // Shine highlight
    String label = name[0].toUpperCase();
    drawPixelText(image, label, 2, 2, img.ColorRgb8(255, 255, 255));
    img.drawPolygon(image, [4, 4, 12, 4, 10, 10, 6, 10], img.ColorRgb8(50, 50, 50)); // Outline
    File('../assets/$name').writeAsBytesSync(img.encodePng(image));
    print('Generated ../assets/$name');
  });

  // Generate player and monster sprites (32x32)
  entities.forEach((name, color) {
    final image = img.Image(width: 32, height: 32);
    img.fill(image, color: img.ColorRgb8(0, 0, 0, 0)); // Transparent background
    if (name == 'player.png') {
      img.fillCircle(image, 16, 8, 4, color); // Head
      img.fillRect(image, 12, 12, 19, 24, color); // Body
      img.drawLine(image, 20, 12, 24, 16, img.ColorRgb8(100, 100, 100)); // Axe
      addDitheredNoise(image, color, 10);
      img.drawRect(image, 12, 12, 19, 24, img.ColorRgb8(50, 50, 50)); // Outline
    } else if (name == 'bandit.png') {
      img.fillCircle(image, 16, 8, 4, color); // Head
      img.fillRect(image, 12, 12, 19, 24, color); // Body
      img.drawLine(image, 20, 12, 24, 12, img.ColorRgb8(0, 0, 0)); // Knife
      addDitheredNoise(image, color, 10);
      img.drawRect(image, 12, 12, 19, 24, img.ColorRgb8(50, 50, 50)); // Outline
    } else if (['wolf.png', 'boar.png', 'bear.png'].contains(name)) {
      img.fillRect(image, 8, 12, 23, 20, color); // Body
      img.fillCircle(image, 10, 10, 3, color); // Head
      img.drawPixel(image, 8, 8, img.ColorRgb8(255, 255, 255)); // Eye
      addDitheredNoise(image, color, 15);
      img.drawRect(image, 8, 12, 23, 20, img.ColorRgb8(50, 50, 50)); // Outline
    } else if (name == 'dragon.png') {
      img.fillRect(image, 10, 14, 22, 22, color); // Body
      img.drawLine(image, 8, 12, 10, 10, color); // Wing 1
      img.drawLine(image, 24, 12, 22, 10, color); // Wing 2
      img.fillCircle(image, 10, 10, 4, color); // Head
      addDitheredNoise(image, color, 15);
      img.drawRect(image, 10, 14, 22, 22, img.ColorRgb8(50, 50, 50)); // Outline
    } else if (['cave_guardian.png', 'deep_cave_overlord.png'].contains(name)) {
      img.fillCircle(image, 16, 16, 12, color); // Large body
      img.fillCircle(image, 16, 8, 6, color); // Head
      img.drawPixel(image, 14, 6, img.ColorRgb8(255, 255, 255)); // Eye
      addDitheredNoise(image, color, 20);
      img.drawCircle(image, 16, 16, 12, img.ColorRgb8(50, 50, 50)); // Outline
    } else {
      img.fillRect(image, 10, 10, 21, 21, color); // Generic monster body
      img.fillCircle(image, 12, 8, 4, color); // Head
      img.drawPixel(image, 10, 6, img.ColorRgb8(255, 255, 255)); // Eye
      addDitheredNoise(image, color, 15);
      img.drawRect(image, 10, 10, 21, 21, img.ColorRgb8(50, 50, 50)); // Outline
    }
    File('../assets/$name').writeAsBytesSync(img.encodePng(image));
    print('Generated ../assets/$name');
  });
}
