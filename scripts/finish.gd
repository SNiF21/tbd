extends Area2D

@export_file("*.tscn") var next_level_path: String = ""

@onready var visual_rect: ColorRect = $ColorRect

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(_delta: float) -> void:
	var remaining_enemies: int = get_tree().get_nodes_in_group("enemies").size()
	if remaining_enemies == 0:
		visual_rect.color = Color.LIME_GREEN
	else:
		visual_rect.color = Color.DARK_RED

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return

	var remaining_enemies: int = get_tree().get_nodes_in_group("enemies").size()
	if remaining_enemies == 0:
		if next_level_path != "":
			get_tree().call_deferred("change_scene_to_file", next_level_path)
		else:
			print("Level Cleared! (Assign next_level_path in Inspector once level_102 exists)")
	else:
		print("Door locked! Remaining enemies: ", remaining_enemies)
