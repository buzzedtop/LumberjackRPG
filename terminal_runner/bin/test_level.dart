import 'package:lumberjack_terminal_runner/adapter.dart';

void main() {
  final state = MiniGameState();
  print('Initial level: ${state.player.level}, xp: ${state.player.experience}/${state.player.level * 100}');

  // grant a big chunk of XP via actions to force multiple level-ups
  state.player.addExperience(250); // should level from 1 -> 3 (100 + 200 needed?), let's see

  print('After +250 XP: level: ${state.player.level}, xp: ${state.player.experience}/${state.player.level * 100}');

  // grant more than needed for another level
  state.player.addExperience(180);
  print('After +180 XP: level: ${state.player.level}, xp: ${state.player.experience}/${state.player.level * 100}');
}
