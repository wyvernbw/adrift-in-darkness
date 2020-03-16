extends Node

signal inventory_changed

var inventory : Array
var key_items : Array
var normal_items : Array
var SAVE_KEY : String = "InventoryHandler"

func _ready() -> void:
	inventory.append(key_items)
	inventory.append(normal_items)
	add_to_group("save", true)
	
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

func save_game(game_save : Resource) -> void:
	game_save.data[SAVE_KEY] = {
		'inventory' : inventory.duplicate(true)
	}

func load_game(game_save : Resource) -> void:
	inventory = game_save.data[SAVE_KEY]['inventory']
	emit_signal("inventory_changed")
