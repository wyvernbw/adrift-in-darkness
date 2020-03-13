extends Area2D

var player_is_colliding : bool

export(String) var scene_path : String
export(Vector2) var player_pos : Vector2
export(bool) var exit : bool

func _ready() -> void:
	$CanvasLayer/Sprite.visible = true
	$CanvasLayer/Sprite/AnimationPlayer.play("fade out")

func _process(delta):
	var interact = Input.is_action_just_pressed("interact")
	if player_is_colliding and interact:
		if scene_path:
			$CanvasLayer/Sprite/AnimationPlayer.play("fade in")
			
func _on_Door_body_entered(body):
	if body is Player:
		player_is_colliding = true
	print(player_is_colliding)

func _on_Door_body_exited(body):
	if body is Player:
		player_is_colliding = false
	print(player_is_colliding)

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "fade in":
		get_tree().change_scene(scene_path)
		$CanvasLayer/Sprite/AnimationPlayer.play("fade out")
