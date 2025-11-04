import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'character_system.dart';

/// SVG Loader for game characters
/// Handles loading, caching, and fallback for SVG assets
class SvgCharacterLoader {
  // Cache for loaded SVG pictures
  static final Map<String, ui.Picture> _pictureCache = {};
  
  // Cache for rasterized images
  static final Map<String, ui.Image> _imageCache = {};
  
  /// Load an SVG file and return as a Picture
  static Future<ui.Picture?> loadSvgPicture(String assetPath) async {
    // Check cache first
    if (_pictureCache.containsKey(assetPath)) {
      return _pictureCache[assetPath];
    }
    
    try {
      final String svgString = await rootBundle.loadString(assetPath);
      final DrawableRoot svgRoot = await svg.fromSvgString(svgString, assetPath);
      final ui.Picture picture = svgRoot.toPicture();
      
      // Cache it
      if (CharacterConfig.cacheSvgs) {
        _pictureCache[assetPath] = picture;
      }
      
      return picture;
    } catch (e) {
      print('Error loading SVG from $assetPath: $e');
      return null;
    }
  }
  
  /// Load an SVG and rasterize it to a ui.Image
  static Future<ui.Image?> loadSvgAsImage(
    String assetPath, {
    double width = 32.0,
    double height = 32.0,
  }) async {
    final cacheKey = '${assetPath}_${width}x$height';
    
    // Check cache first
    if (_imageCache.containsKey(cacheKey)) {
      return _imageCache[cacheKey];
    }
    
    try {
      final picture = await loadSvgPicture(assetPath);
      if (picture == null) return null;
      
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      canvas.scale(width / 100, height / 100); // Assuming 100x100 SVG viewBox
      canvas.drawPicture(picture);
      
      final ui.Picture scaledPicture = recorder.endRecording();
      final ui.Image image = await scaledPicture.toImage(
        width.toInt(),
        height.toInt(),
      );
      
      // Cache it
      if (CharacterConfig.cacheSvgs) {
        _imageCache[cacheKey] = image;
      }
      
      return image;
    } catch (e) {
      print('Error converting SVG to image: $e');
      return null;
    }
  }
  
  /// Load a character's SVG representation
  static Future<ui.Image?> loadCharacterImage(
    GameCharacter character, {
    double size = 32.0,
  }) async {
    final svgPath = character.svg;
    if (svgPath == null) return null;
    
    return await loadSvgAsImage(svgPath, width: size, height: size);
  }
  
  /// Batch load multiple characters
  static Future<Map<String, ui.Image>> loadCharacters(
    List<GameCharacter> characters, {
    double size = 32.0,
  }) async {
    final Map<String, ui.Image> loadedCharacters = {};
    
    for (final character in characters) {
      final image = await loadCharacterImage(character, size: size);
      if (image != null) {
        loadedCharacters[character.name] = image;
      }
    }
    
    return loadedCharacters;
  }
  
  /// Clear all caches
  static void clearCache() {
    _pictureCache.clear();
    _imageCache.clear();
  }
  
  /// Preload commonly used characters
  static Future<void> preloadCommonCharacters() async {
    final commonCharacters = [
      GameCharacters.player,
      GameCharacters.forest,
      GameCharacters.mountain,
      GameCharacters.water,
      GameCharacters.wolf,
      GameCharacters.dragon,
      GameCharacters.town,
    ];
    
    await loadCharacters(commonCharacters);
  }
}

/// Widget that displays a game character (with SVG support)
class GameCharacterWidget extends StatelessWidget {
  final GameCharacter character;
  final double size;
  final Color? fallbackColor;
  
  const GameCharacterWidget({
    Key? key,
    required this.character,
    this.size = 32.0,
    this.fallbackColor,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if (CharacterConfig.currentMode == RenderMode.svg && character.svg != null) {
      return FutureBuilder<ui.Image?>(
        future: SvgCharacterLoader.loadCharacterImage(character, size: size),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return CustomPaint(
              size: Size(size, size),
              painter: _ImagePainter(snapshot.data!),
            );
          } else if (snapshot.hasError) {
            // Fallback to unicode
            return _buildFallback();
          } else {
            // Loading
            return SizedBox(
              width: size,
              height: size,
              child: const CircularProgressIndicator(),
            );
          }
        },
      );
    } else {
      return _buildFallback();
    }
  }
  
  Widget _buildFallback() {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      child: Text(
        character.display,
        style: TextStyle(
          fontSize: size * 0.8,
          color: fallbackColor,
        ),
      ),
    );
  }
}

/// Custom painter for ui.Image
class _ImagePainter extends CustomPainter {
  final ui.Image image;
  
  _ImagePainter(this.image);
  
  @override
  void paint(Canvas canvas, Size size) {
    final srcRect = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }
  
  @override
  bool shouldRepaint(_ImagePainter oldDelegate) {
    return oldDelegate.image != image;
  }
}
