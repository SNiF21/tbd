extends CharacterBody2D

const SPEED: float = 50.0
const GRAVITY: float = 1200.0
const BOUNCE_VELOCITY: float = -320.0

var direction: float = -1.0
var is_dead: bool = false

func _ready() -> void:
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	#gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	#move
	velocity.x = direction * SPEED
	move_and_slide()

	#flip
	if is_on_wall():
		direction *= -1.0

	#collision
	for i: int in get_slide_collision_count():
		var collider: Object = get_slide_collision(i).get_collider()
		if collider is CharacterBody2D:
			if collider.name == "Player":
				handle_player_hit(collider)
			elif collider.name == "Companion":
				var linked_player: Node = collider.get("player")
				if linked_player != null and linked_player.has_method("die"):
					linked_player.call_deferred("die")

func handle_player_hit(player: CharacterBody2D) -> void:
	if is_dead:
		return

	#stomp
	if player.global_position.y < global_position.y - 20.0:
		is_dead = true
		player.velocity.y = BOUNCE_VELOCITY
		queue_free()
	else:
		player.call_deferred("die")
