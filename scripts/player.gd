extends CharacterBody2D

enum Emotion { NEUTRAL, RAGE, GRIEF }

@export var level_emotion: Emotion = Emotion.NEUTRAL

const SPEED: float = 220.0
const JUMP_VELOCITY: float = -400.0
const GRAVITY: float = 1200.0

var respawn_position: Vector2

@onready var visual_rect: ColorRect = $ColorRect
@onready var companion: Node2D = get_parent().get_node_or_null("Companion")

func _ready() -> void:
	respawn_position = global_position

	match level_emotion:
		Emotion.NEUTRAL:
			visual_rect.color = Color.WHITE
		Emotion.RAGE:
			visual_rect.color = Color.CRIMSON
		Emotion.GRIEF:
			visual_rect.color = Color.SLATE_BLUE

func _physics_process(delta: float) -> void:
	#gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	#jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	#left right movement
	var direction: float = Input.get_axis("move_left", "move_right")
	if direction != 0.0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)

	#standard method for movement
	move_and_slide()

	#landing next to or on enemy
	for i: int in get_slide_collision_count():
		var collider: Object = get_slide_collision(i).get_collider()
		if collider.has_method("handle_player_hit"):
			collider.handle_player_hit(self)

	#falling off map
	if global_position.y > 300.0:
		die()

func die() -> void:
	global_position = respawn_position
	velocity = Vector2.ZERO
	if companion != null and companion.has_method("reset_to_player"):
		companion.reset_to_player()
