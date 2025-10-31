# Game Design: Terminal Edition Features

## Game Mode Flow
```
┌─────────────────────────────────────────────────────────────┐
│                    LUMBERJACK RPG                            │
│                   Terminal Edition                           │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
                    ┌───────────────┐
                    │ EXPLORATION   │◄─────┐
                    │    MODE       │      │
                    └───────────────┘      │
                      │           │        │
         ┌────────────┘           └────────┤
         │                                 │
         ▼                                 │
    ┌─────────┐                           │
    │  TOWN   │                           │
    │  MODE   │                           │
    └─────────┘                           │
         │                                 │
         ▼                                 │
    ┌─────────┐                           │
    │ DUNGEON │                           │
    │  MODE   │──────────────────────────┘
    └─────────┘
```

## Building System Overview

### Town Buildings
```
╔════════════════════════════════════════════════════════════╗
║                    IRONWOOD VILLAGE                        ║
╚════════════════════════════════════════════════════════════╝

┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│   SAWMILL    │  │ WATER WHEEL  │  │     INN      │
├──────────────┤  ├──────────────┤  ├──────────────┤
│ Cost:        │  │ Cost:        │  │ Cost:        │
│  50 wood     │  │  30 wood     │  │  40 wood     │
│  20 iron     │  │  15 iron     │  │  20 planks   │
├──────────────┤  ├──────────────┤  ├──────────────┤
│ Produces:    │  │ Produces:    │  │ Produces:    │
│  5 planks/t  │  │  10 power/t  │  │  2 gold/t    │
└──────────────┘  └──────────────┘  └──────────────┘

┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  BLACKSMITH  │  │   WORKSHOP   │  │  STOREHOUSE  │
├──────────────┤  ├──────────────┤  ├──────────────┤
│ Cost:        │  │ Cost:        │  │ Cost:        │
│  30 wood     │  │  35 wood     │  │  60 wood     │
│  25 iron     │  │  15 planks   │  │  30 planks   │
│              │  │  10 iron     │  │              │
├──────────────┤  ├──────────────┤  ├──────────────┤
│ Produces:    │  │ Produces:    │  │ Produces:    │
│  3 tools/t   │  │  4 goods/t   │  │  (storage)   │
└──────────────┘  └──────────────┘  └──────────────┘

(t = per turn)
```

## Dungeon Layout

### The Ancient Well Dungeon
```
         TOWN
           │
           ▼
    ┌──────────┐
    │   WELL   │  ← Entry point in town center
    └────┬─────┘
         │
         ▼
╔════════════════════════════════════════════════════════════╗
║  ENTRANCE LEVEL                                            ║
╠════════════════════════════════════════════════════════════╣
║  Monsters:  Goblin (Lv 7)                                  ║
║             Cave Troll (Lv 8)                              ║
║  Treasure:  50 gold, 10 iron                               ║
╚════════════════════════════════════════════════════════════╝
         │
         ▼ (defeat all monsters to descend)
╔════════════════════════════════════════════════════════════╗
║  THE DEPTHS                                                ║
╠════════════════════════════════════════════════════════════╣
║  Monsters:  Cave Guardian (Lv 9)                           ║
║             Dragon (Lv 10)                                 ║
║  Treasure:  100 gold, 15 steel, 1 ancient artifact         ║
╚════════════════════════════════════════════════════════════╝
         │
         ▼ (defeat all monsters to descend)
╔════════════════════════════════════════════════════════════╗
║  THE ABYSS                                                 ║
╠════════════════════════════════════════════════════════════╣
║  Monsters:  Abyssal Fiend (Lv 11)                          ║
║             Deep Cave Overlord (Lv 12)                     ║
║  Treasure:  200 gold, 20 titanium, 1 legendary item        ║
╚════════════════════════════════════════════════════════════╝
```

## Resource Flow

### Collection and Production
```
EXPLORATION                    TOWN                    BUILDINGS
     │                          │                          │
     ▼                          ▼                          ▼
┌─────────┐              ┌────────────┐           ┌──────────────┐
│  Chop   │              │  Deposit   │           │   Produce    │
│  Wood   │─────────────▶│ Inventory  │──────────▶│  Resources   │
└─────────┘              └────────────┘           └──────────────┘
┌─────────┐                    │                        │
│  Mine   │                    │                        │
│  Metal  │────────────────────┘                        │
└─────────┘                                              │
                                                         ▼
┌─────────┐              ┌────────────┐           ┌──────────────┐
│ Defeat  │              │   Collect  │           │  Town Storage│
│Monsters │─────────────▶│  Treasure  │──────────▶│  (Centralized)
└─────────┘              └────────────┘           └──────────────┘
```

