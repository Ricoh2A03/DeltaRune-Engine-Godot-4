class_name DialogManager extends Node2D

const PORTRAIT_POSITION: Vector2i = Vector2i(52, 34)

const TEXT_POSITION_NORMAL: Vector2i = Vector2i(28, 0)
const TEXT_POSITION_DIALOG: Vector2i = Vector2i(83, 0)

const TEXT_SPEED_NORMAL: float = 0.055


var _current_dialog: Dialog
var _paragraphs: int = 0
var _current_paragraph: int = 0
var _text_speed: float = 0.0
var _portrait: Texture2D

var _typing: bool = false
var _finished: bool = false


@onready var text: Label = $Text
@onready var text_sound: AudioStreamPlayer = $TextSound
@onready var portait: Sprite2D = $Portait

@onready var timer: Timer = $Timer


func _ready() -> void:
	text.visible_ratio = 0.0
	text.text = ""


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("BTN_CANCEL") and _typing:
		text.visible_characters = _current_dialog.dialog_text[_current_paragraph].length()
	if event.is_action_pressed("BTN_INTERACT") and !_typing and _finished:
		text.text = ""
		if _current_paragraph < _paragraphs:
			_current_paragraph += 1
			show_dialog()
		else:
			_current_dialog = null
			_paragraphs = 0
			_current_paragraph = 0
			_typing = false
			_finished = false
			Globals.main.dialog_finished()


func load_dialog(dialog: Dialog) -> void:
	_current_dialog = dialog
	_paragraphs = dialog.dialog_text.size() - 1
	if dialog.paragraph_speed.size() != 0:
		_text_speed = dialog.paragraph_speed[0]
		timer.wait_time = _text_speed
	else:
		_text_speed = TEXT_SPEED_NORMAL
		timer.wait_time = _text_speed
	set_dialog_sound()


func show_dialog() -> void:
	text.visible_characters = 2
	text.text = _current_dialog.dialog_text[_current_paragraph]
	timer.start()
	_typing = true
	_finished = false


func set_dialog_sound() -> void:
	text_sound.stream = _current_dialog.sound


func _on_timer_timeout() -> void:
	if text.visible_characters < _current_dialog.dialog_text[_current_paragraph].length():
		text_sound.play()
		text.visible_characters += 1
	else:
		timer.stop()
		_typing = false
		_finished = true
