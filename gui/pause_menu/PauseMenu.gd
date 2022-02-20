extends Control

enum OPTIONS { RESUME, SETTINGS, QUIT }

const SETTINGS_SCENE: String = "res://gui/main_menu/Settings.tscn" 

var buttons: Array = []

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	self.hide()
	for button in $MarginContainer/VBoxContainer.get_children():
		buttons.push_back(button)
	if not buttons.empty():
		buttons[0].grab_focus()

func _input(event: InputEvent):
	if event.is_action_pressed("pause"):
		visible = not visible
		get_tree().paused = !get_tree().paused
		if visible:
			buttons[0].grab_focus()


func _on_Quit_pressed():
	get_tree().quit()


func _on_Resume_pressed():
	visible = false
	get_tree().paused = false
