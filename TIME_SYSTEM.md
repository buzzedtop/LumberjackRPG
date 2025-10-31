# Move-Based Time System

## Overview
LumberjackRPG features a **move-based time system** where every action you take advances the game time. This creates strategic gameplay where you must balance exploration, resource gathering, and building construction with the passage of time.

## How It Works

### Time Progression
- **Starting Time**: Day 1, 8:00 AM
- **Time Format**: Day X, HH:MM AM/PM
- **Every action advances time** by a specific duration
- **No free actions** (except viewing inventory/info)

### Time of Day
The game recognizes four periods:
- **Morning**: 5:00 AM - 11:59 AM
- **Afternoon**: 12:00 PM - 4:59 PM
- **Evening**: 5:00 PM - 8:59 PM
- **Night**: 9:00 PM - 4:59 AM ⚠️ (Monsters more dangerous!)

### Day/Night Cycle
- Each day has 24 hours
- Night time (10 PM - 6 AM) affects gameplay:
  - Monsters are more dangerous
  - Reduced visibility (future feature)
  - Some buildings may not operate

## Action Time Costs

### Movement & Exploration
| Action | Time Cost | Description |
|--------|-----------|-------------|
| Move one tile | 10 minutes | Walk to adjacent tile |
| Enter town | 5 minutes | Enter town area |
| Rest | 60 minutes | Restore 25% health |

### Resource Gathering
| Action | Time Cost | Description |
|--------|-----------|-------------|
| Chop wood | 30 minutes | Harvest wood resource |
| Mine metal | 45 minutes | Extract metal ore |

### Combat
| Action | Time Cost | Description |
|--------|-----------|-------------|
| Attack monster | 15 minutes | Single combat round |
| Flee combat | 10 minutes | Escape from battle |

### Town Actions
| Action | Time Cost | Description |
|--------|-----------|-------------|
| Build structure | 2 hours | Construct building |
| Collect treasure | 20 minutes | Loot dungeon treasure |
| Deposit inventory | 15 minutes | Transfer resources to town |
| Upgrade building | 1 hour | Improve existing building |

### Free Actions (No Time Cost)
- View inventory
- View map info
- View building info
- View town status
- Check game time

## Strategic Considerations

### Time Management
1. **Plan your routes**: Moving takes time, so optimize travel paths
2. **Resource efficiency**: Mining metal takes longer than chopping wood
3. **Combat timing**: Each attack takes 15 minutes - prolonged fights are costly
4. **Building schedule**: Construction takes 2 hours - plan accordingly

### Day Planning Example
**Day 1 Strategy:**
```
08:00 AM - Start at spawn point
08:10 AM - Move to forest (10 min)
08:40 AM - Chop wood (30 min)
09:10 AM - Move to ore deposit (10 min)
09:55 AM - Mine metal (45 min)
10:05 AM - Move to town (10 min)
10:20 AM - Deposit inventory (15 min)
12:20 PM - Build sawmill (2 hours)
12:50 PM - Move to dungeon entrance (30 min, multiple moves)
01:05 PM - Fight goblin (15 min)
01:20 PM - Fight cave troll (15 min)
01:40 PM - Collect treasure (20 min)
02:00 PM - Rest and plan next moves
```

## Resource Production Timing

### Building Production Cycles
- Buildings produce resources **every 6 game hours** (360 minutes)
- Production occurs at: 12 PM, 6 PM, 12 AM, 6 AM
- **New day bonus**: Extra production when day changes

### Example Production Timeline
```
Day 1, 08:00 AM - Sawmill built
Day 1, 12:00 PM - First production (5 planks)
Day 1, 06:00 PM - Second production (5 planks)
Day 2, 12:00 AM - Third production + new day bonus (5 planks + bonus)
Day 2, 06:00 AM - Fourth production (5 planks)
```

## Night-Time Effects

### Dangers at Night
When time is between 10 PM and 6 AM:
- ⚠️ **Warning message** displayed
- Monsters deal +20% damage (future feature)
- Lower chance to find resources (future feature)
- Some buildings shut down (future feature)

### Night Strategy
1. **Avoid combat** if possible
2. **Stay in town** for safety
3. **Rest** to pass time quickly
4. **Plan** next day's activities

## Time-Based Events

### Daily Events
- **Dawn (6 AM)**: New day begins, building production
- **Noon (12 PM)**: Production cycle
- **Dusk (6 PM)**: Production cycle
- **Midnight (12 AM)**: Production cycle, night intensifies

### Future Events (Planned)
- **Weekly market**: Special traders on Day 7, 14, 21...
- **Seasonal changes**: Every 30 days
- **Festival days**: Special bonuses on certain days
- **Monster raids**: Periodic challenges

