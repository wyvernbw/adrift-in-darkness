extends StaticBody2D
class_name StaticObject

signal player_obtained_item(item)
signal player_interacted(res)

const INTERACT_DELAY: float = 0.050  # 50 ms

onready var InteractionArea = $InteractionArea

export var dialogue: Resource

var delay: float = 0
var delay_active: bool = false
var player_is_colliding: bool = false
var player_is_looking: bool = false
var can_interact: bool = true
var save_key
var interact


func _process(_delta: float) -> void:
	if not get_node_or_null("Debug"):
		return 
	$Debug/PlayerColliding.text = "colliding: %s" % player_is_colliding 
	$Debug/PlayerLooking.text = "looking: %s" % player_is_looking 


func _ready() -> void:
	connect_signals()
	save_key = self.get_path()
	add_to_group("save")
	if dialogue == null:
		GlobalHandler.Player.LookRaycast.add_exception(self)


func _input(event: InputEvent) -> void:
	if not GlobalHandler.Player.LookRaycast.get_collider() == InteractionArea:
		player_is_looking = false
		return
	else:
		player_is_looking = true
	if not player_is_colliding:
		return
	if GlobalHandler.InventoryGUI.visible:
		return
	if event.is_action_pressed("interact") and not DialogueHandler.dialogue_open:
		DialogueHandler.set_dialogue(dialogue)


func connect_signals() -> void:
	# Dialogue Handler
	DialogueHandler.connect("player_unpause", self, "on_DialogueHandler_player_unpaused")
	connect("next_page", DialogueHandler, "_on_Object_page_changed")
	connect("player_interacted", DialogueHandler, "_on_Object_player_interacted")


func _on_InteractionArea_body_entered(body) -> void:
	if not body is Player:
		return
	player_is_colliding = true
	print(player_is_colliding)


func _on_InteractionArea_body_exited(body) -> void:
	if not body is Player:
		return
	player_is_colliding = false
	can_interact = true
	print(player_is_colliding)


func on_DialogueHandler_player_unpaused():
	pass


func save_game(game_save: Resource) -> void:
	var save_dict : Dictionary = game_save.data[save_key]
	save_dict = {
		"position": {
			"x": position.x, 
			"y": position.y
		},
		"dialogue": dialogue,
	}


func load_game(game_save: Resource) -> void:
	var data: Dictionary = game_save.data[save_key]

	position.x = data["position"]["x"]
	position.y = data["position"]["y"]

	dialogue = data["dialogue"]


func action():
	pass  #Overwrite this function to add custom behavior
