# Changelog

All notable changes to this game project will be documented in this file.

## [v0.1.0] – 2025-07-13
### Added
- Player movement using `Input.get_action_strength()` for smooth left/right control
- Jumping mechanic with gravity handling
- Corruption timer that only counts down when the player is idle
- `AnimatedSprite2D` logic with `idle`, `run`, and `jump` animations
- Clean code structure using `handle_movement()`, `handle_animation()`, `apply_gravity()`
- `is_airborne` and `is_moving` state tracking
- Timer pause/resume based on movement input
- GitHub Desktop commit and sync

### Structure
- Organized functions by responsibility (movement, animation, gravity)
- Clean use of constants for `SPEED`, `GRAVITY`, and `JUMP_VELOCITY`

## [v0.0.1] – 2025-07-12
### Initial Setup
- Project created for Game Jam with theme: **"Just Get Started"**
- Core concept chosen: glitchy world where stopping drains time
- GitHub repo initialized and linked via GitHub Desktop
- Placeholder player scene created with basic input bindings
