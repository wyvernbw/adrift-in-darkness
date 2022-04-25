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
signal next_page

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
var text_template: String = "[center] %s [/center]"


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if not dialogue or not dialogue_open:
			return
		emit_signal("next_page")


func set_dialogue(new_dialogue: DialogueResource) -> void:
	"""
	Sets the dialogue resource, resets the page index and adds the required item to the player's inventory (if applicable)
	"""
	if not new_dialogue:
		print("ERROR: DIALOGUE IS NULL")
		return
	dialogue = new_dialogue
	dialogue_open = true
	emit_signal("player_pause")
	if dialogue.item_name.empty() or not dialogue.item_quantity or not dialogue.item_texture:
		return
	item_held = Item.new(
		dialogue.item_name,
		dialogue.item_quantity,
		dialogue.item_texture,
		dialogue.item_type
	)
	InventoryHandler.add_item(item_held)
	dialogue.expend_item()


func start_dialogue(new_dialogue: DialogueResource) -> void:
	# set the dialogue resource
	set_dialogue(new_dialogue)
	# wait a frame
	yield(get_tree(), "idle_frame")
	# pause the player
	emit_signal("player_pause")
	# run the dialogue
	for line in dialogue.text:	
		add_dialogue_box(line)
		yield(self, "next_page")
		remove_dialogue_box()
	# add a big reading box
	yield(
		add_read_box(dialogue.read_box_text), 
		"completed"
	)
	# add a branching dialogue box
	yield(
		add_branching_box(dialogue.answers),
		"completed"
	)
	# unpause the player
	emit_signal("player_unpause")
	dialogue_open = false


func add_read_box(paragraph: String) -> void:
	yield(get_tree(), "idle_frame")
	if paragraph:
		var read_box = READ_BOX_SCENE.instance()
		read_box.get_node("Text").text = paragraph
		add_child(read_box)
		yield(self, "next_page")
		remove_dialogue_box()


func add_branching_box(options: Dictionary) -> void:			
	yield(get_tree(), "idle_frame")
	if options:
		var branching_box = BRANCHING_DIALOGUE_BOX_SCENE.instance()
		var answer_keys = options.keys()
		dialogue_branching = true
		add_child(branching_box)
		branching_box.draw_box(answer_keys[0], answer_keys[1])
		yield(self, "next_page")
		remove_dialogue_box()


func set_dialogue_only(res: Resource) -> void:
	dialogue = res


func remove_dialogue_box() -> void:
	"""
	Checks if a dialogue box node exists and destroys it.
	"""
	if get_node_or_null("DialogueBox"):
		get_node("DialogueBox").free()
		emit_signal("dialogue_box_removed")
	if get_node_or_null("BranchingDialogueBox"):
		get_node("BranchingDialogueBox").queue_free()
	if get_node_or_null("ReadBox"):
		get_node("ReadBox").free()


func add_dialogue_box(line: String) -> void:
	"""
	Adds a dialogue box with "line" as text. 
	"""
	var dialogue_box = DIALOGUE_BOX_SCENE.instance()
	var label = dialogue_box.get_node("Panel/Label")
	label.bbcode_text = text_template % line
	add_child(dialogue_box)



func _on_BranchingDialogueBox_option_pressed(branch: int) -> void:
	var answers = dialogue.answers.values()
	if answers.empty():
		return
	dialogue_branch = branch
	dialogue_branching = false
	start_dialogue(answers[branch])