### Building Construction Flow
```
1. Gather Resources     2. Deposit to Town     3. Build Structure
   (Exploration)           (Town Mode)            (Town Mode)
        │                       │                       │
        ▼                       ▼                       ▼
   ┌─────────┐           ┌─────────┐            ┌─────────┐
   │Wood: 50 │           │Town     │            │Sawmill  │
   │Iron: 20 │──────────▶│Storage  │───────────▶│Created! │
   └─────────┘           └─────────┘            └─────────┘
                              │                       │
                              │                       ▼
                              │                  ┌─────────┐
                              │                  │Produces │
                              │                  │5 planks │
                              │◄─────────────────│per turn │
                              │                  └─────────┘
                              ▼
                         ┌─────────┐
                         │Resources│
                         │Accumulate
                         └─────────┘
```

## Medieval Theme Elements

### Historical Buildings Implemented
1. **Sawmill** - Medieval lumber processing
   - Water or wind powered in historical context
   - Converts logs to usable planks
   - Essential for construction

2. **Water Wheel** - Medieval power generation
   - Harnesses water flow for mechanical power
   - Powers mills and forges
   - Key infrastructure for town development

3. **Inn** - Medieval hospitality
   - Provides lodging for travelers
   - Generates revenue (gold)
   - Social hub of medieval towns

4. **Blacksmith** - Medieval metalworking
   - Forges tools and weapons
   - Essential craft in medieval society
   - Requires both wood (fuel) and iron

5. **Workshop** - Medieval crafting center
   - General purpose production
   - Creates various goods
   - Hub for artisans

6. **Storehouse** - Medieval storage
   - Protects resources from elements
   - Centralized inventory
   - Important for town survival

### Dungeon Theme
- **The Well** - Common medieval mystery element
  - Wells often featured in folklore as gateways
  - Mysterious depths
  - Connection to underworld

## Gameplay Loop

### Turn-Based Progression
```
Turn N                         Turn N+1
  │                              │
  ├─ Player Action               ├─ Player Action
  │  (move, gather, fight)       │
  │                              │
  ├─ State Update                ├─ State Update
  │                              │
  ├─ Buildings Produce           ├─ Buildings Produce
  │  (automatic)                 │  (sawmill → +5 planks)
  │                              │
  └─ Turn Counter ++             └─ Turn Counter ++
```

### Victory Conditions (Suggested)
- Construct all building types
- Clear all dungeon levels
- Reach player level 20
- Accumulate 1000 gold
- Defeat the Deep Cave Overlord

### Death Conditions
- Player health reaches 0
- Can occur in dungeon combat
- Game Over screen displays stats

## Terminal Interface Example

```
╔════════════════════════════════════════════════════════════════════╗
║              LUMBERJACK RPG - Terminal Edition                     ║
╚════════════════════════════════════════════════════════════════════╝

Turn: 42
Mode: town
Position: (21, 21)

Player Status:
  Level: 5
  Health: 120/120
  XP: 450/500
  Axe: iron (Damage: 25)

===== Ironwood Village =====
Position: (21, 21)
Town Well: Yes (Contains dungeon entrance!)

--- Resources ---
wood: 150
iron: 75
planks: 45
gold: 30

--- Buildings ---
[sawmill-1] Sawmill (Level 1)
[inn-1] Inn (Level 1)

Actions:
  [b] Build structure
  [v] View buildings
  [d] Deposit inventory to town
  [w] Enter well (dungeon entrance)
  [e] Exit town
  [q] Quit game

Choose action: _
```

## Future Enhancement Ideas

### Potential Additions
- **Market System**: Trade resources with NPC merchants
- **Villagers**: Hire workers for buildings
- **Seasons**: Affect resource production rates
- **Events**: Random encounters and opportunities
- **Quests**: Goal-driven gameplay
- **Building Upgrades**: Multi-level progression
- **Town Expansion**: Unlock new areas
- **Alliances**: Multiple towns interaction
