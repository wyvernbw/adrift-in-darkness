extends PanelContainer

onready var label = $HBoxContainer/Label
onready var icon = $HBoxContainer/Icon
var item: Item setget set_item


func set_item(new_item):
	item = new_item
	label.text += new_item.item_name
	icon.texture = new_item.texture
