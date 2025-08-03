void main() {
  runApp(GameWidget(
    game: LumberjackRPG(),
    overlayBuilderMap: {
      'CharacterSheet': (BuildContext context, LumberjackRPG game) {
        return Positioned(
          top: 10,
          left: 10,
          child: Container(
            padding: EdgeInsets.all(8),
            color: Colors.black54,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lumberjack: ${game.player.name}', style: TextStyle(color: Colors.white)),
                Text('Level: ${game.player.level}', style: TextStyle(color: Colors.white)),
                Text('XP: `\({game.player.experience}/\)`{game.player.xpToNextLevel}', style: TextStyle(color: Colors.white)),
                Text('Play Time: ${game.player.totalPlayTime.toStringAsFixed(2)} hours', style: TextStyle(color: Colors.white)),
                Text('Health: `\({game.player.health}/\)`{game.player.maxHealth}', style: TextStyle(color: Colors.white)),
                Text('Strength: ${game.player.strength}', style: TextStyle(color: Colors.white)),
                Text('Stamina: ${game.player.stamina}', style: TextStyle(color: Colors.white)),
                Text('Agility: ${game.player.agility}', style: TextStyle(color: Colors.white)),
                Text('Equipped Axe: `\({game.player.equippedAxe?.type.toString().split('.').last ?? "None"} (\)`{game.player.equippedAxe?.wood.name ?? ""}/${game.player.equippedAxe?.metal.name ?? ""})', style: TextStyle(color: Colors.white)),
                Text('Wood Inventory:', style: TextStyle(color: Colors.white)),
                ...game.player.woodInventory.entries.map((e) => Text('${e.key.name}: ${e.value}', style: TextStyle(color: Colors.white))),
                Text('Metal Inventory:', style: TextStyle(color: Colors.white)),
                ...game.player.metalInventory.entries.map((e) => Text('${e.key.name}: ${e.value}', style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
        );
      },
    },
  ));
}
