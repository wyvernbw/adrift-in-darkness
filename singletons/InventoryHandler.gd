extends Node

signal inventory_changed
signal inventory_item_used

onready var notification = preload("res://gui/notification/notification.tscn")

var loading: bool = false
var inventory: Array
var key_items: Array
var normal_items: Array
var save_key: String = "inventory"


func _ready() -> void:
	inventory.append(key_items)
	inventory.append(normal_items)
	add_to_group("persist")


func _send_notification(item: Item) -> void:
	var item_notification = notification.instance()
	get_node("../Game/Notifications").add_child(item_notification)
	item_notification.item = item


func add_item(item: Item) -> void:
	print(str(item['item_name']) + " : " + str(item.quantity))
	if item == null:
		return
	var item_index = get_item(item)
	if item_index != -1:
		inventory[item.item_type][item_index].quantity += item.quantity
		emit_signal("inventory_changed")
		_send_notification(item)
		return
	else:
		inventory[item.item_type].append(item)
		_send_notification(item)
	emit_signal("inventory_changed")


func get_item(item: Item) -> int:
	if item == null:
		return -1
	for i in inventory[item.item_type].size():
		if inventory[item.item_type][i]['item_name'] == item['item_name']:
			#print(i)
			return i
	return -1


func subtract_item(item: Item, amount: int) -> void:
	var item_index = get_item(item)
	if item_index == -1:
		return
	inventory[item.item_type][item_index].quantity -= amount
	if inventory[item.item_type][item_index].quantity <= 0:
		inventory.erase(item)
	emit_signal("inventory_changed")


func _on_item_used(item) -> void:
	emit_signal("inventory_item_used", item)


func save() -> Dictionary:
	var save_dict: Dictionary
	save_dict["inventory"] = inventory.duplicate()
	save_dict["key_items"] = key_items.duplicate()
	save_dict["normal_items"] = normal_items.duplicate()
	return save_dict


func load(save : Dictionary) -> void:
	inventory.clear()
	inventory = save["inventory"].duplicate()
	key_items.clear()
	key_items = save["key_items"].duplicate()
	normal_items.clear()
	normal_items = save["normal_items"].duplicate()
	emit_signal("inventory_changed")
