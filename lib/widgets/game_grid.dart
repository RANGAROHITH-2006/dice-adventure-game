import 'package:flutter/material.dart';
import '../models/game_state.dart';
import 'grid_box.dart';

/// Game grid widget that displays the board
class GameGrid extends StatelessWidget {
  final GameState gameState;
  final int gridSize;
  final Animation<double> fadeAnimation;

  const GameGrid({
    super.key,
    required this.gameState,
    required this.gridSize,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FadeTransition(
          opacity: fadeAnimation,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate the size to fit the grid without scrolling
              final availableSize = constraints.maxHeight;
              final gridSize = (availableSize - 20) / this.gridSize;
              
              return Center(
                child: SizedBox(
                  width: gridSize * this.gridSize,
                  height: gridSize * this.gridSize,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: this.gridSize,
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
    );
  }
}