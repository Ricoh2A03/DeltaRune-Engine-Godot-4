class_name TransitionTrigger extends Area2D


@export var to_room: String = ""
@export var pos_after_transit: Vector2i = Vector2i(0, 0)


func _on_body_entered(_body: Node2D) -> void:
	Globals.main.player_instance.set_can_move(false)
	Globals.main._player_world_pos = pos_after_transit
	Globals.main.change_scene(true, Globals.main.TRANSITION_SPEED_NORMAL, to_room)
