extends Control

signal inventory_opened
signal inventory_closed

const ITEM_SLOT = preload("res://Scenes/interactable objects/ItemSlot.tscn")

onready var InventoryHandler = $"/root/InventoryHandler"
onready var KeyItemsPanel = $KeyItemPanel
onready var NormalItemsPanel = $NormalItemPanel

func _ready():
	visible = false
	KeyItemsPanel.get_node("GridContainer").add_child(ITEM_SLOT.instance())
	populate_inventory()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") :
		if visible:
			visible = false
			emit_signal("inventory_closed")
		elif not visible:
			visible = true
			emit_signal("inventory_opened")
	if Input.is_action_just_pressed("ui_right") :
		KeyItemsPanel.visible = false
		NormalItemsPanel.visible = true
	if Input.is_action_just_pressed("ui_left") :
		KeyItemsPanel.visible = true
		NormalItemsPanel.visible = false
	

func populate_inventory():
	#populate key items panel
	for i in InventoryHandler.inventory[Item.ITEM_TYPES.KEY_ITEM].size():
		var item_slot = ITEM_SLOT.instance()
		KeyItemsPanel.get_node("GridContainer").add_child(item_slot)
		item_slot.get_node("Icon").texture = InventoryHandler.inventory[Item.ITEM_TYPES.KEY_ITEM][i].texture
		item_slot.get_node("Name").text = InventoryHandler.inventory[Item.ITEM_TYPES.KEY_ITEM][i].item_name
		item_slot.get_node("Quantity").text = str(InventoryHandler.inventory[Item.ITEM_TYPES.KEY_ITEM][i].quantity)
		
		
		