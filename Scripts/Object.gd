extends StaticBody2D

signal player_interacted(res)
signal page_changed(index)
signal player_exited

var player_is_colliding : bool = false
var canInteract : bool = true
var page_index : int = 0

export(Resource) var dialogue : Resource

func _ready():
	connect("player_interacted", $"/root/DialogueHandler", "_on_Object_player_interacted")
	connect("player_exited", $"/root/DialogueHandler", "_on_Object_player_exited")
	connect("player_interacted", $"../Player", "_on_Object_player_interacted")
	connect("player_exited", $"../Player", "_on_Object_player_exited")
	connect("page_changed", $"/root/DialogueHandler", "_on_Object_page_changed")
	$"/root/DialogueHandler".connect("player_unpause", self, "_on_DialogueHandler_player_unpause")
	
func _process(delta):
	print(page_index)
	var interact = Input.is_action_just_pressed("interact")
	if player_is_colliding:
		if interact and canInteract == true :
			canInteract = false
			emit_signal("player_interacted", dialogue)
			
		elif interact and canInteract == false : 
			if page_index == dialogue.Text.size() - 1:
				canInteract = true
				page_index = 0
				emit_signal("player_exited")
			elif page_index < dialogue.Text.size():
				next_page()
			
			
func next_page():
	page_index += 1
	emit_signal("page_changed", page_index)

func _on_InteractionArea_body_entered(body):
	if body is Player:
		player_is_colliding = true

func _on_InteractionArea_body_exited(body):
	if body is Player:
		player_is_colliding = false

func _on_DialogueHandler_player_unpause():
	canInteract = true
