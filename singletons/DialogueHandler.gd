extends Node

"""
DIALOGUE HANDLER.
This scripts takes a dialogue as a resource and displays the required dialogue boxes (branching or not) and adds items to the player's inventory.
I've rewritten this script to have all the dialogue playing happen on the DialogueHandler side, instead of requiring input from a StaticObject. This way any object in the game or any script can play dialogue. Also it has way less bugs and the scripts is more minimal. 
"""

signal player_unpause
signal player_pause
signal resource_changed
signal dialogue_box_removed

const DIALOGUE_BOX_SCENE = preload("res://gui/dialogue_box/DialogueBox.tscn")
const BRANCHING_DIALOGUE_BOX_SCENE = preload("res://gui/branching_dialogue_box/BranchingDialogueBox.tscn")
const READ_BOX_SCENE = preload("res://gui/read_box/ReadBox.tscn")

var dialogue_branch: int = 0
var dialogue_open: bool = false
var dialogue_branching: bool = false
var page_index: int = -1
var item_held: Item
var SAVE_KEY: String = "DialogueHandler"
var dialogue: Resource setget set_dialogue


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if dialogue == null:
			return
		if dialogue_open == false:
			return
		if dialogue_branching == true:
			return
		if get_node_or_null("ReadBox"):
			remove_dialogue_box()
			return
		page_index += 1
		print("next page [" + str(page_index) + "]")
		remove_dialogue_box()
		add_dialogue_box()


func set_dialogue(new_dialogue: Resource) -> void:
	"""
	Sets the dialogue resource, resets the page index and adds the required item to the player's inventory (if applicable)
	"""

	if new_dialogue == null:
		print("ERROR: DIALOGUE IS NULL")
		return
	print("dialogue set")
	emit_signal("player_pause")
	page_index = -1
	dialogue = new_dialogue
	dialogue_open = true
	if dialogue.item_name == "":
		return
	if not dialogue.item_texture:
		return
	if dialogue.item_quantity == -1:
		return
	item_held = Item.new(
		dialogue.item_name, dialogue.item_quantity, dialogue.item_texture, dialogue.item_type
	)
	InventoryHandler.add_item(item_held)
	dialogue.item_name = ""


func set_dialogue_only(res: Resource) -> void:
	dialogue = res


func remove_dialogue_box() -> void:
	"""
	Checks if a dialogue box node exists and destroys it.
	"""

	if get_node_or_null("DialogueBox"):
		get_node("DialogueBox").free()
		emit_signal("dialogue_box_removed")
	if get_node_or_null("ReadBox"):
		get_node("ReadBox").free()
		emit_signal("player_unpause")


func add_dialogue_box() -> void:
	"""
	Adds a dialogue box at the current page index. It works for regular dialogue boxes as well as branching ones.
	EDIT: Will now add a big reading box if the "read_box_text" parameter of the dialogue resource is not null.
	If the dialogue is over or the resource is empty, unpause the player.
	"""

	print("read text is empty: " + str(dialogue.read_box_text.empty()))
	if page_index < dialogue.Text.size():
		if page_index == -1 and dialogue.read_box_text.empty():
			emit_signal("player_unpause")
			return
		var dialogue_box = DIALOGUE_BOX_SCENE.instance()
		var label = dialogue_box.get_node("Panel/Label")
		label.bbcode_text = dialogue.Text[page_index]
		label.bbcode_text = "[center]" + label.bbcode_text + "[/center]"
		add_child(dialogue_box)
		return

	if not dialogue.read_box_text.empty():
		print("read box now")
		var read_box = READ_BOX_SCENE.instance()
		read_box.get_node("Text").text = dialogue.read_box_text
		add_child(read_box)
		return

	if not dialogue.Answers.empty() == true:
		var b_dialogue_box = BRANCHING_DIALOGUE_BOX_SCENE.instance()
		var answer_keys = dialogue.Answers.keys()

		dialogue_branching = true

		b_dialogue_box.draw_box(answer_keys[0], answer_keys[1])
		add_child(b_dialogue_box)
		return
	emit_signal("player_unpause")
	dialogue_open = false


func _on_BranchingDialogueBox_option_pressed(branch: int) -> void:
	get_node("BranchingDialogueBox").queue_free()
	var keys = dialogue.Answers.keys()
	dialogue_branch = branch
	self.dialogue = dialogue.Answers[keys[branch]]
	dialogue_branching = false
	page_index += 1
	add_dialogue_box()
