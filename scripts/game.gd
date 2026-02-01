extends Node2D

## World Y value that the bottom of the view must never go below (floor). The camera follows the player
## but will not move down past this limit (bottom of screen stays at or above this Y).
## Only offsets the camera when at the floor; otherwise stays centered on the player.
## Configure in the Inspector on the Game node.
@export var camera_min_bottom_height: float = 0.0

var _title_screen: CanvasLayer


func _ready() -> void:
	_title_screen = get_node_or_null("TitleScreen") as CanvasLayer
	_update_title_size()
	var player := get_node_or_null("Player") as CharacterBody2D
	var enemy := get_node_or_null("Enemy")
	if not player or not enemy or not enemy.has_signal("player_entered_range"):
		return

	enemy.player_entered_range.connect(_on_enemy_player_entered_range.bind(player, enemy))


func _update_title_size() -> void:
	var title_rect := _title_screen.get_node_or_null("CenterContainer/TextureRect") as TextureRect if _title_screen else null
	if not title_rect or not title_rect.texture:
		return
	var vp_size := get_viewport().get_visible_rect().size
	var tex_size := title_rect.texture.get_size()
	var target_width := vp_size.x * 0.5
	var target_height := target_width * (tex_size.y / tex_size.x) if tex_size.x > 0 else target_width
	title_rect.custom_minimum_size = Vector2(target_width, target_height)


func _input(event: InputEvent) -> void:
	if _title_screen and _title_screen.visible and event is InputEventKey and event.pressed:
		_title_screen.visible = false
		get_viewport().set_input_as_handled()


func _process(_delta: float) -> void:
	var player := get_node_or_null("Player") as Node2D
	var camera := _get_main_camera()
	if not player or not camera:
		return

	var boss_encounter := get_node_or_null("BossEncounter")
	if boss_encounter and boss_encounter.is_encounter_active:
		# Boss encounter handles its own camera when active; skip normal camera logic.
		return

	var view_size := get_viewport().get_visible_rect().size
	var half_view_y := (view_size.y / 2.0) / camera.zoom.y
	var max_camera_center_y := camera_min_bottom_height - half_view_y

	if camera.get_parent() == player:
		var centered_global_y := player.global_position.y
		if centered_global_y <= max_camera_center_y:
			camera.position.y = 0.0
		else:
			camera.position.y = max_camera_center_y - player.global_position.y
	else:
		if camera.global_position.y > max_camera_center_y:
			camera.global_position.y = max_camera_center_y


func _get_main_camera() -> Camera2D:
	var player := get_node_or_null("Player") as Node2D
	if player:
		var cam := player.get_node_or_null("Camera") as Camera2D
		if cam:
			return cam
	return get_viewport().get_camera_2d() as Camera2D


func _on_enemy_player_entered_range(player: CharacterBody2D, enemy: Node2D) -> void:
	var boss_encounter := get_node_or_null("BossEncounter")
	if boss_encounter and boss_encounter.has_method("start_encounter"):
		boss_encounter.start_encounter(player, enemy)
	else:
		player.movement_locked = true
		enemy.show_dialogue_line("...huh?")
