extends "res://Scripts/DialogueBox.gd"

signal option_pressed(branch)

func _ready():
	$Panel/option1.grab_focus()

func draw_box(_option_1 : String, _option_2 : String):
	$Panel/option1/Option1Label.text = _option_1
	$Panel/option2/Option2Label.text = _option_2

func _on_option1_pressed():
	emit_signal("option_pressed", 0)

func _on_option2_pressed():
	emit_signal("option_pressed", 1)
