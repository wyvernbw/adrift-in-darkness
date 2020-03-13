extends KinematicBody2D
class_name Player

const BASE_SPEED : float = 48.0
const MAX_STAMINA : float = 200.0

export(float) var deaccel : float = 0.30
export(float) var speed : float = 32.0
export(float) var sprint_speed : float = 96.0
export(float) var stagger_speed : float = 16.0

var move_dir : Vector2 = Vector2.ZERO
var look_dir : Vector2 = Vector2.DOWN
var look_raycast_colliding : bool = false
var velocity : Vector2 = Vector2.ZERO
var stamina : float = MAX_STAMINA
var moving : bool = false
var staggered : bool = false
var canMove : bool = true
var canLook : bool = true

func _ready():
	$"/root/DialogueHandler".connect("player_unpause", self, "_on_player_unpaused")
	$"/root/DialogueHandler".connect("player_pause", self, "_on_player_paused")

func _physics_process(delta):
	if canMove:
		_get_input()
	_calculate_speed()
	if canLook:
		_update_look_dir()
	
	#add to vector
	velocity.x += speed * move_dir.x
	velocity.y += speed * move_dir.y
	
	#apply friction
	velocity.x = lerp(velocity.x, 0, deaccel)
	velocity.y = lerp(velocity.y, 0, deaccel)
	
	#move body along vector
	move_and_slide(velocity, Vector2.UP)
	
func _update_look_dir() -> void:
	if Input.is_action_pressed("move_right"):
		look_dir = Vector2.RIGHT
	if Input.is_action_pressed("move_left"):
		look_dir = Vector2.LEFT
	if Input.is_action_pressed("move_down"):
		look_dir = Vector2.DOWN
	if Input.is_action_pressed("move_up"):
		look_dir = Vector2.UP
	$look_dir.cast_to = look_dir * 8
	if $look_dir.is_colliding():
		look_raycast_colliding = true
	else:
		look_raycast_colliding = false
	
func _get_input() -> void:
	#get keyboard input
	var moving_right 	= Input.is_action_pressed("move_right")
	var moving_left 	= Input.is_action_pressed("move_left")
	var moving_up 		= Input.is_action_pressed("move_up")
	var moving_down 	= Input.is_action_pressed("move_down")
	
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
		else:
			speed = BASE_SPEED
	else:
		speed = BASE_SPEED
		stamina += 1
	
	if stamina == 0 and staggered == false:
		staggered = true
	if stamina == 200 and staggered == true:
		staggered = false
	if staggered:
		speed = stagger_speed
		
	stamina = clamp(stamina, 0, MAX_STAMINA)
	
	if not moving:
		stamina += 1

func _on_player_unpaused() -> void:
	canMove = true
	canLook = true
	DialogueHandler.page_index = 0
	DialogueHandler.dialogue_branching = false
	DialogueHandler.dialogue_open = false

func _on_player_paused() -> void:
	canMove = false
	canLook = false
	move_dir = Vector2.ZERO

