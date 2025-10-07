# 🎲 Dice Path Adventure

A simple and engaging Flutter board game where players roll dice to navigate through a grid while avoiding danger boxes to reach the goal.

## 🎮 Game Overview

**Dice Path Adventure** is a strategic board game built with Flutter and Riverpod state management. Players must navigate from the starting position to the goal by rolling dice, while avoiding randomly placed danger boxes that reset their progress.

## 🚀 Features

### Core Gameplay
- **Dynamic Grid**: Customizable n×n grid (minimum 6x6)
- **Dice Mechanics**: Roll 1-6 to move forward
- **Danger Boxes**: Randomly placed hazards that reset position
- **Win Condition**: Reach the last cell to win
- **Game Reset**: Restart or create new games

### UI/UX Features
- **Beautiful Night Sky Theme**: Purple gradient background
- **Smooth Animations**: Dice rolling and grid transitions
- **Visual Indicators**: 
  - 🟢 Green start position
  - 🔴 Red danger box indicators
  - 🟡 Yellow player position highlight
  - 🏆 Goal cell marking
- **Responsive Design**: Works on mobile, desktop, and web
- **Game Status Dialogs**: Win/Game Over notifications

### Technical Features
- **Riverpod State Management**: Clean and efficient state handling
- **Modular Architecture**: Well-organized code structure
- **Animations**: Smooth transitions and dice roll effects
- **Form Validation**: Input validation for grid size

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── game_state.dart      # Game logic and Riverpod providers
├── screens/
│   ├── input_screen.dart    # Grid size input screen
│   └── game_screen.dart     # Main game board
└── widgets/
    └── grid_box.dart        # Reusable grid cell widget
```

## 🎯 How to Play

1. **Setup**: Enter a grid size greater than 5 (recommended 6-12)
2. **Start**: You begin at position 1 (top-left, green indicator)
3. **Roll Dice**: Press the "Press Dice" button to roll 1-6
4. **Move**: Your position advances by the dice value
5. **Avoid Dangers**: Red dots indicate danger boxes
   - Landing on danger = reset to start
6. **Win**: Reach the last cell (bottom-right) to win!

## 🛠️ Installation & Setup

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- IDE (VS Code, Android Studio, etc.)

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_riverpod: ^2.4.9
```

### Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd dice_path_adventure
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   # Desktop
   flutter run -d windows
   flutter run -d macos
   flutter run -d linux
   
   # Mobile
   flutter run -d android
   flutter run -d ios
   
   # Web
   flutter run -d web
   ```

## 🏗️ Architecture Details

### State Management (Riverpod)
- **GameStateNotifier**: Manages game state and logic
- **GameState Model**: Immutable state containing:
  - Grid size and total cells
  - Current player position
  - Danger box positions
  - Game status (playing/game over/won)
  - Last dice roll value

### Key Components

#### GameState Model
```dart
class GameState {
  final int gridSize;
  final int currentPosition;
  final Set<int> dangerBoxes;
  final bool isGameOver;
  final bool isWinner;
  final int lastDiceRoll;
}
```

#### Game Logic
- **Dice Rolling**: Random 1-6 generation
- **Danger Box Generation**: Random placement (n boxes for n×n grid)
- **Position Validation**: Boundary checking and collision detection
- **Win/Loss Conditions**: Automatic game state updates

## 🎨 Design Features

### Color Scheme
- **Background**: Purple gradient night sky theme
- **Primary**: Blue accent colors for buttons
- **Danger**: Red indicators for hazards
- **Success**: Green for start/win states
- **Player**: Yellow highlight for current position

### Animations
- **Dice Roll**: Rotation and scale animations
- **Grid Fade**: Smooth grid appearance
- **Button Interactions**: Press feedback and hover effects

## 🚧 Future Enhancements

### Potential Features
- [ ] **Multiple Players**: Turn-based multiplayer
- [ ] **Power-ups**: Special dice or movement bonuses
- [ ] **Levels**: Progressive difficulty with obstacles
- [ ] **Sound Effects**: Audio feedback for actions
- [ ] **Score System**: Points based on completion time
- [ ] **Themes**: Multiple visual themes
- [ ] **Save/Load**: Game state persistence

### Technical Improvements
- [ ] **Unit Tests**: Comprehensive test coverage
- [ ] **Performance**: Grid optimization for large sizes
- [ ] **Accessibility**: Screen reader support
- [ ] **Internationalization**: Multi-language support

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Riverpod for excellent state management
- The Flutter community for inspiration and support

---

**Enjoy your Dice Path Adventure! 🎲✨**