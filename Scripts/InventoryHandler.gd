extends Node

var inventory = []
var key_items = []
var normal_items = []

var debug_item = Item.new("hi im an item", 2, null, Item.ITEM_TYPES.KEY_ITEM)

func _ready():
	inventory.append(key_items)
	inventory.append(normal_items)
	add_item(debug_item)
	print(get_item(debug_item).item_name)

func add_item(item : Item) -> void:
	if item == null:
		return
	if item.item_type == Item.ITEM_TYPES.KEY_ITEM :
		inventory[Item.ITEM_TYPES.KEY_ITEM].append(item)
	elif item.item_tpye == Item.ITEM_TYPES.NORMAL_ITEM:
		inventory[Item.ITEM_TYPES.NORMAL_ITEM].append(item)

func get_item(item : Item):
#	if item == null:
#		return
	if item.item_type == Item.ITEM_TYPES.KEY_ITEM:
		for i in inventory[Item.ITEM_TYPES.KEY_ITEM].size():
			if inventory[Item.ITEM_TYPES.KEY_ITEM][i].item_name == item.item_name:
				print(i)
				return inventory[Item.ITEM_TYPES.KEY_ITEM][i]
	if item.item_type == Item.ITEM_TYPES.NORMAL_ITEM:
		for i in inventory[Item.ITEM_TYPES.NORMAL_ITEM].size():
			if inventory[Item.ITEM_TYPES.NORMAL_ITEM][i].item_name == item.item_name:
				return inventory[Item.ITEM_TYPES.NORMAL_ITEM][i]
	
	