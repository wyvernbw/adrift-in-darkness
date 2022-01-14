class_name Player
extends KinematicBody2D

signal player_look_dir_changed(look_dir)

const BASE_SPEED: float = 2400.0
const MAX_STAMINA: float = 600.0

export var deaccel: float = 0.30
export var speed: float = 24.0
export var sprint_speed: float = 48.0
export var stagger_speed: float = 16.0
export var walk_step_interval: float = 0.5
export var sprint_step_interval: float = 0.1
export var stop_bleeding_dialogue: Resource
export var cant_use_bandages_dialogue: Resource
export var bleeding_stopped_dialogue: Resource

var move_dir: Vector2 = Vector2.ZERO
export var look_dir: Vector2 = Vector2.DOWN
var last_look_dir: Vector2 = Vector2.DOWN
var velocity: Vector2 = Vector2.ZERO
var candle_item: Item = Item.new("Candle", 1, null, Item.ITEM_TYPES.NORMAL_ITEM)
var stamina: float = MAX_STAMINA
var moving: bool = false
var staggered: bool = false
var can_move: bool = true
var can_look: bool = true
var step_sounds: Array = []
var anim_suffix: String = ""
var insanity: int = 0
var save_key = "player"

onready var StepTimer := $Sounds/Move/StepTimer
onready var LookRaycast := $look_dir
onready var occluder_forward := preload("res://characters/player/occluder_polygon_forward.tres")
onready var occluder_side := preload("res://characters/player/occluder_polygon_side.tres")

"""
On different occasions and events, increase the insanity score. Higher insanity score means higher threats and visual confusion.
"""


func _ready() -> void:
	GlobalHandler.Player = self
	StepTimer.wait_time = walk_step_interval
	$Particles2D.emitting = false

	step_sounds.append(load("res://characters/player/wood_step1.wav"))
	step_sounds.append(load("res://characters/player/wood_step2.wav"))

	var _error
	_error = $"/root/DialogueHandler".connect("player_unpause", self, "_on_player_unpaused")
	_error = $"/root/DialogueHandler".connect("player_pause", self, "_on_player_paused")
	_error = connect("player_look_dir_changed", $Lantern, "_on_player_look_dir_changed")

	add_to_group("persist")


func _physics_process(delta: float) -> void:
	apply_motion(delta)
	apply_friction(delta)

	# move body along vector
	velocity = move_and_slide(velocity, Vector2.ZERO)
	

func _process(_delta): 
	change_occluder(look_dir)
	change_animation_speed(speed / 600)
	if moving:
		play_anim("move_", look_dir)
	else:
		play_anim("idle_", look_dir)
	if HpHandler.bleeding_limbs["left_arm"]:
		$Particles2D.emitting = true
		anim_suffix = "_left_arm"
	else:
		$Particles2D.emitting = false

	if not InventoryHandler.get_item(candle_item) == -1:
		$Candle.visible = true

	if can_move:
		_get_input()
	_calculate_speed()
	if can_look:
		_update_look_dir()


func apply_motion(delta):
	velocity = move_dir * speed * delta

func apply_friction(delta):
	velocity.x = lerp(velocity.x, 0, deaccel * delta)
	velocity.y = lerp(velocity.y, 0, deaccel * delta)


func _update_look_dir() -> void:
	if Input.is_action_pressed("move_right"):
		look_dir = Vector2.RIGHT
	if Input.is_action_pressed("move_left"):
		look_dir = Vector2.LEFT
	if Input.is_action_pressed("move_down"):
		look_dir = Vector2.DOWN
	if Input.is_action_pressed("move_up"):
		look_dir = Vector2.UP
	if look_dir != last_look_dir: 
		emit_signal("player_look_dir_changed", look_dir)
	last_look_dir = look_dir

	LookRaycast.cast_to = look_dir * 8


func _get_input() -> void:
	#get keyboard input
	var moving_right := Input.get_action_strength("move_right")
	var moving_left := Input.get_action_strength("move_left")
	var moving_up := Input.get_action_strength("move_up")
	var moving_down := Input.get_action_strength("move_down")

	move_dir.x = moving_right - moving_left
	move_dir.y = moving_down - moving_up

	if move_dir.x == 0 and move_dir.y == 0:
		moving = false
	else:
		moving = true


func _calculate_speed() -> void:
	if Input.is_action_pressed("sprint"):
		if stamina > 0 and moving and not staggered:
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


func play_anim(anim: String, dir: Vector2) -> void:
	var dir_str: String = "up"
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


func change_animation_speed(fps: float) -> void:
	var sprite: AnimatedSprite = $AnimatedSprite
	sprite.frames.set_animation_speed(sprite.animation, fps)


func change_occluder(dir: Vector2) -> void:
	if dir.y != 0:
		$LightOccluder2D.occluder = occluder_forward
		$LightOccluder2D.position.x = 0
		$LightOccluder2D.position.y = 3 if dir.y == -1 else -16
	if dir.x != 0:
		$LightOccluder2D.occluder = occluder_side
		$LightOccluder2D.position.y = 0
		$LightOccluder2D.position.x = 6 if dir.x == -1 else -2
		

func save() -> Dictionary:
	var save_dict: Dictionary = {}
	save_dict["save_path"] = SaveGameHandler.SAVE_FOLDER + "player/player.tscn"
	var player_scene = PackedScene.new()
	player_scene.pack(self)
	var _save_error = ResourceSaver.save(save_dict["save_path"], player_scene)
	return save_dict


func load(save: Dictionary) -> void:
	var player_node = load(save["save_path"]).instance()
	self.replace_by(player_node)


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
