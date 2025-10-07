import 'package:flutter/material.dart';

/// Game info header showing current stats
class GameInfoHeader extends StatelessWidget {
  final int currentPosition;
  final int totalCells;
  final int lastDiceRoll;
  final int dangerCount;

  const GameInfoHeader({
    super.key,
    required this.currentPosition,
    required this.totalCells,
    required this.lastDiceRoll,
    required this.dangerCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildInfoCard(
            'Position',
            '$currentPosition/$totalCells',
            Icons.location_on,
          ),
          _buildInfoCard(
            'Last Roll',
            lastDiceRoll > 0 ? '$lastDiceRoll' : '-',
            Icons.casino,
          ),
          _buildInfoCard(
            'Dangers',
            '$dangerCount',
            Icons.warning,
          ),
        ],
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