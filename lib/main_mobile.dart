import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'lumberjack_rpg.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LumberjackRPGApp());
}

class LumberjackRPGApp extends StatelessWidget {
  const LumberjackRPGApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LumberjackRPG',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late LumberjackRPG game;
  bool showMenu = false;

  @override
  void initState() {
    super.initState();
    game = LumberjackRPG();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Game canvas
            GameWidget(game: game),
            
            // Mobile-optimized overlay
            if (showMenu)
              _buildMobileMenu(),
            
            // Mobile controls
            _buildMobileControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileControls() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // D-pad for movement
          _buildDPad(),
          
          // Action buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildDPad() {
    return Container(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          // Up
          Positioned(
            top: 0,
            left: 40,
            child: _buildDirectionButton(
              icon: Icons.arrow_upward,
              onPressed: () => _movePlayer(0, -1),
            ),
          ),
          // Down
          Positioned(
            bottom: 0,
            left: 40,
            child: _buildDirectionButton(
              icon: Icons.arrow_downward,
              onPressed: () => _movePlayer(0, 1),
            ),
          ),
          // Left
          Positioned(
            left: 0,
            top: 40,
            child: _buildDirectionButton(
              icon: Icons.arrow_back,
              onPressed: () => _movePlayer(-1, 0),
            ),
          ),
          // Right
          Positioned(
            right: 0,
            top: 40,
            child: _buildDirectionButton(
              icon: Icons.arrow_forward,
              onPressed: () => _movePlayer(1, 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.brown.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Action button (space bar equivalent)
        _buildActionButton(
          label: 'Action',
          icon: Icons.touch_app,
          color: Colors.green,
          onPressed: () {
            // Trigger action in game
          },
        ),
        const SizedBox(height: 10),
        // Menu button
        _buildActionButton(
          label: 'Menu',
          icon: Icons.menu,
          color: Colors.blue,
          onPressed: () {
            setState(() {
              showMenu = !showMenu;
            });
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.8),
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildMobileMenu() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.brown.shade800,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.yellow, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'GAME MENU',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildMenuButton('Continue', Icons.play_arrow, () {
                setState(() {
                  showMenu = false;
                });
              }),
              _buildMenuButton('Inventory', Icons.inventory, () {
                // Show inventory
              }),
              _buildMenuButton('Town', Icons.home, () {
                // Show town info
              }),
              _buildMenuButton('Settings', Icons.settings, () {
                // Show settings
              }),
              _buildMenuButton('Exit', Icons.exit_to_app, () {
                // Exit game
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(String label, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: 200,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.all(12),
          ),
        ),
      ),
    );
  }

  void _movePlayer(int dx, int dy) {
    // This would connect to the game's movement system
    // For now, it's a placeholder for the mobile controls
    print('Move: dx=$dx, dy=$dy');
  }
}
