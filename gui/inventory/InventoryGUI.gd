extends Control

signal inventory_opened
signal inventory_closed

const ITEM_SLOT = preload('res://gui/inventory/item_slot/ItemSlot.tscn')

onready var InventoryHandler = $'/root/InventoryHandler'
onready var KeyItemsPanel = $KeyItemPanel
onready var NormalItemsPanel = $NormalItemPanel
onready var KeyItemsContainer = $KeyItemPanel/GridContainer
onready var NormalItemsContainer = $NormalItemPanel/GridContainer

export var player_path : NodePath

var current_page : int = 0

func _ready() -> void:
	GlobalHandler.InventoryGUI = self
# warning-ignore:return_value_discarded
	$'/root/InventoryHandler'.connect('inventory_changed', self, '_on_InventoryHandler_inventory_changed')
	visible = false
	refresh_inventory()
	
func _process(_delta : float) -> void:
	if visible:
		if DialogueHandler.dialogue_open:
			visible = false
	if Input.is_action_just_pressed('open_inventory') :
		if visible:
			visible = false
			emit_signal('inventory_closed')
		elif DialogueHandler.dialogue_open == false:
			visible = true
			emit_signal('inventory_opened')
			InventoryHandler.emit_signal('inventory_changed')
	if visible:
		if Input.is_action_just_pressed('ui_right') :
			KeyItemsPanel.visible = false
			NormalItemsPanel.visible = true
			current_page = 1
			if NormalItemsContainer.get_children():
				NormalItemsContainer.get_child(0).grab_focus()
		if Input.is_action_just_pressed('ui_left') :
			KeyItemsPanel.visible = true
			NormalItemsPanel.visible = false
			current_page = 0
			if KeyItemsContainer.get_children():
				KeyItemsContainer.get_child(0).grab_focus()

func populate_inventory() -> void:
	for i in InventoryHandler.inventory[Item.ITEM_TYPES.KEY_ITEM].size():
		print('inv populated')
		var item_slot = ITEM_SLOT.instance()
		var current_item = InventoryHandler.inventory[Item.ITEM_TYPES.KEY_ITEM][i]
		
		$KeyItemPanel/GridContainer.call_deferred('add_child', item_slot)
		item_slot.visible = true
		item_slot.set_name(str(current_item['item_name']))
		item_slot.add_to_group('ItemSlot')
		item_slot.set_item(current_item)
	for i in InventoryHandler.inventory[Item.ITEM_TYPES.NORMAL_ITEM].size():
		print('inv populated')		
		var item_slot = ITEM_SLOT.instance()
		var current_item = InventoryHandler.inventory[Item.ITEM_TYPES.NORMAL_ITEM][i]
		
		$NormalItemPanel/GridContainer.call_deferred('add_child', item_slot)
		item_slot.set_name(str(current_item['item_name']))
		item_slot.add_to_group('ItemSlot')
		item_slot.set_item(current_item)

func refresh_inventory() -> void:
	call_deferred('_empty_inventory_panels')
	populate_inventory()
	if current_page == 0:
		if KeyItemsContainer.get_child_count() > 0:
			KeyItemsContainer.get_child(0).call_deferred("grab_focus")
			print(str(KeyItemsContainer.get_child(0)) + "grabbed focus")
	elif NormalItemsContainer.get_child_count() > 0:
		NormalItemsContainer.get_child(0).call_deferred("grab_focus")

func _empty_inventory_panels() -> void:
	if get_tree() == null:
		return
	for object in get_tree().get_nodes_in_group('ItemSlot'):
		object.queue_free()
	
func _on_InventoryHandler_inventory_changed() -> void:
	if InventoryHandler.loading == true:
		return
	refresh_inventory()
