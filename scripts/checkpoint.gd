extends Area2D

var is_activated: bool = false

@onready var visual_rect: ColorRect = $ColorRect

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if is_activated or body.name != "Player":
		return

	is_activated = true
	visual_rect.color = Color(1.0, 0.84, 0.0, 0.4) # Translucent gold

	if "respawn_position" in body:
		# Origin is at the floor surface; player half-height is 20px
		body.respawn_position = Vector2(global_position.x, global_position.y - 20.0)
