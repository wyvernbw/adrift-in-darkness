extends StaticBody2D
class_name StaticObject

signal player_obtained_item(item)
signal player_interacted(res)
signal page_changed(index)
signal player_exited

onready var DialogueHandler = $"/root/DialogueHandler"
onready var InventoryHandler = $"/root/InventoryHandler"

var player_is_colliding : bool = false
var canInteract : bool = true
var page_index : int = 0
var item_held = null

export(Resource) var dialogue : Resource

func _ready() -> void:
	connect_signals()
	set_item()
	
func _process(delta) -> void:
	update_dialogue()
	action()


func connect_signals() -> void:
	#Dialoue Handler
	connect("player_interacted", DialogueHandler, "_on_Object_player_interacted")
	connect("player_exited", DialogueHandler, "_on_Object_player_exited")
	connect("player_interacted", $"../Player", "_on_Object_player_interacted")
	connect("player_exited", $"../Player", "_on_Object_player_exited")
	connect("page_changed", DialogueHandler, "_on_Object_page_changed")
	
	#InventoryHandler
	connect("player_obtained_item", InventoryHandler, "_on_Object_player_obtained_item")
	
func update_dialogue() -> void:
	var interact = Input.is_action_just_pressed("interact")
	if player_is_colliding:
		if interact and canInteract == true :
			canInteract = false
			emit_signal("player_interacted", dialogue)
			if item_held:
				emit_signal("player_obtained_item", item_held)
				item_held = null
		elif interact and canInteract == false : 
			if page_index == dialogue.Text.size() - 1:
				canInteract = true
				page_index = 0
				emit_signal("player_exited")
			elif page_index < dialogue.Text.size():
				next_page()

func next_page() -> void:
	page_index += 1
	if page_index > dialogue.Text.size():
		page_index = 0
		return
	emit_signal("page_changed", page_index)

func _on_InteractionArea_body_entered(body) -> void:
	if body is Player:
		player_is_colliding = true

func _on_InteractionArea_body_exited(body) -> void:
	if body is Player:
		player_is_colliding = false

func _on_DialogueHandler_player_unpause() -> void:
	canInteract = true

func _on_InventoryHandler_item_picked_up():
	pass #eventually call action()

#--------------------------------------------------
func set_item():
	pass
	
func action():
	pass #Overwrite this function to add custom behaviour
