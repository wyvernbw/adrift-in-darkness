extends Node
class_name InventoryHandlerClass

signal inventory_changed

var inventory = []
var key_items = []
var normal_items = []

var debug_item = Item.new("poison", 1, preload("res://Sprites/items/bottle-of-poison.png"), Item.ITEM_TYPES.KEY_ITEM)

func _ready():
	inventory.append(key_items)
	inventory.append(normal_items)
	
func add_item(item : Item) -> void:
	print(str(item.item_name) + " : " + str(item.quantity))
	if item == null:
		return
	var item_index = get_item(item)
	if item_index != -1:
		inventory[item.item_type][item_index].quantity += item.quantity
		emit_signal("inventory_changed")
		return
	else:
		inventory[item.item_type].append(item)
	emit_signal("inventory_changed")

func get_item(item : Item) -> int:
	if item == null:
		return -1
	for i in inventory[item.item_type].size():
		if inventory[item.item_type][i].item_name == item.item_name:
			#print(i)
			return i
	return -1
	
func subtract_item(item : Item, amount : int) -> void:
	var item_index = get_item(item)
	if item_index == -1:
		return
	inventory[item.item_type][item_index].quantity -= amount
	if inventory[item.item_type][item_index].quantity <= 0:
		inventory.erase(item)
	emit_signal("inventory_changed")

func _on_Object_player_obtained_item(item):
	add_item(item)
	