## Advanced Time Management

### Speed Running Tips
1. **Minimize movement**: Plan efficient routes
2. **Batch activities**: Do all resource gathering in one area
3. **Combat quickly**: High damage = shorter fights
4. **Build early**: Start production ASAP
5. **Night skip**: Rest during dangerous hours

### Long-Term Strategy
1. **First week**: Establish resource base
2. **Second week**: Build infrastructure
3. **Third week**: Explore dungeons
4. **Fourth week**: Maximize production

### Time Optimization
**Bad Strategy:**
```
- Random wandering: wastes 30-60 minutes
- Fighting weak monsters: 15 min for low XP
- Building without resources: wasted trip
```

**Good Strategy:**
```
- Targeted exploration: specific goals
- Fight appropriate level enemies: efficient XP
- Gather before building: one trip to town
```

## Time Display

### HUD Information
The game always shows:
```
Time: Day 3, 2:45 PM (Afternoon)
Turn: 127
```

### Time Tracking
- **Total days**: Tracks overall progress
- **Turn count**: Number of actions taken
- **Total minutes**: Complete time elapsed

### End Game Statistics
Upon completion or death:
```
Final Statistics:
  Game Time: Day 15, 6:30 PM
  Total Days: 15
  Turns played: 543
  Total time: 21,870 minutes (15.2 days)
```

## Gameplay Examples

### Example 1: Resource Gathering Day
```
Start: Day 2, 7:00 AM
07:00 - Leave town
07:40 - Arrive at forest (4 moves = 40 min)
08:10 - Chop oak (30 min)
08:40 - Chop maple (30 min)
09:10 - Move to mountain (30 min)
09:55 - Mine iron (45 min)
10:40 - Mine steel (45 min)
11:30 - Return to town (50 min)
11:45 - Deposit resources (15 min)
Result: 2 wood, 2 metal gained in 4 hours 45 minutes
```

### Example 2: Dungeon Expedition
```
Start: Day 5, 1:00 PM
01:00 - Enter dungeon well
01:15 - Fight Goblin (15 min)
01:30 - Fight Cave Troll (15 min)
01:50 - Collect treasure (20 min)
02:05 - Descend to Depths (15 min)
02:20 - Fight Cave Guardian (15 min)
02:50 - Fight Dragon (30 min, tough enemy)
03:10 - Collect treasure (20 min)
04:10 - Rest (60 min)
05:10 - Exit dungeon
Result: 2 levels cleared, treasures collected in 4 hours 10 minutes
```

### Example 3: Building Economy
```
Start: Day 10, 8:00 AM
08:00 - Check resources
08:15 - Build Water Wheel (2 hours)
10:15 - Build Blacksmith (2 hours)
12:15 - [Production cycle occurs - all buildings produce]
12:30 - Build Workshop (2 hours)
02:30 - Rest and wait for next cycle
06:30 - [Production cycle - 4 buildings producing]
Result: 3 buildings built, 2 production cycles in 10.5 hours
```

## Tips and Tricks

### Efficient Time Use
1. **Multi-task**: Plan routes that hit multiple resources
2. **Production awareness**: Build before production cycles
3. **Combat preparation**: Fight at full health to minimize time
4. **Rest strategically**: Use rest to skip dangerous hours

### Time Sinks to Avoid
1. **Aimless wandering**: Always have a destination
2. **Unnecessary combat**: Fight for XP/loot, not randomly
3. **Building too early**: Ensure you have all resources first
4. **Ignoring production**: Check town regularly

### Maximizing Productivity
1. **Early buildings**: Start production ASAP
2. **Efficient gathering**: Clear entire resource area at once
3. **Dungeon timing**: Go when fully prepared
4. **Town visits**: Batch multiple activities

## Future Enhancements

### Planned Features
- **Time-based quests**: Complete objectives within time limits
- **Seasonal weather**: Affects travel and gathering times
- **Fatigue system**: Need to rest more after extended play
- **Time magic**: Spells to slow/speed time
- **Fast travel**: Reduce movement time for gold
- **Building automation**: Hire workers to reduce construction time

### Community Suggestions
- Time reversal items (rare/expensive)
- Speed potions (reduce action times)
- Calendar system with special dates
- Time trials (speed-run challenges)
- Multiplayer time synchronization

## Conclusion

The move-based time system adds strategic depth to LumberjackRPG. Every decision matters because time is a precious resource. Plan carefully, manage your time wisely, and watch your medieval empire grow day by day!

**Remember**: In this game, time waits for no lumberjack! ⏰🪓
