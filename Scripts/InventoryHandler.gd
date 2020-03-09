extends Node
class_name InventoryHandlerClass

signal item_picked_up(item)

var inventory = []
var key_items = []
var normal_items = []

var debug_item = Item.new("poison", 2, preload("res://Sprites/items/bottle-of-poison.png"), Item.ITEM_TYPES.KEY_ITEM)

func _ready():
	inventory.append(key_items)
	inventory.append(normal_items)
	add_item(debug_item)
	add_item(debug_item)
	
func _process(delta):
	print(inventory[Item.ITEM_TYPES.KEY_ITEM][0].quantity)

func add_item(item : Item) -> void:
	if item == null:
		return
	if item.item_type == Item.ITEM_TYPES.KEY_ITEM :
		var item_index = get_item(item)
		if item_index != -1:
			inventory[Item.ITEM_TYPES.KEY_ITEM][item_index].quantity += item.quantity
			return
		else:
			inventory[Item.ITEM_TYPES.KEY_ITEM].append(item)
	elif item.item_tpye == Item.ITEM_TYPES.NORMAL_ITEM:
		var item_index = get_item(item)
		if item_index != -1:
			inventory[Item.ITEM_TYPES.NORMAL_ITEM][item_index].quantity += item.quantity
			return
		else:
			inventory[Item.ITEM_TYPES.NORMAL_ITEM].append(item)

func get_item(item : Item) -> int:
	if item == null:
		return -1
	if item.item_type == Item.ITEM_TYPES.KEY_ITEM:
		for i in inventory[Item.ITEM_TYPES.KEY_ITEM].size():
			if inventory[Item.ITEM_TYPES.KEY_ITEM][i].item_name == item.item_name:
				#print(i)
				return i
	if item.item_type == Item.ITEM_TYPES.NORMAL_ITEM:
		for i in inventory[Item.ITEM_TYPES.NORMAL_ITEM].size():
			if inventory[Item.ITEM_TYPES.NORMAL_ITEM][i].item_name == item.item_name:
				return i
	return -1
	
func _on_Object_player_obtained_item(item):
	add_item(item)