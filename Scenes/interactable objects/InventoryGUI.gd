extends Control

signal inventory_opened
signal inventory_closed

const ITEM_SLOT = preload("res://Scenes/GUI/ItemSlot.tscn")

onready var InventoryHandler = $"/root/InventoryHandler"
onready var KeyItemsPanel = $KeyItemPanel
onready var NormalItemsPanel = $NormalItemPanel

func _ready():
	visible = false
	
func _process(delta):
	refresh_inventory()
	if Input.is_action_just_pressed("ui_cancel") :
		if visible:
			visible = false
			emit_signal("inventory_closed")
		elif not visible:
			visible = true
			emit_signal("inventory_opened")
	if visible:
		if Input.is_action_just_pressed("ui_right") :
			KeyItemsPanel.visible = false
			NormalItemsPanel.visible = true
		if Input.is_action_just_pressed("ui_left") :
			KeyItemsPanel.visible = true
			NormalItemsPanel.visible = false

func populate_inventory():
	for i in InventoryHandler.inventory[Item.ITEM_TYPES.KEY_ITEM].size():
		var item_slot = ITEM_SLOT.instance()
		$KeyItemPanel/GridContainer.add_child(item_slot)
		item_slot.set_name(str(InventoryHandler.inventory[Item.ITEM_TYPES.KEY_ITEM][i].item_name))
		item_slot.add_to_group("ItemSlot")
		item_slot.get_node("Name").text = InventoryHandler.inventory[Item.ITEM_TYPES.KEY_ITEM][i].item_name
		item_slot.get_node("Quantity").text = str(InventoryHandler.inventory[Item.ITEM_TYPES.KEY_ITEM][i].quantity)
		item_slot.get_node("Icon").texture = InventoryHandler.inventory[Item.ITEM_TYPES.KEY_ITEM][i].texture
	for i in InventoryHandler.inventory[Item.ITEM_TYPES.NORMAL_ITEM].size():
		var item_slot = ITEM_SLOT.instance()
		$NormalItemPanel/GridContainer.add_child(item_slot)
		item_slot.set_name(str(InventoryHandler.inventory[Item.ITEM_TYPES.NORMAL_ITEM][i].item_name))
		item_slot.add_to_group("ItemSlot")
		item_slot.get_node("Name").text = InventoryHandler.inventory[Item.ITEM_TYPES.NORMAL_ITEM][i].item_name
		item_slot.get_node("Quantity").text = str(InventoryHandler.inventory[Item.ITEM_TYPES.NORMAL_ITEM][i].quantity)
		item_slot.get_node("Icon").texture = InventoryHandler.inventory[Item.ITEM_TYPES.NORMAL_ITEM][i].texture

func refresh_inventory():
	_empty_inventory_panels()
	populate_inventory()

func _empty_inventory_panels():
	for object in get_tree().get_nodes_in_group("ItemSlot"):
		object.queue_free()
	
func _on_InventoryHandler_inventory_changed():
	refresh_inventory()
