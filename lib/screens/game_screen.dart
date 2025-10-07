import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game2/models/game_state.dart';
import 'package:game2/widgets/dice_button.dart';
import 'package:game2/widgets/game_dialogs.dart';
import 'package:game2/widgets/game_grid.dart';
import 'package:game2/widgets/game_info_header.dart';

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

    _setupAnimations();
    _gridAnimationController.forward();
  }

  void _setupAnimations() {
    _diceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _gridAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _diceRotationAnimation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _diceAnimationController,
      curve: Curves.easeInOut,
    ));

    _diceScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _diceAnimationController,
      curve: Curves.easeInOut,
    ));

    _gridFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _gridAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _diceAnimationController.dispose();
    _gridAnimationController.dispose();
    super.dispose();
  }

  Future<void> _rollDice() async {
    if (_isDiceRolling) return;

    setState(() => _isDiceRolling = true);

    await _diceAnimationController.forward();
    ref.read(gameStateProvider.notifier).rollDice();
    _diceAnimationController.reset();
    
    setState(() => _isDiceRolling = false);

    await Future.delayed(const Duration(milliseconds: 300));
    _checkGameStatus();
  }

  void _checkGameStatus() {
    final gameState = ref.read(gameStateProvider);
    if (gameState == null) return;

    if (gameState.isGameOver) {
      GameDialogs.showGameOverDialog(context, ref);
    } else if (gameState.isWinner) {
      GameDialogs.showWinDialog(context, ref);
    }
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
      appBar: _buildAppBar(),
      extendBodyBehindAppBar: true,
      body: _buildBody(gameState),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
          onPressed: () => GameDialogs.showHelpDialog(context),
          icon: const Icon(Icons.help_outline),
        ),
      ],
    );
  }

  Widget _buildBody(GameState gameState) {
    return Container(
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
            GameInfoHeader(
              currentPosition: gameState.currentPosition,
              totalCells: gameState.totalCells,
              lastDiceRoll: gameState.lastDiceRoll,
              dangerCount: gameState.dangerBoxes.length,
            ),

            GameGrid(
              gameState: gameState,
              gridSize: widget.gridSize,
              fadeAnimation: _gridFadeAnimation,
            ),
            _buildInstructions(gameState),
            DiceButton(
              isDiceRolling: _isDiceRolling,
              isGameWon: gameState.isWinner,
              onPressed: _rollDice,
              rotationAnimation: _diceRotationAnimation,
              scaleAnimation: _diceScaleAnimation,
              animationController: _diceAnimationController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions(GameState gameState) {
    return Container(
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
    );
  }
}