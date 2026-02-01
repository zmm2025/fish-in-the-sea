extends Area2D

## Boss projectile that moves in a direction and is removed on collision with any body
## except the boss. Set by the spawner: direction, speed, exclude_boss, and sprite frame.

var direction: Vector2 = Vector2.DOWN
var speed: float = 120.0
## If set, bodies that are descendants of this node are ignored (projectile does not collide with boss).
var exclude_boss: Node2D = null


func _ready() -> void:
	if not Engine.is_editor_hint():
		body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if exclude_boss and exclude_boss.is_ancestor_of(body):
		return
	if body.name == "Player":
		get_tree().reload_current_scene()
	queue_free()
