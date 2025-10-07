import 'package:flutter/material.dart';

/// Animated dice button widget
class DiceButton extends StatelessWidget {
  final bool isDiceRolling;
  final bool isGameWon;
  final VoidCallback onPressed;
  final Animation<double> rotationAnimation;
  final Animation<double> scaleAnimation;
  final AnimationController animationController;

  const DiceButton({
    super.key,
    required this.isDiceRolling,
    required this.isGameWon,
    required this.onPressed,
    required this.rotationAnimation,
    required this.scaleAnimation,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: scaleAnimation.value,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateX(rotationAnimation.value), // Rotate around X-axis (top to bottom)
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: isGameWon ? null : onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDiceRolling 
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
                        isDiceRolling ? Icons.hourglass_empty : Icons.casino,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isDiceRolling ? 'Rolling...' : 'Press Dice',
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
    );
  }
}