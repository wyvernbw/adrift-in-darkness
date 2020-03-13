extends Node

signal player_unpause
signal player_pause
signal resource_changed

const DIALOGUE_BOX_SCENE = preload("res://Scenes/GUI/DialogueBox.tscn")
const BRANCHING_DIALOGUE_BOX_SCENE = preload("res://Scenes/GUI/BranchingDialogueBox.tscn")

var resource : Resource
var page_index = 0
var dialogue_branching = false
var item_held
var dialogue_open = false

func _ready():
	$"/root/DialogueHandler".connect("resource_changed", $"/root/DialogueHandler","_on_DialogueHandler_resource_changed")

func _process(delta):
	if resource:
		if page_index > resource.Text.size() - 1: 
			if resource.Answers.empty():
				emit_signal("player_unpause")
		
func start_dialoue(_resource : DialogueResource) -> void:
	resource = _resource
	init_dialogue()

func _on_Object_player_interacted(res):
	if not dialogue_branching:
		resource = res
		emit_signal("resource_changed")
		init_dialogue()

func _on_Object_text_ended():
	get_node("DialogueBox").queue_free()
	if resource.Answers.empty():
		emit_signal("player_unpause")
		dialogue_open = false
#		print("player unpaused")
		return
	var b_dialogue_box = BRANCHING_DIALOGUE_BOX_SCENE.instance()
	var answer_keys = resource.Answers.keys()
	dialogue_branching = true
	add_child(b_dialogue_box)
	b_dialogue_box.connect("option_pressed", self, "_on_BranchingDialogueBox_option_pressed")
	b_dialogue_box.draw_box(answer_keys[0], answer_keys[1])

func _on_Object_page_changed():
	page_index += 1
	update_dialogue()
	
func init_dialogue():
	dialogue_open = true
	page_index = 0
	var dialogue_box = DIALOGUE_BOX_SCENE.instance()
	add_child(dialogue_box)
	emit_signal("player_pause")
	dialogue_box.get_node("Panel/Label").text = resource.Text[0]

func update_dialogue():
	if get_children():
		if get_node("DialogueBox"):
			get_node("DialogueBox").free()
	if not page_index > resource.Text.size() - 1 :
		var dialogue_box = DIALOGUE_BOX_SCENE.instance()
		add_child(dialogue_box)
		dialogue_box.set_name("DialogueBox")
		dialogue_box.get_node("Panel/Label").text = resource.Text[page_index]

func _on_BranchingDialogueBox_option_pressed(branch):
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

func _on_DialogueHandler_resource_changed():
	if resource.item_name:
		if resource.item_quantity:
			if resource.item_texture:
				if resource.item_type != -1:
					item_held = Item.new(
						resource.item_name,
						resource.item_quantity,
						resource.item_texture,
						resource.item_type
					)
					InventoryHandler.add_item(item_held)
					InventoryHandler.inventory[item_held.item_type][InventoryHandler.get_item(item_held)].quantity -= item_held.quantity
					resource.item_name = null
	
