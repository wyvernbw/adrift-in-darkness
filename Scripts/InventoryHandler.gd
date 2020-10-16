extends Node

signal inventory_changed
signal inventory_item_used

onready var notification = preload("res://Scenes/GUI/notification.tscn")

var loading: bool = false
var inventory: Array
var key_items: Array
var normal_items: Array
var SAVE_KEY: String = "InventoryHandler"


func _ready() -> void:
	inventory.append(key_items)
	inventory.append(normal_items)
	add_to_group("save", true)


func _send_notification(item: Item) -> void:
	var item_notification = notification.instance()
	get_node("../Game/notifications").add_child(item_notification)
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


func save_game(game_save: Resource) -> void:
	game_save.data[SAVE_KEY] = {'inventory': {'key_items': {}, 'normal_items': {}}}
	for i in inventory[Item.ITEM_TYPES.KEY_ITEM].size():
		var itr_item = inventory[Item.ITEM_TYPES.KEY_ITEM][i]
		var item_dict: Dictionary = {
			"item_name": itr_item.item_name,
			"quantity": itr_item.quantity,
			"texture": itr_item.texture,
			"item_type": itr_item.item_type
		}
		game_save.data[SAVE_KEY]['inventory']['key_items'][str(i)] = item_dict
	for i in inventory[Item.ITEM_TYPES.NORMAL_ITEM].size():
		var itr_item = inventory[Item.ITEM_TYPES.NORMAL_ITEM][i]
		var item_dict: Dictionary = {
			'item_name': itr_item.item_name,
			'quantity': itr_item.quantity,
			'texture': itr_item.texture,
			'item_type': itr_item.item_type
		}
		game_save.data[SAVE_KEY]['inventory']['normal_items'][str(i)] = item_dict
	print(game_save.data[SAVE_KEY])


func load_game(game_save: Resource) -> void:
	loading = true

	var data = game_save.data[SAVE_KEY]

	inventory[Item.ITEM_TYPES.KEY_ITEM] = []
	inventory[Item.ITEM_TYPES.NORMAL_ITEM] = []

	for i in data['inventory']['key_items'].size():
		var item_dict = data['inventory']['key_items'][str(i)]
		var comp_item = Item.new(
			item_dict['item_name'],
			item_dict['quantity'],
			item_dict['texture'],
			item_dict['item_type']
		)
		inventory[Item.ITEM_TYPES.KEY_ITEM].append(comp_item)

	for i in data['inventory']['normal_items'].size():
		var item_dict = data['inventory']['normal_items'][str(i)]
		var comp_item = Item.new(
			item_dict['item_name'],
			item_dict['quantity'],
			item_dict['texture'],
			item_dict['item_type']
		)
		inventory[Item.ITEM_TYPES.NORMAL_ITEM].append(comp_item)

	loading = false


func _on_item_used(item) -> void:
	emit_signal("inventory_item_used", item)
