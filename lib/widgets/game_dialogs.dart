import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state.dart';

/// Game dialogs for win and game over scenarios
class GameDialogs {
  static void showGameOverDialog(
    BuildContext context,
    WidgetRef ref,
  ) {
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

  static void showWinDialog(
    BuildContext context,
    WidgetRef ref,
  ) {
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

  static void showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Help'),
        content: const Text(
          'Roll the dice to move forward.\n\n'
          '🟢 Green: Start position\n'
          '🔴 Red dots: Danger boxes (avoid!)\n'
          '🟡 Yellow border: Your position\n'
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
  }
}