extends ColorRect
## Keeps the sea shader's rect_size in sync with this Control's size
## so the depth gradient stays relative (same shade at top/bottom) when resized.


func _ready() -> void:
	resized.connect(_on_resized)
	_update_shader_rect_size()


func _on_resized() -> void:
	_update_shader_rect_size()


func _update_shader_rect_size() -> void:
	if material is ShaderMaterial:
		# Use offset-based size so it works when Control is under Node2D (no layout)
		var rect_size_vec := Vector2(offset_right - offset_left, offset_bottom - offset_top)
		material.set_shader_parameter("rect_size", rect_size_vec)
