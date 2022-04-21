extends Control

const MAIN_MENU_SCENE: String = "res://gui/main_menu/MainMenu.tscn"

export var master_volume_slider_path : NodePath
export var fullscreen_button_path : NodePath
export var captions_slider_path : NodePath
export var captions_button_path : NodePath

onready var master_volume_slider := get_node(master_volume_slider_path)
onready var fullscreen_button := get_node(fullscreen_button_path)
onready var captions_slider := get_node(captions_slider_path)
onready var captions_button := get_node(captions_button_path)


func _ready() -> void:
	master_volume_slider.grab_focus()
	fullscreen_button.pressed = GlobalHandler.fullscreen
	captions_slider.value = GlobalHandler.captions_duration
	captions_button.pressed = GlobalHandler.captions_enabled


func _on_Button_pressed():
	var _error = get_tree().change_scene(GlobalHandler.previous_scene)


func _on_FullscreenCheckButton_toggled(button_pressed: bool) -> void:
	OS.window_fullscreen = button_pressed
	GlobalHandler.fullscreen = button_pressed


func _on_HSlider_value_changed(value: float) -> void:
	GlobalHandler.captions_duration = value


func _on_CaptionsCheckButton_toggled(button_pressed: bool) -> void:
	GlobalHandler.captions_enabled = button_pressed
