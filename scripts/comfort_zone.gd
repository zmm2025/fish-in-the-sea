extends Node2D

## Comfort zone shown during the boss encounter. Displays a 48x48 px translucent bubble
## with the shell sprite at the center, and detects when the player enters the zone.
## Spawned by BossEncounter when the boss sequence begins.

signal player_entered_zone(body: Node2D)
signal player_exited_zone(body: Node2D)

const BUBBLE_RADIUS_PX: float = 24.0  ## 48x48 px diameter
const BUBBLE_COLOR := Color(0.75, 0.9, 1.0, 0.28)  ## Translucent aqua bubble


func _ready() -> void:
	var area := get_node_or_null("BubbleArea") as Area2D
	if area:
		area.body_entered.connect(_on_body_entered)
		area.body_exited.connect(_on_body_exited)


func _draw() -> void:
	draw_circle(Vector2.ZERO, BUBBLE_RADIUS_PX, BUBBLE_COLOR)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_entered_zone.emit(body)


func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_exited_zone.emit(body)
