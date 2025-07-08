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

var _player_world_pos: Vector2i = Vector2i(0, 0)
var _cam_mode: bool = true

var _loaded_bg_track: AudioStream = null


@onready var fade_effect: ColorRect = $CanvasLayer/FadeEffect
@onready var music_player = $MusicPlayer
@onready var dialog_box: TextureRect = $CanvasLayer/DialogBox
@onready var main_dialog_manager: DialogManager = $CanvasLayer/DialogManager


@onready var error_label = $ErrorLabel


func _enter_tree():
	Globals.main = self
	AudioServer.set_bus_volume_db(1, 0.0)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_toggle_bg_music"):
		if AudioServer.get_bus_volume_db(1) == 0:
			AudioServer.set_bus_volume_db(1, -80.0)
		else:
			AudioServer.set_bus_volume_db(1, 0)


func _ready() -> void:
	if !first_scene:
		error_label.text = "Oops, you didn't specify your \nstarting scene. " + \
		"\n\nBetter luck next debugging session." + \
		"\n\n\n\n\n\n\nP.S.\nAnd don't forget to take a break\nfrom time to time."
		return

	error_label.text = ""
	player_instance = _create_player()
	camera_instance = _create_camera()
	_player_world_pos = Vector2i(160, 120)
	change_scene(false, TRANSITION_SPEED_NORMAL, first_scene)


func _process(delta: float) -> void:
	if _cam_mode == true:
		_cam_follow_player()


func change_scene(fade_in: bool, duration_seconds: float, scene_path: String) -> void:
	if fade_in:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(fade_effect, "self_modulate", Color(0.0, 0.0, 0.0, 1.0), duration_seconds)
		await tween.finished

	if _current_scene:
		_current_scene.queue_free()

	var scene_instance = load(scene_path).instantiate()
	call_deferred("add_child", scene_instance)
	_current_scene = scene_instance

	player_instance.set_world_pos(_player_world_pos)
	scene_instance.initialize_room()
	player_instance.set_can_move(true)

	var tween: Tween = get_tree().create_tween()
	tween.tween_property(fade_effect, "self_modulate", Color(0.0, 0.0, 0.0, 0.0), duration_seconds)


#region Background Music Routines
func load_music(audio: AudioStream) -> void:
	_loaded_bg_track = audio


func play_music() -> void:
	music_player.stream = _loaded_bg_track
	music_player.play()
#endregion


func dialog_started(dialog: Dialog) -> void:
	player_instance.set_can_move(false)
	dialog_box.show()
	main_dialog_manager.load_dialog(dialog)
	main_dialog_manager.show()
	main_dialog_manager.show_dialog()


func dialog_finished() -> void:
	dialog_box.hide()
	player_instance.set_can_move(true)
	player_instance.set_dialog_state(false)


func toggle_camera_follow(follow: bool) -> void:
	_cam_mode = follow


func set_camera_limits(size: Vector2i) -> void:
	camera_instance.limit_left = 0
	camera_instance.limit_right = size.x
	camera_instance.limit_top = 0
	camera_instance.limit_bottom = size.y


func _cam_follow_player() -> void:
	camera_instance.global_position = player_instance.global_position


func _create_player() -> Player:
	var instance = load(_player_scene).instantiate()
	add_child(instance)
	return instance


func _create_camera() -> Camera2D:
	var instance = load(_camera_scene).instantiate()
	add_child(instance)
	return instance
