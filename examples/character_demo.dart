import 'package:lumberjack_rpg/character_system.dart';

/// Example demonstrating the character rendering system
/// This shows how to use ASCII, Unicode, and SVG modes
void main() {
  print('═' * 70);
  print('Character Rendering System Demo');
  print('═' * 70);
  print('');
  
  // Demo 1: ASCII Mode
  print('--- ASCII Mode ---');
  CharacterConfig.currentMode = RenderMode.ascii;
  demonstrateCharacters();
  
  print('');
  
  // Demo 2: Unicode Mode
  print('--- Unicode Mode (Emoji) ---');
  CharacterConfig.currentMode = RenderMode.unicode;
  demonstrateCharacters();
  
  print('');
  
  // Demo 3: Character Details
  print('--- Character Details ---');
  showCharacterDetails(GameCharacters.player);
  showCharacterDetails(GameCharacters.wolf);
  showCharacterDetails(GameCharacters.dragon);
  
  print('');
  
  // Demo 4: Simple Map
  print('--- Simple Map View ---');
  CharacterConfig.currentMode = RenderMode.unicode;
  displaySimpleMap();
  
  print('');
  
  // Demo 5: Status Display
  print('--- Status Display ---');
  displayStatus();
}

void demonstrateCharacters() {
  print('Player:    ${GameCharacters.player.display}');
  print('Forest:    ${GameCharacters.forest.display}');
  print('Mountain:  ${GameCharacters.mountain.display}');
  print('Cave:      ${GameCharacters.cave.display}');
  print('Water:     ${GameCharacters.water.display}');
  print('Road:      ${GameCharacters.road.display}');
  print('Wolf:      ${GameCharacters.wolf.display}');
  print('Bear:      ${GameCharacters.bear.display}');
  print('Dragon:    ${GameCharacters.dragon.display}');
  print('Wood:      ${GameCharacters.wood.display}');
  print('Metal:     ${GameCharacters.metal.display}');
  print('Sawmill:   ${GameCharacters.sawmill.display}');
  print('Inn:       ${GameCharacters.inn.display}');
  print('Town:      ${GameCharacters.town.display}');
  print('Treasure:  ${GameCharacters.treasure.display}');
  print('Gold:      ${GameCharacters.gold.display}');
}

void showCharacterDetails(GameCharacter char) {
  print('');
  print('${char.name}:');
  print('  ASCII:   "${char.ascii}"');
  print('  Unicode: "${char.unicode}"');
  print('  SVG:     ${char.svgPath ?? "none"}');
}

void displaySimpleMap() {
  // Create a small example map
  final map = <List<GameCharacter>>[
    [GameCharacters.forest, GameCharacters.forest, GameCharacters.mountain, GameCharacters.mountain, GameCharacters.forest],
    [GameCharacters.forest, GameCharacters.road, GameCharacters.road, GameCharacters.mountain, GameCharacters.forest],
    [GameCharacters.road, GameCharacters.road, GameCharacters.town, GameCharacters.road, GameCharacters.road],
    [GameCharacters.forest, GameCharacters.wood, GameCharacters.road, GameCharacters.forest, GameCharacters.cave],
    [GameCharacters.water, GameCharacters.water, GameCharacters.forest, GameCharacters.forest, GameCharacters.cave],
  ];
  
  final rendered = CharacterRenderer.renderMapView(map, width: 5, height: 5);
  print(rendered);
  print('Legend:');
  print('  ${GameCharacters.town.display} = Town');
  print('  ${GameCharacters.forest.display} = Forest');
  print('  ${GameCharacters.mountain.display} = Mountain');
  print('  ${GameCharacters.cave.display} = Cave');
  print('  ${GameCharacters.water.display} = Water');
  print('  ${GameCharacters.road.display} = Road');
  print('  ${GameCharacters.wood.display} = Wood resource');
}

void displayStatus() {
  // Day status
  print('Daytime: ${CharacterRenderer.timeIndicator(true)} Day');
  print('Nighttime: ${CharacterRenderer.timeIndicator(false)} Night');
  print('');
  
  // Player status
  final status = CharacterRenderer.statusBar(85, 100, 5, 450);
  print(status);
  print('');
  
  // Combat example
  print('Combat:');
  print('  ${GameCharacters.player.display} Player (HP: 85/100) vs ${GameCharacters.wolf.display} Wolf (HP: 40/60)');
  print('  ${GameCharacters.player.display} deals 15 damage! ${GameCharacters.star.display} +20 XP');
  print('');
  
  // Town info
  print('Town:');
  print('  ${GameCharacters.town.display} Ironwood Village');
  print('  Buildings:');
  print('    ${GameCharacters.sawmill.display} Sawmill (Level 2)');
  print('    ${GameCharacters.blacksmith.display} Blacksmith (Level 1)');
  print('    ${GameCharacters.inn.display} Inn (Level 1)');
  print('  Resources:');
  print('    ${GameCharacters.wood.display} Wood: 150');
  print('    ${GameCharacters.metal.display} Iron: 75');
  print('    ${GameCharacters.gold.display} Gold: 320');
}
