extends StaticBody2D

const MAX_SAVES : int = 1

onready var SAVE_KEY : String = name

var player_is_colliding : bool = false
var saves_left : int = MAX_SAVES

func _ready() -> void:
	if SaveGameHandler.save_object_dict.empty():
		SaveGameHandler.save_object_dict[SAVE_KEY] = saves_left
		return
	saves_left = SaveGameHandler.save_object_dict[SAVE_KEY]

func _process(delta: float) -> void:
	if player_is_colliding:
		var interact = Input.is_action_just_pressed("interact")
		if interact:
			if saves_left > 0: 
				saves_left -= 1
				SaveGameHandler.save_game()
				SaveGameHandler.save_object_dict[SAVE_KEY] = saves_left
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
