import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:flame_noise/flame_noise.dart';

void main() {
  // Create assets directories
  Directory('../assets/map').createSync(recursive: true);
  Directory('../assets/resources').createSync(recursive: true);
  Directory('../assets/entities').createSync(recursive: true);

  // Random and noise for procedural generation
  final random = Random(42);
  final noise = PerlinNoise(frequency: 0.1, seed: 42);

  // Map tiles (64x64, split into 4 32x32 sub-tiles)
  final mapTiles = {
    'forest': img.ColorRgb8(34, 139, 34), // Forest green
    'mountain': img.ColorRgb8(128, 128, 128), // Gray
    'cave': img.ColorRgb8(105, 105, 105), // Dark gray
    'deep_cave': img.ColorRgb8(47, 79, 79), // Dark slate gray
    'water': img.ColorRgb8(0, 105, 148), // Blue
    'road': img.ColorRgb8(139, 69, 19), // Brown for dirt roads
  };

  // Wood resources (16x16, biome-specific)
  final woodResources = {
    'balsa': {'color': img.ColorRgb8(245, 245, 220), 'biome': 'forest'},
    'cedar': {'color': img.ColorRgb8(205, 133, 63), 'biome': 'forest'},
    'pine': {'color': img.ColorRgb8(210, 180, 140), 'biome': 'forest'},
    'walnut': {'color': img.ColorRgb8(92, 64, 51), 'biome': 'forest'},
    'oak': {'color': img.ColorRgb8(143, 101, 35), 'biome': 'forest'},
    'maple': {'color': img.ColorRgb8(210, 180, 140), 'biome': 'forest'},
    'mahogany': {'color': img.ColorRgb8(139, 69, 19), 'biome': 'mountain'},
    'hickory': {'color': img.ColorRgb8(160, 82, 45), 'biome': 'mountain'},
    'wenge': {'color': img.ColorRgb8(56, 44, 36), 'biome': 'mountain'},
    'ipe': {'color': img.ColorRgb8(72, 60, 50), 'biome': 'mountain'},
    'black_ironwood': {'color': img.ColorRgb8(30, 30, 30), 'biome': 'cave'},
    'lignum_vitae': {'color': img.ColorRgb8(46, 39, 32), 'biome': 'cave'},
    'australian_buloke': {'color': img.ColorRgb8(40, 30, 20), 'biome': 'deep_cave'},
    'quebracho': {'color': img.ColorRgb8(100, 50, 30), 'biome': 'cave'},
    'snakewood': {'color': img.ColorRgb8(80, 40, 20), 'biome': 'deep_cave'},
  };

  // Metal resources (16x16, biome-specific)
  final metalResources = {
    'iron': {'color': img.ColorRgb8(169, 169, 169), 'biome': 'mountain'},
    'steel': {'color': img.ColorRgb8(192, 192, 192), 'biome': 'mountain'},
    'titanium': {'color': img.ColorRgb8(135, 135, 135), 'biome': 'mountain'},
    'vanadium': {'color': img.ColorRgb8(150, 150, 150), 'biome': 'mountain'},
    'tungsten': {'color': img.ColorRgb8(100, 100, 100), 'biome': 'cave'},
    'osmium': {'color': img.ColorRgb8(80, 80, 120), 'biome': 'cave'},
    'iridium': {'color': img.ColorRgb8(175, 175, 175), 'biome': 'deep_cave'},
    'chromium': {'color': img.ColorRgb8(200, 200, 200), 'biome': 'deep_cave'},
  };

  // Player and monsters (32x32)
  final entities = {
    'player': img.ColorRgb8(0, 128, 0),
    'wolf': img.ColorRgb8(128, 128, 128),
    'boar': img.ColorRgb8(139, 69, 19),
    'bandit': img.ColorRgb8(255, 0, 0),
    'bear': img.ColorRgb8(101, 67, 33),
    'mountain_troll': img.ColorRgb8(85, 107, 47),
    'golem': img.ColorRgb8(112, 128, 144),
    'goblin': img.ColorRgb8(0, 100, 0),
    'cave_troll': img.ColorRgb8(70, 90, 70),
    'cave_guardian': img.ColorRgb8(50, 50, 50),
    'dragon': img.ColorRgb8(178, 34, 34),
    'abyssal_fiend': img.ColorRgb8(75, 0, 130),
    'deep_cave_overlord': img.ColorRgb8(25, 25, 112),
  };

  // Helper to add dithered Perlin noise
  void addPerlinNoise(img.Image image, img.ColorRgb8 baseColor, double scale) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        if (image.getPixel(x, y).a == 0) continue;
        double n = noise.noise2(x * scale, y * scale) * 20;
        int r = (baseColor.r + n).clamp(0, 255).round();
        int g = (baseColor.g + n).clamp(0, 255).round();
        int b = (baseColor.b + n).clamp(0, 255).round();
        if ((x + y) % 2 == 0 || random.nextDouble() > 0.5) {
          image.setPixelRgba(x, y, r, g, b, image.getPixel(x, y).a);
        }
      }
    }
  }

  // Helper for pixel-art text
  void drawPixelText(img.Image image, String text, int x, int y, img.ColorRgb8 color) {
    img.drawString(image, text, img.arial_14, x, y, color);
    for (int sy = y; sy < y + 14 && sy < image.height; sy++) {
      for (int sx = x; sx < x + 10 && sx < image.width; sx++) {
        if (image.getPixel(sx, sy).a > 0) {
          image.setPixelRgba(sx, sy, color.r, color.g, color.b, color.a);
        }
      }
    }
  }

  // Generate map tiles (64x64, split into 32x32)
  mapTiles.forEach((name, color) {
    final image = img.Image(width: 64, height: 64);
    img.fill(image, color: img.ColorRgb8(0, 0, 0, 0));
    if (name == 'forest') {
      img.fillRect(image, 0, 0, 63, 63, color);
      addPerlinNoise(image, color, 0.05);
      img.fillCircle(image, 20, 20, 8, img.ColorRgb8(0, 100, 0));
      img.fillCircle(image, 44, 28, 10, img.ColorRgb8(0, 100, 0));
      img.fillRect(image, 20, 24, 20, 28, img.ColorRgb8(139, 69, 19));
      img.fillRect(image, 44, 32, 44, 36, img.ColorRgb8(139, 69, 19));
      img.drawRect(image, 0, 0, 63, 63, img.ColorRgb8(20, 80, 20));
    } else if (name == 'mountain') {
      img.fillRect(image, 0, 0, 63, 63, color);
      addPerlinNoise(image, color, 0.1);
      img.fillTriangle(image, 16, 48, 32, 16, 48, 48, img.ColorRgb8(100, 100, 100));
      img.drawLine(image, 20, 50, 44, 50, img.ColorRgb8(80, 80, 80));
    } else if (name == 'cave') {
      img.fillRect(image, 0, 0, 63, 63, color);
      addPerlinNoise(image, color, 0.08);
      img.drawCircle(image, 32, 32, 16, img.ColorRgb8(80, 80, 80));
      img.fillRect(image, 28, 40, 36, 44, img.ColorRgb8(60, 60, 60));
    } else if (name == 'deep_cave') {
      img.fillRect(image, 0, 0, 63, 63, color);
      addPerlinNoise(image, color, 0.08);
      img.drawCircle(image, 32, 32, 20, img.ColorRgb8(60, 60, 60));
      img.drawPixel(image, 32, 32, img.ColorRgb8(255, 255, 255));
    } else if (name == 'water') {
      img.fillRect(image, 0, 0, 63, 63, color);
      addPerlinNoise(image, color, 0.05);
      img.drawLine(image, 16, 20, 48, 20, img.ColorRgb8(0, 150, 200));
      img.drawLine(image, 12, 28, 52, 28, img.ColorRgb8(0, 150, 200));
      img.drawRect(image, 0, 0, 63, 63, img.ColorRgb8(0, 80, 120));
    } else if (name == 'road') {
      img.fillRect(image, 0, 0, 63, 63, color);
      addPerlinNoise(image, color, 0.05);
      img.drawLine(image, 16, 0, 16, 63, img.ColorRgb8(100, 50, 10));
      img.drawLine(image, 48, 0, 48, 63, img.ColorRgb8(100, 50, 10));
      img.drawRect(image, 0, 0, 63, 63, img.ColorRgb8(80, 40, 10));
    }
    for (int y = 0; y < 2; y++) {
      for (int x = 0; x < 2; x++) {
        final subImage = img.copyCrop(image, x * 32, y * 32, 32, 32);
        File('../assets/map/${name}_${x}_${y}.png').writeAsBytesSync(img.encodePng(subImage));
        print('Generated ../assets/map/${name}_${x}_${y}.png');
      }
    }
  });

  // Generate wood resources (16x16)
  woodResources.forEach((name, data) {
    final image = img.Image(width: 16, height: 16);
    img.fill(image, color: img.ColorRgb8(0, 0, 0, 0));
    img.ColorRgb8 foliageColor = data['color'] as img.ColorRgb8;
    if (data['biome'] == 'cave' || data['biome'] == 'deep_cave') {
      foliageColor = img.ColorRgb8(
        (foliageColor.r * 0.7).round(),
        (foliageColor.g * 0.7).round(),
        (foliageColor.b * 0.7).round(),
      );
    }
    img.fillRect(image, 6, 10, 9, 14, img.ColorRgb8(139, 69, 19));
    img.fillCircle(image, 7, 6, 4, foliageColor);
    addPerlinNoise(image, foliageColor, 0.2);
    drawPixelText(image, name[0].toUpperCase(), 2, 2, img.ColorRgb8(255, 255, 255));
    img.drawRect(image, 5, 5, 10, 14, img.ColorRgb8(50, 50, 50));
    File('../assets/resources/$name.png').writeAsBytesSync(img.encodePng(image));
    print('Generated ../assets/resources/$name.png');
  });

  // Generate metal resources (16x16)
  metalResources.forEach((name, data) {
    final image = img.Image(width: 16, height: 16);
    img.fill(image, color: img.ColorRgb8(0, 0, 0, 0));
    img.ColorRgb8 metalColor = data['color'] as img.ColorRgb8;
    if (data['biome'] == 'cave' || data['biome'] == 'deep_cave') {
      metalColor = img.ColorRgb8(
        (metalColor.r * 0.8).round(),
        (metalColor.g * 0.8).round(),
        (metalColor.b * 0.8).round(),
      );
    }
    img.fillPolygon(image, [4, 4, 12, 4, 10, 10, 6, 10], metalColor);
    addPerlinNoise(image, metalColor, 0.2);
    img.drawPixel(image, 5, 5, img.ColorRgb8(255, 255, 255));
    drawPixelText(image, name[0].toUpperCase(), 2, 2, img.ColorRgb8(255, 255, 255));
    img.drawPolygon(image, [4, 4, 12, 4, 10, 10, 6, 10], img.ColorRgb8(50, 50, 50));
    File('../assets/resources/$name.png').writeAsBytesSync(img.encodePng(image));
    print('Generated ../assets/resources/$name.png');
  });

  // Generate player and monster sprites (32x32)
  entities.forEach((name, color) {
    final image = img.Image(width: 32, height: 32);
    img.fill(image, color: img.ColorRgb8(0, 0, 0, 0));
    if (name == 'player') {
      img.fillCircle(image, 16, 8, 4, color);
      img.fillRect(image, 12, 12, 19, 24, color);
      img.drawLine(image, 20, 12, 24, 16, img.ColorRgb8(100, 100, 100));
      addPerlinNoise(image, color, 0.1);
      img.drawRect(image, 12, 12, 19, 24, img.ColorRgb8(50, 50, 50));
    } else if (name == 'bandit') {
      img.fillCircle(image, 16, 8, 4, color);
      img.fillRect(image, 12, 12, 19, 24, color);
      img.drawLine(image, 20, 12, 24, 12, img.ColorRgb8(0, 0, 0));
      addPerlinNoise(image, color, 0.1);
      img.drawRect(image, 12, 12, 19, 24, img.ColorRgb8(50, 50, 50));
    } else if (['wolf', 'boar', 'bear'].contains(name)) {
      img.fillRect(image, 8, 12, 23, 20, color);
      img.fillCircle(image, 10, 10, 3, color);
      img.drawPixel(image, 8, 8, img.ColorRgb8(255, 255, 255));
      addPerlinNoise(image, color, 0.1);
      img.drawRect(image, 8, 12, 23, 20, img.ColorRgb8(50, 50, 50));
    } else if (name == 'dragon') {
      img.fillRect(image, 10, 14, 22, 22, color);
      img.drawLine(image, 8, 12, 10, 10, color);
      img.drawLine(image, 24, 12, 22, 10, color);
      img.fillCircle(image, 10, 10, 4, color);
      addPerlinNoise(image, color, 0.1);
      img.drawRect(image, 10, 14, 22, 22, img.ColorRgb8(50, 50, 50));
    } else if (['cave_guardian', 'deep_cave_overlord'].contains(name)) {
      img.fillCircle(image, 16, 16, 12, color);
      img.fillCircle(image, 16, 8, 6, color);
      img.drawPixel(image, 14, 6, img.ColorRgb8(255, 255, 255));
      addPerlinNoise(image, color, 0.1);
      img.drawCircle(image, 16, 16, 12, img.ColorRgb8(50, 50, 50));
    } else {
      img.fillRect(image, 10, 10, 21, 21, color);
      img.fillCircle(image, 12, 8, 4, color);
      img.drawPixel(image, 10, 6, img.ColorRgb8(255, 255, 255));
      addPerlinNoise(image, color, 0.1);
      img.drawRect(image, 10, 10, 21, 21, img.ColorRgb8(50, 50, 50));
    }
    File('../assets/entities/$name.png').writeAsBytesSync(img.encodePng(image));
    print('Generated ../assets/entities/$name.png');
  });
}