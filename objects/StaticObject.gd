extends StaticBody2D
class_name StaticObject

signal player_obtained_item(item)
signal player_interacted(res)
signal next_page
signal text_ended

const INTERACT_DELAY: float = 0.050  # 50 ms

onready var DialogueHandler = $"/root/DialogueHandler"
onready var InventoryHandler = $"/root/InventoryHandler"
onready var InteractionArea = $InteractionArea

export var dialogue: Resource

var delay: float = 0
var delay_active: bool = false
var player_is_colliding: bool = false
var player_is_looking: bool = false
var can_interact: bool = true
var SAVE_KEY
var interact


func _ready() -> void:
	connect_signals()
	SAVE_KEY = self.get_path()
	add_to_group("save")


func _input(event: InputEvent) -> void:
	if not GlobalHandler.Player.LookRaycast.get_collider() == InteractionArea:
		return
	if not player_is_colliding:
		return
	if GlobalHandler.InventoryGUI.visible:
		return
	if event.is_action_pressed("interact") and not DialogueHandler.dialogue_open:
		DialogueHandler.set_dialogue(dialogue)


func connect_signals() -> void:
	#Dialoue Handler
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
	game_save.data[SAVE_KEY] = {
		"position": {"x": position.x, "y": position.y},
		"dialogue": {"item_name": "", "branch1_item_name": "", "branch2_item_name": ""}
	}
	if dialogue:
		game_save.data[SAVE_KEY]["dialogue"]["item_name"] = dialogue.item_name

		if not dialogue.Answers.empty():
			var answers: Array = dialogue.Answers.keys()
			var branch_1: Resource = dialogue.Answers[answers[0]]
			var item_branch_1: Item = Item.new(
				branch_1.item_name,
				branch_1.item_quantity,
				branch_1.item_texture,
				branch_1.item_type
			)
			var branch_2: Resource = dialogue.Answers[answers[1]]
			var item_branch_2: Item = Item.new(
				branch_2.item_name,
				branch_2.item_quantity,
				branch_2.item_texture,
				branch_2.item_type
			)
			game_save.data[SAVE_KEY]["dialogue"]["branch_1_item_name"] = dialogue.Answers[answers[0]].item_name
			game_save.data[SAVE_KEY]["dialogue"]["branch_2_item_name"] = dialogue.Answers[answers[1]].item_name


func load_game(game_save: Resource) -> void:
	var data: Dictionary = game_save.data[SAVE_KEY]

	position.x = data["position"]["x"]
	position.y = data["position"]["y"]

	if dialogue:
		var answers: Array = dialogue.Answers.keys()
		dialogue.item_name = data["dialogue"]["item_name"]
		if data["dialogue"].has("branch_1_item_name"):
			dialogue.Answers[answers[0]].item_name = data["dialogue"]["branch_1_item_name"]
		if data["dialogue"].has("branch_2_item_name"):
			dialogue.Answers[answers[1]].item_name = data["dialogue"]["branch_2_item_name"]


#--------------------------------------------------


func action():
	pass  #Overwrite this function to add custom behaviour
