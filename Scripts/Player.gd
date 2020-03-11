extends KinematicBody2D

class_name Player

const BASE_SPEED : float = 48.0
const MAX_STAMINA : float = 200.0

export(float) var deaccel : float = 0.30
export(float) var speed : float = 32.0
export(float) var sprint_speed : float = 96.0
export(float) var stagger_speed : float = 16.0

var move_dir : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO
var stamina : float = MAX_STAMINA
var moving : bool = false
var staggered : bool = false
var canMove : bool = true

func _physics_process(delta):
	if canMove:
		_get_input()
	_calculate_speed()
	
	#add to vector
	velocity.x += speed * move_dir.x
	velocity.y += speed * move_dir.y
	
	#apply friction
	velocity.x = lerp(velocity.x, 0, deaccel)
	velocity.y = lerp(velocity.y, 0, deaccel)
	
	#move body along vector
	move_and_slide(velocity, Vector2.UP)
	

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
		
	stamina = min(stamina, MAX_STAMINA)
	
	if not moving:
		stamina += 1
	
func _on_Object_player_exited():
	canMove = true

func _on_Object_player_interacted(res):
	canMove = false
	move_dir = Vector2.ZERO
	
func _on_InventoryGUI_inventory_opened():
	canMove = false
	move_dir = Vector2.ZERO
	
func _on_InventoryGUI_inventory_closed():
	canMove = true
