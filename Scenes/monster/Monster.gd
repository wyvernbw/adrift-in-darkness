extends KinematicBody2D

var look_dir : Vector2 = Vector2.UP

enum LOOK_DIRECTIONS {
	UP = 0,
	RIGHT = 1,
	DOWN = 2,
	LEFT = 3
}

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
	
	$LookDirRaycast.cast_to.x = look_dir.x * 16
	$LookDirRaycast.cast_to.y = look_dir.y * 16
	
	
func _on_TurnTimer_timeout() -> void:
	var new_look_dir : Vector2 = _get_look_direction()
	set_look_direction(new_look_dir)
