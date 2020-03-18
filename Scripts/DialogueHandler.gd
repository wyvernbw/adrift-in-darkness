extends Node

signal player_unpause
signal player_pause
signal resource_changed

const DIALOGUE_BOX_SCENE = preload("res://Scenes/GUI/DialogueBox.tscn")
const BRANCHING_DIALOGUE_BOX_SCENE = preload("res://Scenes/GUI/BranchingDialogueBox.tscn")

var dialogue_open : bool = false
var dialogue_branching : bool = false
var page_index : int = 0
var item_held : Item
var SAVE_KEY : String = "DialogueHandler"
var resource : Resource


func _ready() -> void:
	$"/root/DialogueHandler".connect("resource_changed", $"/root/DialogueHandler","_on_DialogueHandler_resource_changed")
	
func _process(delta : float) -> void:
	if resource:
		if page_index > resource.Text.size() - 1: 
			if resource.Answers.empty():
				emit_signal("player_unpause")
		
func start_dialoue(_resource : DialogueResource) -> void:
	resource = _resource
	init_dialogue()

func _on_Object_player_interacted(res : Resource) -> void:
	if not dialogue_branching:
		resource = res
		emit_signal("resource_changed")
		init_dialogue()

func _on_Object_text_ended() -> void:
	var dialogue_box_label = get_node("DialogueBox/Panel/Label")
	if dialogue_box_label.visible_characters == dialogue_box_label.text.length():
		get_node("DialogueBox").queue_free()
	else:
		return
	if resource.Answers.empty():
		emit_signal("player_unpause")
#		print("player unpaused")
		return
	var b_dialogue_box = BRANCHING_DIALOGUE_BOX_SCENE.instance()
	var answer_keys = resource.Answers.keys()
	dialogue_branching = true
	add_child(b_dialogue_box)
	b_dialogue_box.connect("option_pressed", self, "_on_BranchingDialogueBox_option_pressed")
	b_dialogue_box.draw_box(answer_keys[0], answer_keys[1])

func _on_Object_page_changed() -> void:
	page_index += 1
	if resource.Answers.empty() and page_index == resource.Text.size() - 1:
		var dialogue_box_label = get_node("DialogueBox/Panel/Label")
		if dialogue_box_label.visible_characters == dialogue_box_label.text.length():
			get_node("DialogueBox").queue_free()
		else:
			return
		emit_signal("player_unpause")
		return
	update_dialogue()
	
func init_dialogue() -> void:
	dialogue_open = true
	page_index = 0
	var dialogue_box = DIALOGUE_BOX_SCENE.instance()
	add_child(dialogue_box)
	emit_signal("player_pause")
	dialogue_box.get_node("Panel/Label").text = resource.Text[0]

func update_dialogue() -> void:
	if get_children():
		if get_node("DialogueBox"):
			var dialogue_box_label = get_node("DialogueBox/Panel/Label")
			if dialogue_box_label.visible_characters == dialogue_box_label.text.length():
				get_node("DialogueBox").free()
			else:
				return
	if not page_index > resource.Text.size() - 1 :
		var dialogue_box = DIALOGUE_BOX_SCENE.instance()
		add_child(dialogue_box)
		dialogue_box.set_name("DialogueBox")
		dialogue_box.get_node("Panel/Label").text = resource.Text[page_index]

func _on_BranchingDialogueBox_option_pressed(branch : int) -> void:
	get_node("BranchingDialogueBox").queue_free()
	var keys = resource.Answers.keys()
	if branch == 0:
		resource = resource.Answers[keys[0]]
	if branch == 1:
		resource = resource.Answers[keys[1]]
	emit_signal("resource_changed")
	page_index = 0
	dialogue_branching = false
	update_dialogue()

func _on_DialogueHandler_resource_changed() -> void:
	if resource:
		if resource.item_name:
			if resource.item_quantity != -1:
				if resource.item_type != -1:
					item_held = Item.new(
						resource.item_name,
						resource.item_quantity,
						resource.item_texture,
						resource.item_type
					)
					InventoryHandler.add_item(item_held)
					resource.item_name = ''

