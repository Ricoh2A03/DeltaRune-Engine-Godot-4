class_name Main extends Node


const TRANSITION_SPEED_FAST: float = 0.25
const TRANSITION_SPEED_NORMAL: float = 0.5
const TRANSITION_SPEED_LONG: float = 1.0
const TRANSITION_SPEED_LONGEST: float = 2


## Scene that will be loaded at the start of the game.
@export var first_scene: String


var _current_scene = null


@onready var fade_effect: ColorRect = $FadeEffect


func _ready() -> void:
	change_scene(false, TRANSITION_SPEED_NORMAL, first_scene)


func change_scene(fade_in: bool, duration_seconds: float, scene_path: String) -> void:
	if fade_in:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(fade_effect, "self_modulate", Color(0.0, 0.0, 0.0, 1.0), duration_seconds)
		await tween.finished
		tween.free()

	if _current_scene:
		_current_scene.queue_free()

	var scene_instance = load(scene_path).instantiate()
	call_deferred("add_child", scene_instance)
	_current_scene = scene_instance

	var tween: Tween = get_tree().create_tween()
	tween.tween_property(fade_effect, "self_modulate", Color(0.0, 0.0, 0.0, 0.0), duration_seconds)
