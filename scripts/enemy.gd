@tool
extends Area2D

## Emitted when the player enters the detection radius.
signal player_entered_range
## Emitted when the player leaves the detection radius.
signal player_exited_range

## True while the player is within the detection area.
var is_player_near: bool = false

## True after the first encounter has been triggered (prevents re-triggering).
var _encounter_triggered: bool = false

## Radius of the detection area (pixels). Adjust in the Inspector to change how close the player must be to trigger detection.
var _detection_radius: float = 80.0
@export var detection_radius: float = 80.0:
	set(value):
		_detection_radius = value
		_update_detection_shape_radius()
	get:
		return _detection_radius


func _ready() -> void:
	add_to_group("enemies")
	_update_detection_shape_radius()
	if not Engine.is_editor_hint():
		body_entered.connect(_on_body_entered)
		body_exited.connect(_on_body_exited)


func _update_detection_shape_radius() -> void:
	if not is_inside_tree():
		return
	var detection_node := get_node_or_null("DetectionShape")
	if not detection_node:
		return
	var shape := detection_node.shape as CircleShape2D
	if shape:
		shape.radius = detection_radius
		shape.emit_changed()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_player_near = true
		if not _encounter_triggered:
			_encounter_triggered = true
			player_entered_range.emit()


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_player_near = false
		player_exited_range.emit()


## Displays dialogue text above the enemy. The label is positioned in world space as a child of this node.
func show_dialogue_line(text: String) -> void:
	var label := get_node_or_null("DialogueLabel") as Label
	if label:
		label.text = text
		label.visible = true
