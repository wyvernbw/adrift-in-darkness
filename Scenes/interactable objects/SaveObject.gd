extends StaticBody2D

const MAX_SAVES = 1

var player_is_colliding = false
var saves_left = MAX_SAVES
	
func _process(delta: float) -> void:
	if player_is_colliding:
		var interact = Input.is_action_just_pressed("interact")
		if interact:
			if saves_left > 0:
				SaveGameHandler.save_game()
				saves_left -= 1 
				print("saved")
				$CanvasLayer/Label/Timer.start()
				$CanvasLayer/Label.visible = true
	if saves_left > 0:
		$FlowerSprite.frame = 0
	else: 
		$FlowerSprite.frame = 1


func _on_InteractionArea_body_entered(body: Node) -> void:
	if body is Player:
		player_is_colliding = true

func _on_InteractionArea_body_exited(body: Node) -> void:
	if body is Player:
		player_is_colliding = false


func _on_Timer_timeout() -> void:
	$CanvasLayer/Label.visible = false
