extends Node

signal player_unpause
signal player_pause

const DIALOGUE_BOX_SCENE = preload("res://Scenes/GUI/DialogueBox.tscn")
const BRANCHING_DIALOGUE_BOX_SCENE = preload("res://Scenes/GUI/BranchingDialogueBox.tscn")
var resource : Resource
var page_index
var dialogue_branching = false

func _process(delta):
	_update_branch_logic()
	
func _update_branch_logic():
	var input = Input.is_action_just_pressed("ui_accept")
	if dialogue_branching and input:
		get_node("BranchingDialogueBox").free()
		emit_signal("player_unpause")

func _on_Object_player_interacted(res):
	if not dialogue_branching:
		resource = res
		init_dialogue()

func _on_Object_text_ended():
	get_node("DialogueBox").queue_free()
	if resource.Answers.empty():
		emit_signal("player_unpause")
#		print("player unpaused")
		return
	var b_dialogue_box = BRANCHING_DIALOGUE_BOX_SCENE.instance()
	var answer_keys = resource.Answers.keys()
	dialogue_branching = true
	add_child(b_dialogue_box)
	b_dialogue_box.draw_box(answer_keys[0], answer_keys[1])

func _on_Object_page_changed(index):
	page_index = index
	update_dialogue()
	
func init_dialogue():
	var dialogue_box = DIALOGUE_BOX_SCENE.instance()
	add_child(dialogue_box)
	emit_signal("player_pause")
	dialogue_box.get_node("Panel/Label").text = resource.Text[0]

func update_dialogue():
	get_node("DialogueBox").free()
	var dialogue_box = DIALOGUE_BOX_SCENE.instance()
	add_child(dialogue_box)
	dialogue_box.set_name("DialogueBox")
	dialogue_box.get_node("Panel/Label").text = resource.Text[page_index]
