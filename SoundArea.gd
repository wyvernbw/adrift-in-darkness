tool
extends Area2D

export var activate_once : bool = false
export var on_player_enter : bool = false
export var on_player_exit : bool = false
export var collision_box_size : Vector2 = Vector2.ZERO
export var volume_db : float = 0.0

var activated : bool

func _physics_process(delta: float) -> void:
	$CollisionShape2D.shape.extents.x = collision_box_size.x
	$CollisionShape2D.shape.extents.y = collision_box_size.y
	$sound.volume_db = volume_db

func _on_SoundArea_body_entered(body: Node) -> void:
	if on_player_enter == true:
		if body is Player:
			if activate_once == true and activated == false:
				$sound.play()
				activated = true
				return
			if activate_once == false:
				$sound.play()
		
func _on_SoundArea_body_exited(body: Node) -> void:
	if on_player_exit == true:
		if body is Player:
			if activate_once == true and activated == false:
				$sound.play()
				activated = true
			if activate_once == false:
				$sound.play()
