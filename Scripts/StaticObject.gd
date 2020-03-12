extends StaticBody2D
class_name StaticObject

signal player_obtained_item(item)
signal player_interacted(res)
signal next_page
signal text_ended

onready var DialogueHandler = $"/root/DialogueHandler"
onready var InventoryHandler = $"/root/InventoryHandler"

var player_is_colliding : bool = false
var canInteract : bool = true
var item_held = null

export(Resource) var dialogue : Resource

func _ready() -> void:
	connect_signals()
	if dialogue.item_name == null:
		return
	if dialogue.item_texture == null:
		return
	if dialogue.item_quantity == null:
		return
	item_held = Item.new(
		dialogue.item_name,
		dialogue.item_quantity,
		dialogue.item_texture,
		dialogue.item_type
	)
	
func _process(delta) -> void:
	update_dialogue()
	action()
	
func connect_signals() -> void:
	#Dialoue Handler
	connect("next_page", DialogueHandler, "_on_Object_page_changed")
	connect("player_interacted", DialogueHandler, "_on_Object_player_interacted")
	connect("text_ended", DialogueHandler, "_on_Object_text_ended")
	
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
			if DialogueHandler.page_index >= dialogue.Text.size() - 1:
				if not dialogue.Answers.empty() and not DialogueHandler.dialogue_branching:
					emit_signal("text_ended")
				if dialogue.Answers.empty():
					canInteract = true
			elif DialogueHandler.page_index <= dialogue.Text.size():
				emit_signal("next_page")
				
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

func action():
	pass #Overwrite this function to add custom behaviour
