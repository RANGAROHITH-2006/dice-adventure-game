import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state.dart';
import '../widgets/grid_box.dart';

/// Main game screen with grid board and dice functionality
class GameScreen extends ConsumerStatefulWidget {
  final int gridSize;

  const GameScreen({
    super.key,
    required this.gridSize,
  });

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen>
    with TickerProviderStateMixin {
  late AnimationController _diceAnimationController;
  late AnimationController _gridAnimationController;
  late Animation<double> _diceRotationAnimation;
  late Animation<double> _diceScaleAnimation;
  late Animation<double> _gridFadeAnimation;

  bool _isDiceRolling = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize game state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameStateProvider.notifier).initializeGame(widget.gridSize);
    });

    // Setup animations
    _diceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600), // Reduced duration
      vsync: this,
    );
    
    _gridAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _diceRotationAnimation = Tween<double>(
      begin: 0,
      end: 1, // Just a small rotation instead of full 360 degrees
    ).animate(CurvedAnimation(
      parent: _diceAnimationController,
      curve: Curves.easeInOut,
    ));

    _diceScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1, // Reduced scale effect
    ).animate(CurvedAnimation(
      parent: _diceAnimationController,
      curve: Curves.easeInOut, // Smoother curve
    ));

    _gridFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _gridAnimationController,
      curve: Curves.easeInOut,
    ));

    _gridAnimationController.forward();
  }

  @override
  void dispose() {
    _diceAnimationController.dispose();
    _gridAnimationController.dispose();
    super.dispose();
  }

  Future<void> _rollDice() async {
    if (_isDiceRolling) return;

    setState(() {
      _isDiceRolling = true;
    });

    // Start dice animation
    await _diceAnimationController.forward();
    
    // Roll dice in game state
    ref.read(gameStateProvider.notifier).rollDice();
    
    // Reset dice animation
    _diceAnimationController.reset();
    
    setState(() {
      _isDiceRolling = false;
    });

    // Check for game over or win after a short delay
    await Future.delayed(const Duration(milliseconds: 300));
    _checkGameStatus();
  }

  void _checkGameStatus() {
    final gameState = ref.read(gameStateProvider);
    if (gameState == null) return;

    if (gameState.isGameOver) {
      _showGameOverDialog();
    } else if (gameState.isWinner) {
      _showWinDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red.shade900,
        title: const Row(
          children: [
            Icon(Icons.dangerous, color: Colors.white, size: 28),
            SizedBox(width: 8),
            Text(
              'Game Over!',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'You landed on a danger box!\nReturning to start...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'Dice rolled: ${ref.read(gameStateProvider)?.lastDiceRoll ?? 0}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(gameStateProvider.notifier).clearGameStatus();
            },
            child: const Text(
              'Continue',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green.shade900,
        title: const Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.yellow, size: 28),
            SizedBox(width: 8),
            Text(
              'You Win!',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Congratulations!\nYou reached the goal!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'Final dice roll: ${ref.read(gameStateProvider)?.lastDiceRoll ?? 0}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(gameStateProvider.notifier).resetGame();
            },
            child: const Text(
              'Play Again',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to input screen
            },
            child: const Text(
              'New Game',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    ref.read(gameStateProvider.notifier).resetGame();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Game reset! Good luck!'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    
    if (gameState == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.gridSize}x${widget.gridSize}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _resetGame,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Game',
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Game Help'),
                  content: const Text(
                    'Roll the dice to move forward.\\n\\n'
                    '🟢 Green: Start position\\n'
                    '🔴 Red dots: Danger boxes (avoid!)\\n'
                    '🟡 Yellow border: Your position\\n'
                    '🏆 Reach the last cell to win!',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Got it!'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
              Color(0xFF533483),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Game info header
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoCard(
                      'Position',
                      '${gameState.currentPosition}/${gameState.totalCells}',
                      Icons.location_on,
                    ),
                    _buildInfoCard(
                      'Last Roll',
                      gameState.lastDiceRoll > 0 ? '${gameState.lastDiceRoll}' : '-',
                      Icons.casino,
                    ),
                    _buildInfoCard(
                      'Dangers',
                      '${gameState.dangerBoxes.length}',
                      Icons.warning,
                    ),
                  ],
                ),
              ),

              // Game grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FadeTransition(
                    opacity: _gridFadeAnimation,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Calculate the size to fit the grid without scrolling
                        final availableSize = constraints.maxHeight;
                        final gridSize = (availableSize - 20) / widget.gridSize;
                        
                        return Center(
                          child: SizedBox(
                            width: gridSize * widget.gridSize,
                            height: gridSize * widget.gridSize,
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: widget.gridSize,
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 2,
                                childAspectRatio: 1,
                              ),
                              itemCount: gameState.totalCells,
                              itemBuilder: (context, index) {
                                final cellNumber = index + 1;
                                return GridBox(
                                  number: cellNumber,
                                  isDangerBox: gameState.dangerBoxes.contains(cellNumber),
                                  hasPlayer: gameState.currentPosition == cellNumber,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Instructions
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  gameState.currentPosition == gameState.totalCells
                      ? '🏆 You reached the goal!'
                      : 'Press any box',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ),

              // Dice button
              Container(
                padding: const EdgeInsets.all(24),
                child: AnimatedBuilder(
                  animation: _diceAnimationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _diceScaleAnimation.value,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..rotateX(_diceRotationAnimation.value), // Rotate around X-axis (top to bottom)
                        child: SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: gameState.isWinner ? null : _rollDice,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isDiceRolling 
                                  ? Colors.orange 
                                  : Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 8,
                              shadowColor: Colors.blue.withOpacity(0.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _isDiceRolling ? Icons.hourglass_empty : Icons.casino,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isDiceRolling ? 'Rolling...' : 'Press Dice',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(0.8),
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}