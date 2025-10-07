import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Game state model to handle all game logic and state management
class GameState {
  final int gridSize;
  final int totalCells;
  final int currentPosition;
  final Set<int> dangerBoxes;
  final bool isGameOver;
  final bool isWinner;
  final int lastDiceRoll;

  GameState({
    required this.gridSize,
    required this.currentPosition,
    required this.dangerBoxes,
    this.isGameOver = false,
    this.isWinner = false,
    this.lastDiceRoll = 0,
  }) : totalCells = gridSize * gridSize;

  /// Create initial game state
  GameState.initial(this.gridSize)
      : totalCells = gridSize * gridSize,
        currentPosition = 1,
        dangerBoxes = _generateDangerBoxes(gridSize),
        isGameOver = false,
        isWinner = false,
        lastDiceRoll = 0;

  /// Generate random danger boxes (n boxes for n×n grid)
  static Set<int> _generateDangerBoxes(int gridSize) {
    final random = Random();
    final totalCells = gridSize * gridSize;
    final dangerBoxes = <int>{};
    
    // Generate gridSize number of danger boxes
    while (dangerBoxes.length < gridSize) {
      final randomPosition = random.nextInt(totalCells) + 1;
      // Don't place danger box on first cell (start) or last cell (goal)
      if (randomPosition != 1 && randomPosition != totalCells) {
        dangerBoxes.add(randomPosition);
      }
    }
    
    return dangerBoxes;
  }

  /// Roll dice and return new game state
  GameState rollDice() {
    final random = Random();
    final diceValue = random.nextInt(6) + 1;
    final newPosition = currentPosition + diceValue;
    
    // Check if player reaches or exceeds the goal
    if (newPosition >= totalCells) {
      return copyWith(
        currentPosition: totalCells,
        isWinner: true,
        lastDiceRoll: diceValue,
      );
    }
    
    // Check if player lands on danger box
    if (dangerBoxes.contains(newPosition)) {
      return copyWith(
        currentPosition: 1, // Reset to start
        isGameOver: true,
        lastDiceRoll: diceValue,
      );
    }
    
    // Normal move
    return copyWith(
      currentPosition: newPosition,
      lastDiceRoll: diceValue,
    );
  }

  /// Reset game state
  GameState reset() {
    return GameState.initial(gridSize);
  }

  /// Copy with modifications
  GameState copyWith({
    int? currentPosition,
    bool? isGameOver,
    bool? isWinner,
    int? lastDiceRoll,
  }) {
    return GameState(
      gridSize: gridSize,
      currentPosition: currentPosition ?? this.currentPosition,
      dangerBoxes: dangerBoxes,
      isGameOver: isGameOver ?? this.isGameOver,
      isWinner: isWinner ?? this.isWinner,
      lastDiceRoll: lastDiceRoll ?? this.lastDiceRoll,
    );
  }
}

/// Riverpod provider for game state
class GameStateNotifier extends StateNotifier<GameState?> {
  GameStateNotifier() : super(null);

  /// Initialize game with grid size
  void initializeGame(int gridSize) {
    state = GameState.initial(gridSize);
  }

  /// Roll dice and update game state
  void rollDice() {
    if (state != null) {
      state = state!.rollDice();
    }
  }

  /// Reset game
  void resetGame() {
    if (state != null) {
      state = state!.reset();
    }
  }

  /// Clear game over/winner status
  void clearGameStatus() {
    if (state != null) {
      state = state!.copyWith(
        isGameOver: false,
        isWinner: false,
      );
    }
  }
}

/// Provider for game state
final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState?>(
  (ref) => GameStateNotifier(),
);