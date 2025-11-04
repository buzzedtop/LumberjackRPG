import 'dart:io';
import 'package:lumberjack_terminal_runner/adapter.dart';

// This runner is a thin copy of the project's terminal entrypoint but
// uses relative imports to the repo `lib/` so it can run with plain `dart`.

void main() {
  // Reuse the same logic from the repository's bin/main.dart
  final game = MiniGameState(mapSize: 42);

  print('╔════════════════════════════════════════════════════════════════════╗');
  print('║         Welcome to LumberjackRPG - Terminal Edition!               ║');
  print('╚════════════════════════════════════════════════════════════════════╝');
  print('');
  print('A medieval lumberjack adventure with building mechanics and dungeons!');
  print('⏰ MOVE-BASED TIME SYSTEM: Every action advances game time!');
  print('');

  print('Initializing world...');
  print('✓ Map generated (${game.gameMap.width}x${game.gameMap.height})');
  print('✓ Town created: ${game.town.name}');
  print('✓ Dungeon entrance: Well in town center');
  print('✓ Starting time: ${game.gameTime.getTimeString()}');
  print('');

  bool running = true;
  while (running) {
    displayGameState(game);

    // For the runner we keep a minimal input loop mirroring the repo's logic.
    stdout.write('\nChoose [m]ove, [c]hop, [n]mine, [t]town, [q]quit: ');
    final input = stdin.readLineSync()?.toLowerCase().trim() ?? '';
    switch (input) {
      case 'm':
        // move right as a simple demonstration
        game.movePlayer(1, 0);
        break;
      case 'c':
        game.chopWood();
        break;
      case 'n':
        game.mineMetal();
        break;
      case 't':
        if (game.isInTown()) {
          game.enterTown();
        } else {
          print('Not near town.');
        }
        break;
      case 'q':
        running = false;
        break;
      default:
        print('Unknown action.');
    }
  }

  print('\nThanks for playing LumberjackRPG!');
}

void displayGameState(MiniGameState game) {
  print('\n' + '=' * 70);
  print(game.getSummary());
  if (game.isInTown() && game.currentMode == GameMode.exploration) {
    print('>>> You are near ${game.town.name}! <<<');
  }
}
