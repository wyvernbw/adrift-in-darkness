extends KinematicBody2D

var look_dir : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO
var dir_index : int = 0
var looking_at_player : bool = false

export var speed : float = 100.0
export var look_distance : float = 100.0

enum LOOK_DIRECTIONS {
	UP = 0,
	RIGHT = 1,
	DOWN = 2,
	LEFT = 3
}

func _process(delta: float) -> void:
	
	#print(looking_at_player)
	
	update_view_raycasts()
	
	if $MoveTimer.time_left != 0:
		velocity.x += speed * look_dir.x
		velocity.y += speed * look_dir.y
	
	velocity.x = lerp(velocity.x, 0, 0.30)
	velocity.y = lerp(velocity.y, 0, 0.30)
	
	move_and_slide(velocity)

func _get_look_direction() -> Vector2:
	
	randomize()
	var id : int = rand_range(0.0, 3.0)
	id = int(id)
	
	var _look_dir : Vector2
	if id == LOOK_DIRECTIONS.UP:
		_look_dir = Vector2.UP
	if id == LOOK_DIRECTIONS.RIGHT:
		_look_dir = Vector2.RIGHT
	if id == LOOK_DIRECTIONS.DOWN:
		_look_dir = Vector2.DOWN
	if id == LOOK_DIRECTIONS.LEFT:
		_look_dir = Vector2.LEFT
		
	return _look_dir

func set_look_direction(dir : Vector2) -> void:
	if dir == null:
		return
	look_dir = dir
	
func update_view_raycasts() -> void:
	var view := $View 
	for Raycast2D in view.get_children():
		Raycast2D.cast_to.x = look_dir.x * look_distance
		Raycast2D.cast_to.y = look_dir.y * look_distance
		var dc = Raycast2D.get_collider()
		print(dc)
		if Raycast2D.get_collider() is Player:
			looking_at_player = true
			return
	looking_at_player = false

func _on_TurnTimer_timeout() -> void:
	var new_look_dir : Vector2 = _get_look_direction()
	set_look_direction(new_look_dir)


