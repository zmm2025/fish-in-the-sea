class_name BossEncounterConfig
extends Resource

## Single config resource for the boss encounter sequence. Edit in Inspector or replace
## the resource file to customize. Assign to BossEncounter or use default path.

## Seconds after entering detection radius before the screen turns black.
@export var pre_black_duration: float = 2.0
## Seconds the black screen is shown before the boss reveal.
@export var black_duration: float = 1.0
## Color of the black screen during the transition.
@export var black_color: Color = Color.BLACK
## World X position where the sea urchin appears after transforming to boss form.
@export var boss_position_x: float = 104.0
## World Y position where the sea urchin appears after transforming to boss form.
@export var boss_position_y: float = -40.0
## Padding (world units) around player and enemy when framing them in boss camera mode.
@export var camera_padding: float = 24.0
## Zoom value of the initial game view. Camera will never zoom in past this (only zoom out to fit both subjects).
@export var camera_initial_zoom: float = 4.0
## Pixels of margin extending past the boss center (along the player-to-boss line) that must stay in view. 0 = only boss center.
@export var boss_protection_margin: int = 0
## Path to the boss sprite texture (used when transforming from small to boss form).
@export var boss_sprite_path: String = "res://assets/characters/boss-sea-urchin/boss-sea-urchin.png"
## World Y value that the bottom of the boss camera view must never go below (floor limit).
@export var camera_floor_limit: float = 80.0

## Path to the projectile sprite (e.g. Z spritesheet). Used when boss shoots.
@export var projectile_sprite_path: String = "res://assets/decorations/z.png"
## Horizontal and vertical frame count of the projectile spritesheet. Use 1,1 for a single image.
@export var projectile_sprite_hframes: int = 1
@export var projectile_sprite_vframes: int = 1
## Speed (pixels per second) of boss projectiles.
@export var projectile_speed: float = 120.0
## Seconds between each projectile spawn.
@export var projectile_shoot_interval: float = 0.25


func get_boss_position() -> Vector2:
	return Vector2(boss_position_x, boss_position_y)
