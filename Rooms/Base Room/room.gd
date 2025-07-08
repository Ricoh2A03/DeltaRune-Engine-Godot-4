class_name Room extends Node2D


@export_category("Background Music")
## Music track that will start playing when this room is loaded.
@export var music_track: AudioStream
## Stops playing background music when this room is loaded.[br]
## Ignores the [member music_track] parameter.
@export var stop_music: bool = false

@export_category("Room Size")
## Determines the width and height of the room.
@export var room_size: Vector2i


func initialize_room() -> void:
	if Globals.main._loaded_bg_track != music_track and music_track != null and !stop_music:
		Globals.main.load_music(music_track)
		Globals.main.play_music()
	Globals.main.set_camera_limits(room_size)
