extends Node

"""
DIALOGUE HANDLER.
This scripts takes a dialogue as a resource and displays the required dialogue boxes (branching or not) and adds items to the player's inventory.
I've rewritten this script to have all the dialogue playing happen on the DialogueHandler side, instead of requiring input from a StaticObject. This way any object in the game or any script can play dialogue. Also it has way less bugs and the scripts is more minimal. 
"""

signal player_unpause
signal dialogue_finished
signal branch_chosen
signal player_pause
signal resource_changed
signal dialogue_box_removed
signal next_page

const DIALOGUE_BOX_SCENE = preload("res://gui/dialogue_box/DialogueBox.tscn")
const BRANCHING_DIALOGUE_BOX_SCENE = preload("res://gui/branching_dialogue_box/BranchingDialogueBox.tscn")
const READ_BOX_SCENE = preload("res://gui/read_box/ReadBox.tscn")

var dialogue_branch: int = 0
var dialogue_open: bool setget set_dialogue_open
var dialogue_branching: bool = false
var page_index: int = -1
var SAVE_KEY: String = "DialogueHandler"
var dialogue: Resource setget set_dialogue
var text_template: String = "[center] %s [/center]"


func _ready():
	dialogue_open = false


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
	if dialogue.item_held:
		var item = dialogue.item_held.get_item()
		print(item.name)
		InventoryHandler.add_item(item)
		dialogue.expend_item()


func start_dialogue(new_dialogue: DialogueResource) -> void:
	self.dialogue_open = true
	# set the dialogue resource
	set_dialogue(new_dialogue)
	# wait a frame
	yield(get_tree(), "idle_frame")
	# pause the player
	emit_signal("player_pause")
	# run the dialogue
	for line in dialogue.text:	
		add_dialogue_box(line)
		print("dialogue open, waiting for input...")
		yield(self, "next_page")
		remove_dialogue_box()
		print("advanced!")
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
	emit_signal("dialogue_finished")
	self.dialogue_open = false


func add_read_box(paragraph: String) -> void:
	yield(get_tree(), "idle_frame")
	if paragraph:
		var read_box = READ_BOX_SCENE.instance()
		read_box.set_text(paragraph)
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
	add_child(dialogue_box)
	dialogue_box.set_text(text_template % line)



func _on_BranchingDialogueBox_option_pressed(branch: int) -> void:
	var answers = dialogue.answers.values()
	if answers.empty():
		return
	dialogue_branch = branch
	dialogue_branching = false
	start_dialogue(answers[branch])
	emit_signal("branch_chosen")


func set_dialogue_open(value : bool) -> void:
	print("dialogue open -> ", value)
	dialogue_open = value
