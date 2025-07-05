class_name Main extends Node


const TRANSITION_SPEED_FAST: float = 0.25
const TRANSITION_SPEED_NORMAL: float = 0.5
const TRANSITION_SPEED_LONG: float = 1.0
const TRANSITION_SPEED_LONGEST: float = 2


## Scene that will be loaded at the start of the game.
@export var first_scene: String


var player_instance: Player = null
var camera_instance: Camera2D = null


var _player_scene: String = "uid://dwyq18f0gn5kj"
var _camera_scene: String = "uid://c7rrg4fvt4xc7"

var _current_scene = null
var _current_room_size: Vector2i = Vector2i(0, 0)


@onready var fade_effect: ColorRect = $FadeEffect
@onready var music_player = $MusicPlayer
@onready var error_label = $ErrorLabel


func _enter_tree():
	Globals.main = self


func _ready() -> void:
	if !first_scene:
		error_label.text = "Oops, you didn't specify your \nstarting scene. " + \
		"\n\nBetter luck next debugging session." + \
		"\n\n\n\n\n\n\nP.S.\nAnd don't forget to take a break\nfrom time to time."
		return

	player_instance = _create_player()
	camera_instance = _create_camera()
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


func _create_player() -> Player:
	var instance = load(_player_scene).instantiate()
	add_child(instance)
	return instance


func _create_camera() -> Camera2D:
	var instance = load(_camera_scene).instantiate()
	add_child(instance)
	return instance
