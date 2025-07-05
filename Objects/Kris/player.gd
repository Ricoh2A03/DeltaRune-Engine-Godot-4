class_name Player extends CharacterBody2D


const IDLE_ANIM = "res://Objects/Kris/Overworld/spr_frames_kris_idle.tres"
const WALK_ANIM = "res://Objects/Kris/Overworld/spr_frames_kris_walk.tres"

const WALK_SPEED: int = 60
const RUN_SPEED: int = 90


var _can_move: bool = true

var _direction: Vector2i = Vector2i(0, 1)
var _curSpd: float = 0

var _idle_sprites
var _walk_sprites


@onready var sprite: AnimatedSprite2D = $Sprite
@onready var label: Label = $CanvasLayer/DebugLabel


func _ready() -> void:
	_idle_sprites = load(IDLE_ANIM)
	_walk_sprites = load(WALK_ANIM)

	$Camera2D.limit_left = 0
	$Camera2D.limit_top = 0
	$Camera2D.limit_right = 320
	$Camera2D.limit_bottom = 240


#region Update Loop
func _process(delta: float) -> void:

	var input = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN").normalized()

	if _can_move:
		if input != Vector2(0, 0):
			_curSpd = WALK_SPEED
			sprite.sprite_frames = _walk_sprites
		else:
			_curSpd = 0
			sprite.sprite_frames = _idle_sprites

		_direction.x = snapped(input.x, abs(1))
		_direction.y = snapped(input.y, abs(1))

		_animate_player()

	velocity = input * _curSpd

	label.text = "Input: " + var_to_str(input) + "\n" + \
				"Direction: " + var_to_str(_direction) + "\n" + \
				"CurSpd: " + var_to_str(_curSpd) + "\n" + \
				"Anim: " + var_to_str(sprite.animation) + "\n" + \
				"Can Move: " + var_to_str(_can_move)

	move_and_slide()
#endregion


#region Functions
func _animate_player() -> void:
	if _direction.y < 0: sprite.play("up")
	elif _direction.y > 0: sprite.play("down")

	elif _direction.x > 0: sprite.play("right")
	elif _direction.x < 0: sprite.play("left")
#endregion


#region Setters and Getters
func _set_can_move(move: bool) -> void:
	_can_move = move


func _get_can_move() -> bool:
	return _can_move


func _set_world_pos(pos: Vector2) -> void:
	self.global_position = pos
#endregion
