# Changelog

All notable changes to this game project will be documented in this file.

## [v0.3.1] – 2025-07-17

### Added
- New Assets!
    - Player
    - Glitch Tiles
    - Patch Object
- Death Zones so the player will die if he/she falls from the map
- Added glow effect and floaty effect to patch object
- Unfinished Level 2
- Functional SFX like `EXPLOSION`, `JUMP`, and `PATCH`

### Issues
- No background
- Avoid coruption by jittering the player

### Changed
- Corruption time starts as soon as the "corrupted signal" starts
- Level 1 Layout changed to match a settings


## [v0.3.0] – 2025-07-16

### Added
- New Tileset
- Level 1
    - Reversed gravity and controls
    - Layout is finished
    - Layout is upward progression
- Level Switcher is functional

### Issues
- Spamming left and right can be exploited by the players to avoid the timer

### Changed
- Camera view is now zoomed out a little bit from the original 3x to 2.5x
- New tileset has been implemented to give the world a new look

## [v0.2.1] – 2025-07-15

### Added
- Dynamic sound effect system via `AudioStreamPlayer2D`
    - Centralized sound manager with enum-based `SFX` lookup
    - Sound effects added:
        - `PICK_UP`
        - `EXPLOSION`
        - `HURT`
        - `JUMP`
        - `PATCH`
        - `TAP`
    - Supports overlapping sounds by instancing temporary players
    - Pitch variation for more natural feedback
    - Auto-cleanup using `finished` signal (Godot 4)
- Enhanced corruption timer display
    - Displays whole seconds by default
    - Switches to two decimal places in final countdown
    - Timer starts only after the player moves for the first time

### Changed
- Refactored `play_sfx()` to dynamically create and free sound players
- Player script updated to track `has_moved` and control timer start
- Timer label repositioned and anchored to stay centered at all times
- UI viewport scaling and font settings adjusted to improve clarity

### Fixed
- Timer no longer begins before any player input
- Label visibility issues caused by layering or camera movement

## [v0.2.0] – 2025-07-14

### Added
- New `StopPoint` system that can be patched by the player
- Safe zone detection via Area2D; timer now pauses when inside
- `"patch"` input support for interacting with glitch objects

### Changed
- Player script now tracks `is_in_safe_zone` to control corruption timer
- Stop zones are only active after being patched

### Fixed
- Timer no longer auto-unpauses when idle inside a patched zone
- Glitch tile interaction no longer conflicts with StopPoint behavior

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
