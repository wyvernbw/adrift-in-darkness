extends PanelContainer

onready var label = $MarginContainer/HBoxContainer/Label
onready var icon = $MarginContainer/HBoxContainer/Icon
onready var tab = $MarginContainer/HBoxContainer/tab

var item: Item setget set_item


func set_item(new_item: Item) -> void:
	item = new_item
	label.text += new_item.name
	icon.texture = new_item.texture
	tab.texture = new_item.texture
