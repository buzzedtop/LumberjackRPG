/// Character Rendering System
/// Supports ASCII, Unicode, and SVG character rendering with easy switching

enum RenderMode {
  ascii,      // Basic ASCII characters
  unicode,    // Extended Unicode characters (emoji, box drawing)
  svg,        // SVG file-based rendering
}

/// Configuration for character rendering
class CharacterConfig {
  static RenderMode currentMode = RenderMode.unicode; // Default to unicode
  static bool useFallback = true; // Fallback to ASCII if SVG unavailable
  
  /// Base path for SVG assets
  static String svgBasePath = 'assets/svg/';
  
  /// Enable/disable SVG caching
  static bool cacheSvgs = true;
  
  /// Reset configuration to defaults (useful for testing)
  static void reset() {
    currentMode = RenderMode.unicode;
    useFallback = true;
    svgBasePath = 'assets/svg/';
    cacheSvgs = true;
  }
}

/// Represents a character that can be rendered in multiple formats
class GameCharacter {
  final String name;
  final String ascii;        // ASCII representation (1-2 chars)
  final String unicode;      // Unicode/emoji representation
  final String? svgPath;     // Path to SVG file
  final String? fallback;    // Fallback if SVG fails to load
  
  const GameCharacter({
    required this.name,
    required this.ascii,
    required this.unicode,
    this.svgPath,
    this.fallback,
  });
  
  /// Get the character representation based on current render mode
  String get display {
    switch (CharacterConfig.currentMode) {
      case RenderMode.ascii:
        return ascii;
      case RenderMode.unicode:
        return unicode;
      case RenderMode.svg:
        // In terminal/text mode, fall back to unicode
        return unicode;
    }
  }
  
  /// Get SVG path if available
  String? get svg => svgPath != null 
      ? '${CharacterConfig.svgBasePath}$svgPath'
      : null;
}

/// Character definitions for all game entities
class GameCharacters {
  // Player
  static const player = GameCharacter(
    name: 'Player',
    ascii: '@',
    unicode: '🪓',  // Axe emoji
    svgPath: 'player.svg',
  );
  
  // Terrain
  static const forest = GameCharacter(
    name: 'Forest',
    ascii: '^',
    unicode: '🌲',  // Tree
    svgPath: 'terrain/forest.svg',
  );
  
  static const mountain = GameCharacter(
    name: 'Mountain',
    ascii: 'M',
    unicode: '⛰️',  // Mountain
    svgPath: 'terrain/mountain.svg',
  );
  
  static const cave = GameCharacter(
    name: 'Cave',
    ascii: 'O',
    unicode: '🕳️',  // Hole
    svgPath: 'terrain/cave.svg',
  );
  
  static const deepCave = GameCharacter(
    name: 'Deep Cave',
    ascii: 'o',
    unicode: '⚫',  // Black circle
    svgPath: 'terrain/deep_cave.svg',
  );
  
  static const water = GameCharacter(
    name: 'Water',
    ascii: '~',
    unicode: '💧',  // Water droplet
    svgPath: 'terrain/water.svg',
  );
  
  static const road = GameCharacter(
    name: 'Road',
    ascii: '.',
    unicode: '🛤️',  // Railway track (closest to road)
    svgPath: 'terrain/road.svg',
  );
  
  // Resources
  static const wood = GameCharacter(
    name: 'Wood',
    ascii: 'w',
    unicode: '🪵',  // Wood
    svgPath: 'resources/wood.svg',
  );
  
  static const metal = GameCharacter(
    name: 'Metal',
    ascii: 'm',
    unicode: '⛏️',  // Pickaxe
    svgPath: 'resources/metal.svg',
  );
  
  // Monsters
  static const wolf = GameCharacter(
    name: 'Wolf',
    ascii: 'W',
    unicode: '🐺',  // Wolf
    svgPath: 'monsters/wolf.svg',
  );
  
  static const boar = GameCharacter(
    name: 'Boar',
    ascii: 'B',
    unicode: '🐗',  // Boar
    svgPath: 'monsters/boar.svg',
  );
  
  static const bandit = GameCharacter(
    name: 'Bandit',
    ascii: 'b',
    unicode: '🗡️',  // Dagger
    svgPath: 'monsters/bandit.svg',
  );
  
  static const bear = GameCharacter(
    name: 'Bear',
    ascii: 'R',
    unicode: '🐻',  // Bear
    svgPath: 'monsters/bear.svg',
  );
  
  static const troll = GameCharacter(
    name: 'Troll',
    ascii: 'T',
    unicode: '👹',  // Ogre
    svgPath: 'monsters/troll.svg',
  );
  
  static const goblin = GameCharacter(
    name: 'Goblin',
    ascii: 'g',
    unicode: '👺',  // Goblin
    svgPath: 'monsters/goblin.svg',
  );
  
  static const dragon = GameCharacter(
    name: 'Dragon',
    ascii: 'D',
    unicode: '🐉',  // Dragon
    svgPath: 'monsters/dragon.svg',
  );
  
