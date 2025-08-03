# 2D Top-Down RPG in Flutter: Game Design Document

**Date Created**: August 3, 2025  
**Purpose**: This document outlines the design and implementation details for a 2D top-down RPG developed in Flutter using the Flame game engine. The game features a lumberjack character who gathers wood and metal, crafts various axes, fights biome-specific monsters, and progresses from level 1 to 1,000 over a minimum of 1,000 real-world hours. The design incorporates a wood-metal scale for resources and monsters, ensuring a balanced and engaging progression system.

## 1. Game Overview
- **Genre**: 2D top-down RPG
- **Platform**: Flutter with Flame game engine
- **Core Mechanics**:
  - **Exploration**: Navigate a procedurally generated map with biomes (forest, mountain, cave, deep cave).
  - **Resource Gathering**: Collect wood and metal, with rare resources (e.g., Australian Buloke, Chromium) requiring significant effort.
  - **Crafting**: Create axes with different types, woods, and metals, affecting damage, durability, and speed.
  - **Combat**: Fight monsters scaled to player level and biome, with wood-metal variants (e.g., Oak Tungsten Goblin).
  - **Progression**: Level from 1 to 1,000, requiring ~1,000 hours of gameplay (500 hours combat, 300 hours gathering, 200 hours crafting/exploration).
- **Target Playtime**: Minimum 1,000 hours to reach level 1,000.
- **Player Character**: A lumberjack with stats (strength, stamina, agility, health) and an inventory for wood, metal, and crafted axes.

## 2. Axe Types
A variety of axe types are available, each with unique attributes and crafting requirements, enhancing combat and resource gathering diversity.

| Axe Type           | Description                                                                 | Attributes                                                                 | Crafting Cost         | Gameplay Role                              |
|--------------------|-----------------------------------------------------------------------------|---------------------------------------------------------------------------|-----------------------|--------------------------------------------|
| Hand Axe           | Small, one-handed axe for chopping or combat.                               | Damage: Moderate, Speed: Fast, Range: Melee, Durability: Moderate          | 1 Wood, 1 Metal       | Basic melee weapon, quick attacks.         |
| Dual Hand Axes     | Two hand axes for rapid strikes.                                           | Damage: Moderate (x2), Speed: Very Fast, Range: Melee, Durability: Moderate| 2 Wood, 2 Metal       | High DPS, lower accuracy, dual-wield style.|
| Throwing Axe       | Lightweight axe for throwing.                                              | Damage: Moderate, Speed: Moderate, Range: Short, Durability: Low          | 1 Wood, 1 Metal       | Ranged attack, single-use per throw.       |
| Battle Axe         | Large, two-handed axe for powerful swings.                                 | Damage: High, Speed: Slow, Range: Melee, Durability: High                 | 2 Wood, 3 Metal       | Heavy damage, ideal for strong enemies.    |
| Double-Bitted Axe  | Two blades on a handle, balanced for chopping/combat.                       | Damage: High, Speed: Moderate, Range: Melee, Durability: High             | 2 Wood, 2 Metal       | Versatile, good for chopping and combat.   |
| Felling Axe        | Long-handled axe optimized for cutting trees.                              | Damage: Low, Speed: Slow, Range: Melee, Durability: Very High, Chop Bonus: +50% | 2 Wood, 1 Metal | Best for gathering wood, low combat damage.|
| Broad Axe          | Wide-bladed axe for hewing logs or combat.                                 | Damage: High, Speed: Moderate, Range: Melee, Durability: High             | 2 Wood, 2 Metal       | Good for shaping wood and fighting.        |
| Tomahawk           | Light, versatile axe for melee or throwing.                                | Damage: Moderate, Speed: Fast, Range: Melee/Short, Durability: Moderate   | 1 Wood, 1 Metal       | Melee or short-range throwing, versatile.  |
| Splitting Maul     | Heavy axe with wedge-shaped blade for splitting wood.                      | Damage: Very High, Speed: Very Slow, Range: Melee, Durability: Very High  | 3 Wood, 3 Metal       | High damage, slow, best for tough enemies. |
| Adze               | Tool with perpendicular blade for carving wood, usable in combat.           | Damage: Low, Speed: Moderate, Range: Melee, Durability: Moderate, Craft Bonus: +20% | 1 Wood, 2 Metal | Enhances crafting precision, niche combat use. |

