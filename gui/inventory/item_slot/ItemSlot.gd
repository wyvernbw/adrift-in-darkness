extends AspectRatioContainer
class_name ItemSlot

signal item_used(item)

onready var button := $Button
onready var name_label := $MarginContainer/HBoxContainer/Name
onready var icon_rect := $MarginContainer/HBoxContainer/Icon
onready var quantity_label := $MarginContainer/HBoxContainer/Quantity

var current_item: Item

func _ready() -> void:
	connect("item_used", InventoryHandler, "_on_item_used")
	grab_focus()


func set_item(item: Item) -> void:
	current_item = item
	name_label.text = item.name
	quantity_label.text = "x %s" % item.quantity
	icon_rect.texture = item.texture


func _on_Button_pressed():
	emit_signal("item_used", current_item)
	print(current_item.name)


func _on_ItemSlot_focus_entered():
	button.grab_focus()
