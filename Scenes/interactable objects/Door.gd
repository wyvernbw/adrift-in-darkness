extends Area2D

var player_is_colliding

func _on_Door_body_entered(body):
	if body is Player:
		player_is_colliding = true
	print(player_is_colliding)

func _on_Door_body_exited(body):
	if body is Player:
		player_is_colliding = false
	print(player_is_colliding)
