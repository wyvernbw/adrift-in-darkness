extends StaticBody2D
class_name StaticObject

signal player_obtained_item(item)
signal player_interacted(res)
signal next_page
signal text_ended

onready var DialogueHandler = $"/root/DialogueHandler"
onready var InventoryHandler = $"/root/InventoryHandler"
onready var inv_gui
onready var playerNode

var player_is_colliding : bool = false
var player_is_looking : bool = false
var canInteract : bool = true
var SAVE_KEY

export var inv_gui_path : NodePath
export var playerPath : NodePath
export var dialogue : Resource

func _ready() -> void:
	connect_signals()
	SAVE_KEY = name
	add_to_group("save")
	inv_gui = get_node(inv_gui_path)
	playerNode = get_node(playerPath)

func _process(delta) -> void:
	update_dialogue()
	action()
	if playerNode.look_raycast_colliding:
		player_is_looking = true
	else:
		player_is_looking = false

func connect_signals() -> void:
	#Dialoue Handler
	DialogueHandler.connect("player_unpause", self, "on_DialogueHandler_player_unpaused")
	connect("next_page", DialogueHandler, "_on_Object_page_changed")
	connect("player_interacted", DialogueHandler, "_on_Object_player_interacted")
	connect("text_ended", DialogueHandler, "_on_Object_text_ended")

func update_dialogue() -> void:
	var interact = Input.is_action_just_pressed("interact")
	if player_is_colliding == false:
		return

	if player_is_looking == false:
		return

	if dialogue == null:
		return

	if interact == false:
		return

	if canInteract == false:
		if DialogueHandler.page_index < dialogue.Text.size() - 1:
			emit_signal("next_page")
			return
		if dialogue.Answers.empty() == true:
			canInteract = true
			return
		if DialogueHandler.dialogue_branching == true:
			return
		emit_signal("text_ended")
		return

	if inv_gui.visible == true:
		return

	canInteract = false
	emit_signal("player_interacted", dialogue)

func _on_InteractionArea_body_entered(body) -> void:
	if not body is  Player:
		return
	player_is_colliding = true

func _on_InteractionArea_body_exited(body) -> void:
	if not body is Player:
		return
	player_is_colliding = false

func _on_DialogueHandler_player_unpause() -> void:
	canInteract = true

func _on_InventoryHandler_item_picked_up():
	pass #eventually call action()

func on_DialogueHandler_player_unpaused():
	canInteract = true

func save_game(game_save : Resource) -> void:
	var answers : Array = dialogue.Answers.keys()
	var item_branch_1 : Item
	var item_branch_2 : Item
	if dialogue.Answers[answers[0]]:
		if dialogue.Answers[answers[0]].item_name != '':
			var branch_1 : Resource = dialogue.Answers[answers[0]]
			item_branch_1 = Item.new(branch_1.item_name, branch_1.item_quantity, branch_1.item_texture, branch_1.item_type)
	if dialogue.Answers[answers[1]]:
		if dialogue.Answers[answers[1]].item_name != '':
			var branch_2 : Resource = dialogue.Answers[answers[1]]
			item_branch_2 = Item.new(branch_2.item_name, branch_2.item_quantity, branch_2.item_texture, branch_2.item_type)
	game_save.data[SAVE_KEY] = {
		'position' : {
			'x' : position.x,
			'y' : position.y
		},
		'dialogue' : {
			'item_name' : dialogue.item_name,
		}
	}
	if item_branch_1:
		game_save.data[SAVE_KEY]['dialogue']['branch_1_item_name'] = dialogue.Answers[answers[0]].item_name
	if item_branch_2:
		game_save.data[SAVE_KEY]['dialogue']['branch_2_item_name'] = dialogue.Answers[answers[1]].item_name

func load_game(game_save : Resource) -> void:
	var answers : Array = dialogue.Answers.keys()
	var data : Dictionary = game_save.data[SAVE_KEY]

	position.x = data['position']['x']
	position.y = data['position']['y']

	dialogue.item_name = data['dialogue']['item_name']
	if data['dialogue'].has('branch_1_item_name'):
		dialogue.Answers[answers[0]].item_name = data['dialogue']['branch_1_item_name']
	if data['dialogue'].has('branch_2_item_name'):
		dialogue.Answers[answers[1]].item_name = data['dialogue']['branch_2_item_name']

#--------------------------------------------------

func action():
	pass #Overwrite this function to add custom behaviour
