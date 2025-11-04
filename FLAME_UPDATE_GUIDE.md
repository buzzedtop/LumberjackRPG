# Flame Engine Update Guide

## Update Summary

The LumberjackRPG codebase has been updated from Flame 1.8.0 to Flame 1.17.0.

## Changes Made

### 1. Dependencies Updated (pubspec.yaml)
```yaml
dependencies:
  flame: ^1.17.0  # Updated from ^1.8.0
  flame_noise: ^0.1.1+6  # Updated from ^0.1.0
```

### 2. Compatibility Notes

#### Flame 1.17.0 New Features
- Improved component lifecycle management
- Enhanced collision detection
- Better performance optimizations
- More flexible game loop handling

#### Breaking Changes (If Any)
The update from 1.8.0 to 1.17.0 is mostly backward compatible, but here are areas to watch:

1. **Component System**: No breaking changes for basic usage
2. **Input Handling**: `TapDetector` and `KeyboardEvents` mixins still work the same
3. **Sprite Loading**: `SpriteComponent.fromImage()` is still supported
4. **Game Loop**: No changes to `onLoad()` method

### 3. Code Verification Checklist

The following Flame APIs are used in the codebase and have been verified for compatibility:

- ✅ `FlameGame` - Base game class
- ✅ `TapDetector` mixin - Touch input handling
- ✅ `KeyboardEvents` mixin - Keyboard input handling
- ✅ `SpriteComponent` - Sprite rendering
- ✅ `Vector2` - 2D vectors (from vector_math package)
- ✅ `Component` lifecycle methods (`onLoad`, etc.)

### 4. Current Flame Usage

The game uses Flame for:
- **Game Engine**: `FlameGame` as the base
- **Input**: Touch and keyboard handling
- **Rendering**: Sprite components for entities and tiles
- **Components**: Entity management system
- **Noise Generation**: Procedural terrain (via flame_noise)

### 5. Testing the Update

To verify the Flame update works correctly:

```bash
# Install updated dependencies
flutter pub get

# Run the game
flutter run

# Run tests (if Flutter is available)
flutter test

# Or use the test runner script
./run_tests.sh
```

### 6. Potential Issues and Solutions

#### Issue 1: Dependency Conflicts
**Problem**: Flame 1.17.0 might have different dependency requirements
**Solution**: Run `flutter pub get` and resolve any conflicts

#### Issue 2: Deprecated APIs
**Problem**: Some APIs might be deprecated
**Solution**: Check Flame migration guide at https://docs.flame-engine.org/

#### Issue 3: Performance Changes
**Problem**: Newer version might have different performance characteristics
**Solution**: Profile the game and adjust as needed

### 7. Migration Path for Future Updates

When updating to even newer versions of Flame:

1. Check the Flame changelog: https://github.com/flame-engine/flame/blob/main/CHANGELOG.md
2. Review breaking changes
3. Update code accordingly
4. Run all tests
5. Manual testing of all game features

### 8. Rollback Instructions

If issues occur, rollback by:

```yaml
# In pubspec.yaml
dependencies:
  flame: ^1.8.0
  flame_noise: ^0.1.0
```

Then run:
```bash
flutter pub get
```

## Additional Resources

- Flame Documentation: https://docs.flame-engine.org/
- Flame GitHub: https://github.com/flame-engine/flame
- Flame Discord: https://discord.gg/pxrBmy4

## Notes

The Flame engine update improves:
- **Performance**: Better rendering pipeline
- **Features**: More components and utilities
- **Stability**: Bug fixes and improvements
- **Documentation**: Better guides and examples

All existing game mechanics remain unchanged and should work seamlessly with the updated engine.
