extends "res://Scripts/DialogueBox.gd"

onready var option_1 = $Panel/option1
onready var option_2 = $Panel/option1

func _ready():
	option_1.grab_focus()
	draw_box("fuck", "don't fuck")

func draw_box(_option_1 : String, _option_2 : String):
	option_1.get_node("Label").text = _option_1
	option_2.get_node("Label").text = _option_2