  // Buildings
  static const sawmill = GameCharacter(
    name: 'Sawmill',
    ascii: 'S',
    unicode: '🏭',  // Factory
    svgPath: 'buildings/sawmill.svg',
  );
  
  static const waterWheel = GameCharacter(
    name: 'Water Wheel',
    ascii: 'H',
    unicode: '⚙️',  // Gear
    svgPath: 'buildings/water_wheel.svg',
  );
  
  static const inn = GameCharacter(
    name: 'Inn',
    ascii: 'I',
    unicode: '🏠',  // House
    svgPath: 'buildings/inn.svg',
  );
  
  static const blacksmith = GameCharacter(
    name: 'Blacksmith',
    ascii: 'F',
    unicode: '⚒️',  // Hammer and pick
    svgPath: 'buildings/blacksmith.svg',
  );
  
  static const workshop = GameCharacter(
    name: 'Workshop',
    ascii: 'K',
    unicode: '🔨',  // Hammer
    svgPath: 'buildings/workshop.svg',
  );
  
  static const storehouse = GameCharacter(
    name: 'Storehouse',
    ascii: 'X',
    unicode: '📦',  // Package
    svgPath: 'buildings/storehouse.svg',
  );
  
  static const town = GameCharacter(
    name: 'Town',
    ascii: '#',
    unicode: '🏘️',  // Houses
    svgPath: 'buildings/town.svg',
  );
  
  static const well = GameCharacter(
    name: 'Well',
    ascii: 'U',
    unicode: '🕳️',  // Hole (dungeon entrance)
    svgPath: 'buildings/well.svg',
  );
  
  // Items
  static const axeStone = GameCharacter(
    name: 'Stone Axe',
    ascii: 'a',
    unicode: '🪓',  // Axe
    svgPath: 'items/axe_stone.svg',
  );
  
  static const axeIron = GameCharacter(
    name: 'Iron Axe',
    ascii: 'A',
    unicode: '⚔️',  // Crossed swords
    svgPath: 'items/axe_iron.svg',
  );
  
  static const treasure = GameCharacter(
    name: 'Treasure',
    ascii: '$',
    unicode: '💰',  // Money bag
    svgPath: 'items/treasure.svg',
  );
  
  static const gold = GameCharacter(
    name: 'Gold',
    ascii: '*',
    unicode: '🪙',  // Coin
    svgPath: 'items/gold.svg',
  );
  
  // UI Elements
  static const heart = GameCharacter(
    name: 'Health',
    ascii: 'H',
    unicode: '❤️',  // Red heart
    svgPath: 'ui/heart.svg',
  );
  
  static const star = GameCharacter(
    name: 'Experience',
    ascii: '*',
    unicode: '⭐',  // Star
    svgPath: 'ui/star.svg',
  );
  
  static const clock = GameCharacter(
    name: 'Time',
    ascii: 'T',
    unicode: '⏰',  // Alarm clock
    svgPath: 'ui/clock.svg',
  );
  
  static const sun = GameCharacter(
    name: 'Day',
    ascii: 'O',
    unicode: '☀️',  // Sun
    svgPath: 'ui/sun.svg',
  );
  
  static const moon = GameCharacter(
    name: 'Night',
    ascii: 'C',
    unicode: '🌙',  // Crescent moon
    svgPath: 'ui/moon.svg',
  );
  
  /// Get character by name
  static GameCharacter? getByName(String name) {
    // You can implement a lookup map if needed
    switch (name.toLowerCase()) {
      case 'player': return player;
      case 'wolf': return wolf;
      case 'boar': return boar;
      case 'bear': return bear;
      case 'dragon': return dragon;
      case 'goblin': return goblin;
      case 'troll': return troll;
      case 'bandit': return bandit;
      case 'wood': return wood;
      case 'metal': return metal;
      default: return null;
    }
  }
}

/// Helper class for rendering maps with characters
class CharacterRenderer {
  /// Render a simple map view with characters
  static String renderMapView(List<List<GameCharacter>> map, {
    int width = 20,
    int height = 10,
  }) {
    final buffer = StringBuffer();
    
    for (int y = 0; y < height && y < map.length; y++) {
      for (int x = 0; x < width && x < map[y].length; x++) {
        buffer.write(map[y][x].display);
      }
      buffer.writeln();
    }
    
    return buffer.toString();
  }
  
  /// Create a simple status bar with character icons
  static String statusBar(int health, int maxHealth, int level, int xp) {
    final char = GameCharacters.heart.display;
    final starChar = GameCharacters.star.display;
    
    return '$char HP: $health/$maxHealth | $starChar Level: $level (XP: $xp)';
  }
  
  /// Get time indicator based on time of day
  static String timeIndicator(bool isDay) {
    return isDay 
        ? GameCharacters.sun.display 
        : GameCharacters.moon.display;
  }
}
