extends Button

signal item_used(item)

var current_item : Item

func set_item(item : Item) -> void:
	current_item = item
	$Name.text = item.item_name
	$Quantity.text = "x" + str(item.quantity)
	$Icon.texture = item.texture

func _on_ItemSlot_pressed():
	emit_signal("item_used", current_item)
	print(current_item.item_name)
