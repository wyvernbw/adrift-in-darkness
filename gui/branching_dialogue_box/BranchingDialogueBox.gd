extends CanvasLayer
class_name BranchingBox

signal option_pressed(branch)

var active: bool = false

onready var _option_1 := $PanelContainer/MarginContainer/HBoxContainer/Option1
onready var _option_2 := $PanelContainer/MarginContainer/HBoxContainer/Option2

func _ready():
	_option_1.grab_focus()
# warning-ignore:return_value_discarded
	connect("option_pressed", DialogueHandler, "_on_BranchingDialogueBox_option_pressed")
	connect("option_pressed", HpHandler, "_on_BranchingDialogueBox_option_pressed")


func draw_box(option_1_text: String, option_2_text: String):
	_option_1.get_node("Label").text = option_1_text
	_option_2.get_node("Label").text = option_2_text


func _on_option1_pressed():
	if not active:
		return
	emit_signal("option_pressed", 0)


func _on_option2_pressed():
	if not active:
		return
	emit_signal("option_pressed", 1)


func _on_inactive_timeout():
	active = true
