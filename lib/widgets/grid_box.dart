import 'package:flutter/material.dart';

/// Reusable widget for individual grid box
class GridBox extends StatelessWidget {
  final int number;
  final bool isDangerBox;
  final bool hasPlayer;
  final VoidCallback? onTap;

  const GridBox({
    super.key,
    required this.number,
    this.isDangerBox = false,
    this.hasPlayer = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _getBoxColor(),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasPlayer ? Colors.yellow : Colors.white.withOpacity(0.3),
            width: hasPlayer ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Box number
            Center(
              child: Text(
                '$number',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            
            // Danger box indicator (red dot)
            if (isDangerBox)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            
            // Player indicator (player icon)
            if (hasPlayer)
              Positioned(
                bottom: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            
            // Goal indicator (trophy for last cell)
            if (number == 1)
              const Positioned(
                top: 4,
                left: 4,
                child: Icon(
                  Icons.play_arrow,
                  size: 16,
                  color: Colors.green,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Get box color based on type
  Color _getBoxColor() {
    if (hasPlayer) {
      return Colors.blue.shade600; // Highlight player position
    }
    if (number == 1) {
      return Colors.green.shade600; // Start position
    }
    return Colors.purple.shade400.withOpacity(0.8); // Default box color
  }
}