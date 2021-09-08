extends Control

export var options : Dictionary


func _ready() -> void:
	for key in options:
		var button : Button = Button.new()
		button.text = str(key)
		button.connect("pressed", self, "_on_Button_pressed", [options[key]])
		$VBoxContainer.add_child(button)


func _on_Button_pressed(scene_path : String) -> void:
	get_tree().change_scene(scene_path)
