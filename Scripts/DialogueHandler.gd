extends Node

signal player_unpause
signal player_pause
signal resource_changed

const DIALOGUE_BOX_SCENE = preload("res://Scenes/GUI/DialogueBox.tscn")
const BRANCHING_DIALOGUE_BOX_SCENE = preload("res://Scenes/GUI/BranchingDialogueBox.tscn")

var dialogue_open: bool = false
var dialogue_branching: bool = false
var page_index: int = -1
var item_held: Item
var SAVE_KEY: String = "DialogueHandler"
var dialogue : Resource setget set_dialogue


func _input(event : InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if dialogue == null:
			return
		if dialogue_open == false:
			return
		if dialogue_branching == true:
			return
		page_index += 1
		print("next page [" + str(page_index) + "]")
		remove_dialogue_box()
		add_dialogue_box()


func set_dialogue(new_dialogue : Resource) -> void:
	print("dialogue set")
	emit_signal("player_pause")
	page_index = -1
	dialogue = new_dialogue 
	dialogue_open = true
	if dialogue.item_name == '':
		return
	if not dialogue.item_texture:
		return
	if dialogue.item_quantity == -1:
		return
	item_held = Item.new(dialogue.item_name, dialogue.item_quantity, dialogue.item_texture, dialogue.item_type)
	InventoryHandler.add_item(item_held)
	dialogue.item_name = ''

func remove_dialogue_box() -> void:
	if get_node_or_null("DialogueBox"):
		get_node("DialogueBox").free()

func add_dialogue_box() -> void:
	if page_index < dialogue.Text.size():
		if page_index == -1:
			return
			emit_signal("player_unpause")
		var dialogue_box = DIALOGUE_BOX_SCENE.instance()
		var label = dialogue_box.get_node("Panel/Label")
		label.bbcode_text = dialogue.Text[page_index]
		label.bbcode_text = "[center]" + label.bbcode_text + "[/center]"
		add_child(dialogue_box)
		return
	if dialogue.Answers.empty() == false:
		var b_dialogue_box = BRANCHING_DIALOGUE_BOX_SCENE.instance()
		var answer_keys = dialogue.Answers.keys()

		dialogue_branching = true

		b_dialogue_box.draw_box(answer_keys[0], answer_keys[1])
		add_child(b_dialogue_box)
		return
	emit_signal("player_unpause")
	dialogue_open = false


func _on_BranchingDialogueBox_option_pressed(branch : int) -> void:
	get_node("BranchingDialogueBox").queue_free()
	var keys = dialogue.Answers.keys()
	self.dialogue = dialogue.Answers[keys[branch]]
	dialogue_branching = false
	page_index += 1
	add_dialogue_box()
