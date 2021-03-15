extends "res://gui/dialogue_box/DialogueBox.gd"

signal option_pressed(branch)

var active : bool = false

func _ready():
	$Panel/option1.grab_focus()
# warning-ignore:return_value_discarded
	connect("option_pressed", DialogueHandler, "_on_BranchingDialogueBox_option_pressed")

func draw_box(_option_1 : String, _option_2 : String):
	$Panel/option1/Option1Label.text = _option_1
	$Panel/option2/Option2Label.text = _option_2

func _on_option1_pressed():
	if not active:
		return
	emit_signal("option_pressed", 0)
	print("test0")

func _on_option2_pressed():
	if not active:
		return
	emit_signal("option_pressed", 1)


func _on_inactive_timeout():
	active = true