- **Attributes**:
  - **Damage**: Base damage + wood and metal bonuses.
  - **Speed**: Attack cooldown (lower is faster).
  - **Range**: Melee or Short (throwing axes).
  - **Durability**: Uses before breaking, scaled by wood and metal hardness.
  - **Chop Bonus**: Improves wood gathering efficiency (Felling Axe).
  - **Craft Bonus**: Improves crafting quality (Adze).

## 3. Wood-Metal Scale
The wood-metal scale ties resource availability, crafting, and monster difficulty to player levels (1–1,000), ensuring a 1,000-hour progression.

### Wood Types
| Wood Type          | Janka Hardness (lbf) | Rarity     | Biome           | Level Range | Damage Bonus | Notes                                      |
|--------------------|----------------------|------------|-----------------|-------------|--------------|--------------------------------------------|
| Balsa              | 90                   | Common     | Forest          | 1–50        | +1           | Softest, early-game crafting.              |
| Cedar (Spanish)    | 900                  | Common     | Forest          | 1–50        | +3           | Basic axes, abundant.                      |
| Pine (Red)         | 950                  | Common     | Forest          | 1–50        | +3           | Beginner axes, common in forests.          |
| Walnut (Black)     | 1,010                | Common     | Forest          | 1–100       | +4           | Slightly harder, early crafting.           |
| Oak (Red)          | 1,080                | Common     | Forest          | 1–100       | +5           | Standard for early-mid game axes.          |
| Maple (Hard)       | 1,450                | Uncommon   | Forest          | 50–200      | +8           | Mid-tier axes, forest exploration.         |
| Mahogany (Santos)  | 2,200                | Uncommon   | Forest          | 50–200      | +10          | Durable, mid-game crafting.                |
| Hickory            | 2,540                | Uncommon   | Forest/Mountain | 100–300     | +12          | Flexible, strong for mid-tier axes.        |
| Wenge              | 3,260                | Rare       | Mountain        | 150–400     | +15          | High-tier axes, mountain rarity.           |
| Ipe                | 3,684                | Rare       | Mountain        | 150–400     | +18          | Elite axes, durable.                       |
| Black Ironwood     | 3,660                | Rare       | Cave            | 200–600     | +18          | Cave-exclusive, high durability.           |
| Lignum Vitae       | 4,390                | Very Rare  | Cave            | 300–800     | +22          | Legendary axes, requires Cave Guardian defeat. |
| Australian Buloke  | 5,060                | Very Rare  | Cave            | 400–1,000   | +25          | Hardest wood, requires Cave Guardian defeat. |
| Quebracho          | 4,570                | Very Rare  | Cave            | 300–800     | +23          | “Axe breaker,” legendary crafting.          |
| Snakewood          | 3,800                | Very Rare  | Cave            | 300–800     | +20          | Unique, decorative, high-tier axes.        |

- **Gathering**: Common woods require 1–2 hits, Uncommon 2–3, Rare 3–4, Very Rare 4–5 (Australian Buloke: 5 hits). Felling Axe chop bonus reduces hits.

