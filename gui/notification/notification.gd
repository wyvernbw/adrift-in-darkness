extends PanelContainer

onready var label = $Label 
onready var icon  = $Icon 
var item : Item setget set_item

func set_item(new_item):
	item = new_item
	label.text += new_item.item_name
	icon.texture = new_item.texture


