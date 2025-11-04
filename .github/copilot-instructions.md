## Repo snapshot for AI contributors

This file gives concise, actionable guidance for an AI coding agent working on LumberjackRPG.
Target: make the agent productive with minimal human prompting.

Key facts
- Core game logic is in `lib/` and is platform-agnostic. See `lib/game_state.dart` (single coordinator), `lib/town.dart`, `lib/dungeon.dart`, `lib/building.dart`.
- Two presentation layers:
  - Terminal: `bin/main.dart` — command-driven, fastest feedback loop (run with `dart run bin/main.dart`).
  - GUI: `lib/main.dart` + `lib/lumberjack_rpg.dart` — Flutter + Flame real-time renderer (run with `flutter run`).
- Assets and Flutter config live in `pubspec.yaml` (`flutter.assets` list). `lib/lumberjack_rpg.dart` has a `usePreGeneratedAssets` flag to toggle generation vs. prebundled assets.

Important patterns and conventions (do not change without reason)
- GameState is the single source of truth. Methods like `advanceTurn()` update time and trigger production; many gameplay actions call `advanceTurn(timeMinutes: ...)` (look for move, chopWood, mineMetal, rest, constructBuildingWithTime).
- Time is measured in minutes. Production cycles use `gameTime.totalMinutes % 360 == 0` (every 360 minutes). Building construction and action durations are encoded in minutes (e.g., construct = 120, move = 10, chop = 30). If changing pacing, update both timing constants and UI messaging.
- Town stores resources and runs `produceResources()`; building definitions/factories live in `lib/building.dart` (createSawmill, createInn, etc.). To add building types: update BuildingType enum, factories in `lib/building.dart`, and the terminal build menu in `bin/main.dart`.
- Dungeon levels are modeled by enum (e.g., `DungeonLevel`) and generated in `lib/dungeon.dart`. To add levels or monsters, update `_generateDungeon()` and `DungeonLevel` usage.

Developer workflows (explicit commands)
- Terminal quick dev loop (no Flutter):
  - Run: `dart run bin/main.dart`
  - Edit logic in `lib/` and re-run to iterate quickly.
- GUI development (Flutter + Flame):
  - Install or update packages: `flutter pub get`
  - Run: `flutter run` (desktop/mobile/web targets supported by Flutter)
- Asset changes: update `pubspec.yaml` `assets:` list and re-run `flutter pub get` before `flutter run`.

Where to look for common changes (examples)
- Adjust game pacing or add new actions: `lib/game_state.dart` (search for `advanceTurn` and action methods like `movePlayer`, `chopWood`).
- New building types: `lib/building.dart` (factory methods) + `bin/main.dart` (terminal build menu + caller `constructBuildingWithTime`).
- GUI rendering tweaks or asset generation: `lib/lumberjack_rpg.dart` (`usePreGeneratedAssets`, `_generateMapImage`, resource/image caching).
- Map and resource layout: `lib/game_map.dart` (tile types, resource maps).

Testing and safety notes for an AI agent
- Avoid large refactors across many files in a single change. Prefer small, isolated PRs that modify one subsystem (e.g., a single building factory and its terminal menu). 
- When adjusting numeric gameplay values (times, costs, production rates), update any user-facing text in `README_TERMINAL.md` if the change affects terminal gameplay.
- No existing unit tests detected. If you add tests, put them under `test/` and keep them narrowly scoped (GameState timing, building production, move bounds).

Example edits the agent can do without asking
- Add a new building: add enum entry in `lib/building.dart`, a `createX()` factory, and wire it into `bin/main.dart` build menu.
- Tune action times: change the minutes in the single method (e.g., `movePlayer`, `chopWood`) and update `README_TERMINAL.md` line with the new times.

If unsure, return diffs that only touch:
- a single `lib/*.dart` file implementing the feature
- the terminal UI `bin/main.dart` (for menu wiring)
- `pubspec.yaml` only for asset or dependency additions

Files to cite in PR descriptions
- `lib/game_state.dart` — central coordinator and turn/time model
- `lib/building.dart` — building definitions/factories
- `bin/main.dart` — terminal interaction flow and menus
- `lib/lumberjack_rpg.dart` — Flame/GUI rendering and asset generation flag
- `README_TERMINAL.md` & `ARCHITECTURE.md` — user-facing docs to keep in sync

Ask for feedback
- If any instruction above is ambiguous or incomplete (missing a specific file reference or timing constant), flag the exact line(s) you relied on and propose the minimal change.

End of guidance.