### Metal Types
| Metal         | Mohs Hardness | Rarity     | Biome           | Level Range | Damage Bonus | Durability Bonus | Weight Modifier | Notes                                      |
|---------------|---------------|------------|-----------------|-------------|--------------|------------------|-----------------|--------------------------------------------|
| Iron          | 4.0           | Common     | Forest/Mountain | 1–100       | +5           | +20              | 0.0             | Abundant, basic axes.                      |
| Steel (Carbon)| 4.5–5.5       | Common     | Mountain        | 1–100       | +8           | +30              | 0.0             | Versatile, early-mid game crafting.        |
| Titanium      | 6.0           | Uncommon   | Mountain        | 50–200      | +10          | +40              | -0.1            | Lightweight, mid-tier axes.                |
| Vanadium      | 6.7           | Uncommon   | Mountain        | 50–200      | +12          | +50              | 0.0             | Corrosion-resistant, mid-game crafting.    |
| Tungsten      | 7.5           | Rare       | Cave            | 150–400     | +20          | +80              | +0.2            | High strength, elite axes.                 |
| Osmium        | 7.0           | Very Rare  | Cave            | 200–600     | +18          | +70              | +0.3            | Densest, heavy, requires boss defeat.      |
| Iridium       | 6.5           | Very Rare  | Cave            | 200–600     | +15          | +60              | +0.2            | Rare, premium axes.                        |
| Chromium      | 8.5–9.0       | Very Rare  | Deep Cave       | 400–1,000   | +25          | +90              | +0.1            | Hardest, requires Deep Cave Overlord defeat. |

- **Gathering**: Common metals require 2–3 hits, Uncommon 3–4, Rare 4–5, Very Rare 5–6 (Chromium: 6 hits). Felling Axe chop bonus applies.

### Progression Milestones
- **Levels 1–50 (~5 hours)**: Common resources (Pine, Iron), basic axes (Hand Axe), forest monsters (Pine Iron Wolf).
- **Levels 50–200 (~50 hours)**: Uncommon resources (Hickory, Titanium), mid-tier axes (Battle Axe), mountain monsters (Hickory Titanium Bear).
- **Levels 200–400 (~250 hours)**: Rare resources (Wenge, Tungsten), elite axes (Splitting Maul), cave monsters (Wenge Tungsten Goblin), requires Cave Guardian defeat for Australian Buloke.
- **Levels 400–1,000 (~1,000 hours)**: Very Rare resources (Australian Buloke, Chromium), legendary axes (Australian Buloke/Chromium Splitting Maul), deep cave monsters (Australian Buloke Chromium Dragon), requires Deep Cave Overlord defeat.

## 4. Monster System
Monsters are biome-specific, with variants combining wood and metal types to scale difficulty. Stats are derived from wood Janka hardness, metal Mohs hardness, and player level.

### Monster Types by Biome
- **Forest (Levels 1–100)**:
  - **Wolf**: Fast, low damage (e.g., Pine Iron Wolf).
  - **Boar**: High health, moderate damage (e.g., Oak Steel Boar).
  - **Bandit**: Balanced, basic weapons (e.g., Cedar Iron Bandit).
- **Mountain (Levels 50–200)**:
  - **Bear**: High health and damage (e.g., Hickory Titanium Bear).
  - **Mountain Troll**: Slow, high damage (e.g., Mahogany Vanadium Troll).
  - **Golem**: Very high health, low speed (e.g., Maple Titanium Golem).
- **Cave (Levels 150–400)**:
  - **Goblin**: Fast, moderate damage (e.g., Wenge Tungsten Goblin).
  - **Cave Troll**: High health and damage (e.g., Ipe Tungsten Troll).
  - **Cave Guardian**: Boss, very high stats (e.g., Black Ironwood Tungsten Guardian).
- **Deep Cave (Levels 400–1,000)**:
  - **Dragon**: High damage, high agility (e.g., Lignum Vitae Osmium Dragon).
  - **Abyssal Fiend**: High health, special abilities (e.g., Quebracho Iridium Fiend).
  - **Deep Cave Overlord**: Boss, ultimate challenge (e.g., Australian Buloke Chromium Overlord).

### Monster Stats Formula
For a monster with wood \( W \) (Janka hardness \( J \)), metal \( M \) (Mohs hardness \( H \)), at player level \( L \):
- **Health**: \( 50 + L \times 20 + J / 100 + H \times 100 \)
- **Damage**: \( 5 + L \times 2 + J / 500 + H \times 20 \)
- **Agility**: \( 5 + L + H \times 10 \)
- **XP Reward**: \( 1000 + \text{Health} \times 5 \), bosses: \( 500,000 + \text{Health} \times 10 \)

