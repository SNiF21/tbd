extends CharacterBody2D

const DELAY_FRAMES: int = 30
const FOLLOW_OFFSET: Vector2 = Vector2(0.0, 14.0)

@export var player: CharacterBody2D

var position_history: Array[Vector2] = []

func _ready() -> void:
	if player == null:
		player = get_parent().get_node_or_null("Player") as CharacterBody2D

	if player != null:
		add_collision_exception_with(player)
		global_position = player.global_position + FOLLOW_OFFSET

func _physics_process(delta: float) -> void:
	if player == null:
		return

	position_history.append(player.global_position + FOLLOW_OFFSET)

	if position_history.size() > DELAY_FRAMES:
		var target_pos: Vector2 = position_history.pop_front()
		velocity = (target_pos - global_position) / delta
		move_and_slide()

	for i: int in get_slide_collision_count():
		var collider: Object = get_slide_collision(i).get_collider()
		if collider.has_method("handle_player_hit"):
			get_tree().call_deferred("reload_current_scene")
