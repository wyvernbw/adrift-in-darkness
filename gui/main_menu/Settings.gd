extends Control

const MAIN_MENU_SCENE: String = "res://gui/main_menu/MainMenu.tscn"

onready var master_volume_slider := $MarginContainer/ScrollContainer/VBoxContainer/Volume/MasterSlider
onready var fullscreen_button := $MarginContainer/ScrollContainer/VBoxContainer/Fullscreen/CheckButton
onready var captions_slider := $MarginContainer/ScrollContainer/VBoxContainer/CaptionsDuration/HBoxContainer/HSlider
onready var captions_button := $MarginContainer/ScrollContainer/VBoxContainer/Captions/CheckButton


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
