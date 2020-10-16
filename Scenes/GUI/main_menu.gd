tool
extends Control

const BUTTON_COUNT = 1

onready var play_button = $Buttons/Play
onready var quit_button = $Buttons/Quit
var play_button_selected_text = "- Play -"
var quit_button_selected_text = "- Quit -"

var selected_button : int = 0

func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		selected_button = min(selected_button + 1, BUTTON_COUNT)
	if Input.is_action_just_pressed("ui_up"):
		selected_button = max(selected_button - 1, 0)

	play_button.text = "Play"
	quit_button.text = "Quit"

	if selected_button == 0:
		play_button.text = play_button_selected_text 
	if selected_button == 1:
		quit_button.text = quit_button_selected_text 

	if Input.is_action_just_pressed("ui_accept"):
		match selected_button:
			0: 
				get_tree().change_scene("res://Scenes/Game.tscn")
			1: 
				get_tree().quit()
