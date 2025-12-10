# Crepe Cooking Simulator

A mobile-friendly 2D cooking game inspired by Shawarma Legend, built with Godot 4.3.

## Game Overview

This is a click/tap and drag cooking simulator where you run a crepe stand. The main character stays stationary while you interact with cooking stations using touch or mouse controls.

### Day 1: Whipped Cream Crepe

The first day features a single recipe: the classic whipped cream crepe.

## How to Play

1. **Pour Batter**: Tap the batter bowl to pour batter onto the pan
2. **Spread Batter**: Drag your finger/mouse across the pan to spread the batter evenly
3. **Wait for Cooking**: The crepe will cook automatically (watch the timer)
4. **Flip**: Tap the pan when the crepe is cooked to flip it
5. **Transfer to Plate**: Once fully cooked, tap the crepe to move it to the plate
6. **Add Whipped Cream**: Hold down on the cream dispenser to add whipped cream
7. **Serve**: Tap the serving area to complete the order

## Game Features

- **Touch/Click Controls**: Optimized for both mobile touch and desktop mouse input
- **Progressive Cooking System**: Follow step-by-step cooking instructions
- **Order System**: Complete 5 orders per day
- **Visual Feedback**: Clear indicators for each cooking stage
- **Mobile-First Design**: Portrait orientation with 1080x1920 resolution

## Technical Details

### Project Structure

```
├── project.godot          # Godot project configuration
├── scenes/
│   ├── Main.tscn         # Main game scene
│   ├── CookingStation.tscn   # Cooking area with all stations
│   ├── CrepePan.tscn     # Interactive pan for cooking
│   ├── WhippedCreamDispenser.tscn  # Cream topping station
│   └── UI.tscn           # Game UI overlay
├── scripts/
│   ├── GameManager.gd    # Core game logic and state management
│   ├── CookingStation.gd # Coordinates cooking workflow
│   ├── CrepePan.gd       # Handles crepe cooking mechanics
│   ├── WhippedCreamDispenser.gd  # Cream dispensing logic
│   └── UI.gd             # UI updates and display
└── assets/
    ├── sprites/          # (Placeholder for sprite assets)
    └── audio/            # (Placeholder for audio assets)
```

### Key Systems

**GameManager**: Controls game flow, day progression, and order management
**CookingStation**: Central hub that coordinates all cooking activities
**CrepePan**: Manages crepe cooking stages (pouring, spreading, cooking, flipping)
**WhippedCreamDispenser**: Handles topping application

## Opening the Project

1. Install Godot 4.3 or later
2. Open Godot Engine
3. Click "Import" and navigate to this directory
4. Select the `project.godot` file
5. Click "Import & Edit"

## Running the Game

- Press F5 or click the Play button in Godot to run
- Works on desktop with mouse controls
- Can be exported to Android/iOS for mobile play

## Future Enhancements

- Additional crepe recipes (chocolate, fruit, savory)
- More days with increasing difficulty
- Customer satisfaction system
- Timing challenges and combos
- More cooking stations and ingredients
- Graphics and sound effects

## Controls Summary

- **Tap/Click**: Select, pour, flip, transfer, serve
- **Hold**: Dispense cream
- **Drag**: Spread batter on pan

Enjoy cooking delicious crepes!
