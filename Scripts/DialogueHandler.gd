extends Node

const DIALOGUE_BOX_SCENE = preload("res://Scenes/GUI/DialogueBox.tscn")
var resource : Resource

func _on_Object_player_interacted(res):
	resource = res
	var dialogue_box = DIALOGUE_BOX_SCENE.instance()
	add_child(dialogue_box)
	dialogue_box.get_node("Panel/Label").text = res.Text[0]

func _on_Object_player_exited():
	get_node("DialogueBox").queue_free()

func _on_Object_page_changed(index):
	get_node("DialogueBox").free()
	var dialogue_box = DIALOGUE_BOX_SCENE.instance()
	add_child(dialogue_box)
	dialogue_box.set_name("DialogueBox")
	dialogue_box.get_node("Panel/Label").text = resource.Text[index]
	
