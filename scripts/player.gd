extends CharacterBody2D

## When true, input is ignored and the player decelerates to a stop. Set by encounter logic.
var movement_locked: bool = false

const SPEED = 140.0
# Rate (units per second) at which velocity moves toward target; water resistance.
const WATER_DRAG = 600.0


func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	if not movement_locked:
		# 4-directional input (WASD / arrow keys via ui_* actions)
		direction = Vector2(
			Input.get_axis("ui_left", "ui_right"),
			Input.get_axis("ui_up", "ui_down")
		)

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		var target_x := direction.x * SPEED
		var target_y := direction.y * SPEED
		velocity.x = move_toward(velocity.x, target_x, WATER_DRAG * delta)
		velocity.y = move_toward(velocity.y, target_y, WATER_DRAG * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, WATER_DRAG * delta)
		velocity.y = move_toward(velocity.y, 0, WATER_DRAG * delta)

	move_and_slide()

	# Face the direction of horizontal movement (flip sprite when moving left).
	if velocity.x != 0:
		$"Animated Sprite".flip_h = velocity.x < 0
