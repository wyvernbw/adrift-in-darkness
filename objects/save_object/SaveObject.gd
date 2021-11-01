extends StaticBody2D

const MAX_SAVES : int = 1

onready var SAVE_KEY : String
onready var interaction_area : Area2D = $InteractionArea

export var player_path: NodePath

var player_is_colliding : bool = false
var saves_left : int = MAX_SAVES


func ready() -> void:
	SAVE_KEY = get_path()
	if saves_left == 0:
		$FlowrSprite.frame = 1
	else:
		$FlowerSprite.frame = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if not player_is_colliding:
			return
		if not GlobalHandler.Player.LookRaycast.get_collider() == self.interaction_area:
			return
		if saves_left == 0:
			return
		saves_left -= 1
		SaveGameHandler.save_game()
		$CanvasLayer/Label/Timer.start()
		$CanvasLayer/Label.visible = true
		if saves_left == 0:		
			$FlowerSprite.frame = 1


func _on_InteractionArea_body_entered(body: Node) -> void:
	if body is Player:
		player_is_colliding = true

func _on_InteractionArea_body_exited(body: Node) -> void:
	if body is Player:
		player_is_colliding = false

func _on_Timer_timeout() -> void:
	$CanvasLayer/Label.visible = false
