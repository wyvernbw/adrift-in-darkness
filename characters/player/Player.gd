class_name Player
extends KinematicBody2D

const BASE_SPEED: float = 24.0
const MAX_STAMINA: float = 600.0

export var deaccel: float = 0.30
export var speed: float = 24.0
export var sprint_speed: float = 48.0
export var stagger_speed: float = 16.0
export var walk_step_interval: float = 0.5
export var sprint_step_interval: float = 0.1

var SAVE_KEY: String = "player"
var move_dir: Vector2 = Vector2.ZERO
export var look_dir: Vector2 = Vector2.DOWN
var velocity: Vector2 = Vector2.ZERO
var stamina: float = MAX_STAMINA
var moving: bool = false
var staggered: bool = false
var can_move: bool = true
var can_look: bool = true
var step_sounds: Array = []
var anim_suffix: String = ""
var insanity: int = 0

onready var StepTimer := $Sounds/Move/StepTimer
onready var LookRaycast := $look_dir

"""
On different occasions and events, increase the insanity score. Higher insanity score means higher threats and visual confusion.
"""

func _ready() -> void:
	GlobalHandler.Player = self
	StepTimer.wait_time = walk_step_interval
	$Particles2D.visible = false

	step_sounds.append(load("res://characters/player/wood_step1.wav"))
	step_sounds.append(load("res://characters/player/wood_step2.wav"))
	
	$"/root/DialogueHandler".connect("player_unpause", self, "_on_player_unpaused")
	$"/root/DialogueHandler".connect("player_pause", self, "_on_player_paused")

func _physics_process(delta : float) -> void:
	if GlobalHandler.left_arm == false:
		anim_suffix = "_left_arm"
		$Particles2D.visible = true
	if can_move:
		_get_input()
	_calculate_speed()
	if can_look:
		_update_look_dir()
	
	if moving:
		play_anim("move_", look_dir)
	else:
		play_anim("idle_", look_dir)
		
	apply_motion()
	apply_friction()
	change_animation_speed(speed / 6)
	
	#move body along vector
	move_and_slide(velocity, Vector2.UP)
	
func apply_motion():
	velocity.x += speed * move_dir.x
	velocity.y += speed * move_dir.y
	
func apply_friction():
	velocity.x = lerp(velocity.x, 0, deaccel)
	velocity.y = lerp(velocity.y, 0, deaccel)

func _update_look_dir() -> void:
	if Input.is_action_pressed("move_right"):
		look_dir = Vector2.RIGHT
	if Input.is_action_pressed("move_left"):
		look_dir = Vector2.LEFT
	if Input.is_action_pressed("move_down"):
		look_dir = Vector2.DOWN
	if Input.is_action_pressed("move_up"):
		look_dir = Vector2.UP
	
	LookRaycast.cast_to = look_dir * 8
	
func _get_input() -> void:
	#get keyboard input
	var moving_right := Input.is_action_pressed("move_right")
	var moving_left := Input.is_action_pressed("move_left")
	var moving_up := Input.is_action_pressed("move_up")
	var moving_down := Input.is_action_pressed("move_down")
	
	move_dir.x = int(moving_right) - int(moving_left)
	move_dir.y = int(moving_down) - int(moving_up)
	
	if move_dir.x == 0 and move_dir.y == 0:
		moving = false
	else:
		moving = true

func _calculate_speed() -> void:
	if Input.is_action_pressed("sprint"):
		if stamina > 0 and moving and not staggered :
			speed = sprint_speed
			stamina -= 1
			StepTimer.wait_time = sprint_step_interval
		else:
			speed = BASE_SPEED
			StepTimer.wait_time = walk_step_interval
	else:
		speed = BASE_SPEED
		stamina += 1
		StepTimer.wait_time = walk_step_interval
	
	if stamina == 0 and staggered == false:
		staggered = true
	if stamina == 200 and staggered == true:
		staggered = false
	if staggered:
		speed = stagger_speed
		
	stamina = clamp(stamina, 0, MAX_STAMINA)
	
	if not moving:
		stamina += 1
		
func play_anim(anim : String, dir : Vector2) -> void:
	var dir_str : String = "up"
	match dir:
		Vector2.RIGHT:
			dir_str = "right"
		Vector2.LEFT:
			dir_str = "left"
		Vector2.UP: 
			dir_str = "up"
		Vector2.DOWN:
			dir_str = "down"
	
	$AnimatedSprite.play(anim + dir_str + anim_suffix)


func change_animation_speed(fps : float) -> void:
	var sprite: AnimatedSprite = $AnimatedSprite
	sprite.frames.set_animation_speed(sprite.animation, fps)
	

func save_game(game_save : Resource) -> void:
	game_save.data[SAVE_KEY] = {
		'position' : {
			'x' : position.x ,
			'y' : position.y
		},
		'current_scene' : get_node('/root/Game').current_scene
	}
	print(game_save.data[SAVE_KEY])

func load_game(game_save : Resource) -> void:
	var data: Dictionary = game_save.data[SAVE_KEY]
	print(data)
	position = Vector2.ZERO
	get_node('/root/Game').switch_scene(data['current_scene'])
	position.x = data['position']['x']
	position.y = data['position']['y']
	
"""
SIGNAL METHODS vvv
"""
	
func _on_StepTimer_timeout() -> void:
	if moving:
		randomize()
		var sound_index = int(rand_range(1, 3))
		$Sounds/Move.stream = step_sounds[sound_index - 1]
		$Sounds/Move.play()

func _on_player_unpaused() -> void:
	can_move = true
	can_look = true
	DialogueHandler.page_index = 0
	DialogueHandler.dialogue_branching = false
	DialogueHandler.dialogue_open = false

func _on_player_paused() -> void:
	can_move = false
	can_look = false
	moving = false
	move_dir = Vector2.ZERO

func _on_InventoryGUI_inventory_closed() -> void:
	can_move = true
	can_look = true

func _on_InventoryGUI_inventory_opened() -> void:
	can_move = false
	can_look = false
	moving = false
	move_dir = Vector2.ZERO
