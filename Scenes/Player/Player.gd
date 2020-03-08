extends KinematicBody2D

class_name Player

export(float) var deaccel : float = 0.30
export(float) var speed : float = 64.0

var move_dir : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO

func _physics_process(delta):
	_get_input()
	
	velocity.x += speed * move_dir.x
	velocity.y += speed * move_dir.y
	
	velocity.x = lerp(velocity.x, 0, deaccel)
	velocity.y = lerp(velocity.y, 0, deaccel)
	
	move_and_slide(velocity, Vector2.UP)
	
func _get_input() -> void:
	#get keyboard input
	var moving_right 	= Input.is_action_pressed("move_right")
	var moving_left 	= Input.is_action_pressed("move_left")
	var moving_up 		= Input.is_action_pressed("move_up")
	var moving_down 	= Input.is_action_pressed("move_down")
	
	move_dir.x = int(moving_right) - int(moving_left)
	move_dir.y = int(moving_down) - int(moving_up)
	