**Examples**:
- **Oak Tungsten Goblin** (Level 200, Oak: 1,080 lbf, Tungsten: 7.5):
  - Health: \( 50 + 200 \times 20 + 1080 / 100 + 7.5 \times 100 = 4,810 \)
  - Damage: \( 5 + 200 \times 2 + 1080 / 500 + 7.5 \times 20 = 557.16 \)
  - Agility: \( 5 + 200 + 7.5 \times 10 = 280 \)
  - XP: \( 1000 + 4810 \times 5 = 25,050 \)
- **Australian Buloke Chromium Overlord** (Level 400, Buloke: 5,060 lbf, Chromium: 8.5):
  - Health: \( 500,000 + 400 \times 50 + 5060 / 100 + 8.5 \times 100 = 520,900 \)
  - Damage: \( 500 + 400 \times 5 + 5060 / 500 + 8.5 \times 20 = 2,680.1 \)
  - Agility: \( 10 + 400 + 8.5 \times 10 = 495 \)
  - XP: \( 500,000 + 520,900 \times 10 = 5,709,000 \)

## 5. Experience System
- **XP Formula**: XP to reach level \( L \) is \( 100 \times L^2 \).
  - Level 2: 400 XP
  - Level 100: 1,000,000 XP
  - Level 1,000: 100,000,000 XP
- **Total XP**: ~33.37 billion XP to reach level 1,000.
- **Combat Time**: 500 hours, ~1,112,223 XP/minute (6 monsters/minute, ~185,370 XP each).
- **Boss Rewards**: High XP (e.g., 5.7 million for Deep Cave Overlord) to incentivize milestones.

## 6. Resource Gathering
- **Mechanics**: Players press spacebar to “hit” resources, with hits required based on rarity:
  - Common: 1–2 (wood), 2–3 (metal).
  - Uncommon: 2–3 (wood), 3–4 (metal).
  - Rare: 3–4 (wood), 4–5 (metal).
  - Very Rare: 4–5 (wood), 5–6 (metal; Chromium: 6).
- **Australian Buloke**: 1% spawn rate in caves, requires Cave Guardian defeat (level 200+), 5 hits.
- **Chromium**: 0.5% spawn rate in deep caves, requires Deep Cave Overlord defeat (level 400+), 6 hits.
- **Time**: ~300 hours for gathering, assuming 1 resource every 2 minutes.

## 7. Crafting System
- **Axe Stats**:
  - Damage: Base + wood bonus + metal bonus + (player level / 5–10).
  - Durability: Base × (wood Janka / 1,000) × (metal Mohs / 4).
  - Speed: Base × (1.1 if Very Rare wood).
  - Weight: Wood and metal modifiers affect agility (e.g., Osmium: -30% agility).
- **Level Requirements**:
  - Rare woods/metals: Level 50–200.
  - Very Rare woods/metals: Level 200–400.
- **Example**: Australian Buloke/Chromium Splitting Maul (Level 400):
  - Damage: 25 + 25 (wood) + 25 (metal) + 400/5 = 155
  - Durability: 90 × (5060/1000) × (8.5/4) ≈ 968
  - Speed: 2.5 × 1.1 = 2.75
  - Weight: -10% agility

## 8. Gameplay Flow
- **Levels 1–50 (~5 hours)**:
  - Fight Pine Iron Wolves/Boars in forests.
  - Craft Pine/Iron Hand Axe (Damage: ~18, Durability: ~70).
  - Gather Common resources (1–2 hits).
- **Levels 50–200 (~50 hours)**:
  - Battle Hickory Titanium Bears/Trolls in mountains.
  - Craft Hickory/Titanium Battle Axe (Damage: ~50, Durability: ~200).
  - Gather Uncommon resources (2–4 hits).
