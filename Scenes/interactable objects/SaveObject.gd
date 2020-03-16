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


func _on_InteractionArea_body_entered(body: Node) -> void:
	if body is Player:
		player_is_colliding = true

func _on_InteractionArea_body_exited(body: Node) -> void:
	if body is Player:
		player_is_colliding = false
