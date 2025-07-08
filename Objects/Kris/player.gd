class_name Player extends CharacterBody2D


const IDLE_ANIM = "res://Objects/Kris/Overworld/spr_frames_kris_idle.tres"
const WALK_ANIM = "res://Objects/Kris/Overworld/spr_frames_kris_walk.tres"

const WALK_SPEED: int = 65
const RUN_SPEED: int = 125


var _can_move: bool = false
var _dialog: bool = false

var _direction: Vector2i = Vector2i(0, 1)
var _curSpd: float = 0

var _idle_sprites
var _walk_sprites


@onready var sprite: AnimatedSprite2D = $Sprite
@onready var label: Label = $CanvasLayer/DebugLabel
@onready var interaction_checker: Area2D = $InteractionChecker
@onready var interaction_shape: CollisionShape2D = $InteractionChecker/InteractionShape


func _ready() -> void:
	_idle_sprites = load(IDLE_ANIM)
	_walk_sprites = load(WALK_ANIM)


#region Update Loop
func _process(delta: float) -> void:

	var input = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN").normalized()

	var interactables = interaction_checker.get_overlapping_areas()

	if _can_move:
		if input != Vector2(0, 0):
			_curSpd = WALK_SPEED
			sprite.sprite_frames = _walk_sprites
		else:
			_curSpd = 0
			sprite.sprite_frames = _idle_sprites

		_direction.x = snapped(input.x, abs(1))
		_direction.y = snapped(input.y, abs(1))

	velocity = input * _curSpd

	if _can_move:
		_animate_player()
		move_and_slide()

	if interactables:
		if Input.is_action_just_pressed("BTN_INTERACT") and !_dialog:
			_dialog = true
			interactables[0].start_dialog()

	label.text = "Input: " + var_to_str(input) + "\n" + \
				"Direction: " + var_to_str(_direction) + "\n" + \
				"CurSpd: " + var_to_str(_curSpd) + "\n" + \
				"Anim: " + var_to_str(sprite.animation) + "\n" + \
				"Can Move: " + var_to_str(_can_move)
#endregion


#region Functions
func _animate_player() -> void:
	if _direction.y < 0:
		sprite.play("up")
		interaction_shape.shape.size = Vector2i(10, 20)
		interaction_checker.position = Vector2i(0, -14)
	elif _direction.y > 0:
		sprite.play("down")
		interaction_shape.shape.size = Vector2i(10, 20)
		interaction_checker.position = Vector2i(0, 6)

	elif _direction.x > 0:
		sprite.play("right")
		interaction_shape.shape.size = Vector2i(20, 10)
		interaction_checker.position = Vector2i(10, -9)
	elif _direction.x < 0:
		sprite.play("left")
		interaction_shape.shape.size = Vector2i(20, 10)
		interaction_checker.position = Vector2i(-10, -9)
#endregion


#region Setters and Getters
func set_can_move(move: bool) -> void:
	velocity = Vector2(0, 0)
	sprite.sprite_frames = _idle_sprites
	sprite.stop()
	_can_move = move


func get_can_move() -> bool:
	return _can_move


func set_dialog_state(enabled: bool) -> void:
	var timer = get_tree().create_timer(0.05)
	await timer.timeout
	_dialog = enabled


func set_world_pos(pos: Vector2) -> void:
	self.global_position = pos
#endregion