- **Levels 200–400 (~250 hours)**:
  - Defeat Cave Guardian (Black Ironwood Tungsten) to unlock Australian Buloke.
  - Fight Wenge Tungsten Goblins in caves.
  - Craft Wenge/Tungsten Splitting Maul (Damage: ~80, Durability: ~350).
  - Gather Rare resources (3–5 hits).
- **Levels 400–1,000 (~1,000 hours)**:
  - Defeat Deep Cave Overlord (Australian Buloke Chromium) to unlock Chromium.
  - Battle Lignum Vitae Osmium Dragons in deep caves.
  - Craft Australian Buloke/Chromium Splitting Maul (Damage: ~155, Durability: ~968).
  - Gather Very Rare resources (4–6 hits, 50–100 hours for Australian Buloke/Chromium).

## 9. Time Breakdown
- **Combat (500 hours)**:
  - 6 monsters/minute, ~185,370 XP/minute, ~33.37 billion XP total.
  - Bosses provide high XP (e.g., 5.7 million for Deep Cave Overlord).
- **Resource Gathering (300 hours)**:
  - 1 resource every 2 minutes, ~9,000 resources over 18,000 minutes.
  - Australian Buloke/Chromium: 50–100 hours due to low spawn rates (1%, 0.5%) and high hit requirements.
- **Crafting/Exploration (200 hours)**:
  - Crafting elite axes and exploring deep caves.
- **Total**: 1,000 hours to reach level 1,000.

## 10. Additional Considerations
- **Assets**:
  - Sprites for tiles (`forest.png`, `deep_cave.png`), resources (`chromium.png`, `buloke.png`), and monsters (`wolf.png`, `dragon.png`).
  - Use color tints for wood-metal variants (e.g., silver for Chromium).
- **Crafting UI**:
  - Flutter overlay with dropdowns for axe type, wood, and metal.
  - Display resource costs, level requirements, and stats.
- **Quests**:
  - Add quests (e.g., “Defeat 10 Wenge Tungsten Goblins”, “Gather 50 Australian Buloke”) for XP and resource rewards.
- **Performance**:
  - Use Flame’s `CameraComponent` to render only visible tiles/monsters.
- **Balance**:
  - Adjust XP rewards or hit requirements post-playtesting to ensure 1,000-hour target.
  - Introduce XP boosters at milestones (e.g., level 500) to reduce grind.

## 11. Implementation Code
Below are the key Dart code snippets for implementing the game systems in Flutter with the Flame game engine. Note: These assume the existence of `Wood`, `Metal`, `AxeType`, and `Axe` classes with properties as described (e.g., `Wood.jankaHardness`, `Metal.mohsHardness`, `AxeType` enum).

### Lumberjack Class
```dart
class Lumberjack {
  String name = "Lumberjack";
  int strength = 10;
  int stamina = 10;
  int baseAgility = 10;
  int level = 1;
  int experience = 0;
  int maxHealth = 100;
  int health = 100;
  Map<Wood, int> woodInventory = {};
  Map<Metal, int> metalInventory = {};
  Axe? equippedAxe;
  double totalPlayTime = 0.0;

  int get agility => (baseAgility * (equippedAxe?.wood.weightModifier ?? 1.0) * (equippedAxe?.metal.weightModifier ?? 1.0)).round();
  int get xpToNextLevel => 100 * level * level;

  void addWood(Wood wood, int amount) {
    woodInventory[wood] = (woodInventory[wood] ?? 0) + amount;
  }

  void addMetal(Metal metal, int amount) {
    metalInventory[metal] = (metalInventory[metal] ?? 0) + amount;
  }

  void levelUp() {
    level++;
    strength += 2 + (level ~/ 100);
    stamina += 2 + (level ~/ 100);
    baseAgility += 1 + (level ~/ 200);
    maxHealth = stamina * 10;
    health = maxHealth;
  }

  void gainExperience(int exp) {
    experience += exp;
    while (experience >= xpToNextLevel) {
      experience -= xpToNextLevel;
      levelUp();
    }
  }

  void updatePlayTime(double delta) {
    totalPlayTime += delta / 3600;
  }
}
