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
	for type in Item.ITEM_TYPES:
		var container: VBoxContainer
		match Item.ITEM_TYPES[type]:
			Item.ITEM_TYPES.KEY_ITEM:
				container = $KeyItemPanel/GridContainer
			Item.ITEM_TYPES.NORMAL_ITEM:
				container = $NormalItemPanel/GridContainer
		for item in InventoryHandler.inventory[Item.ITEM_TYPES[type]]:
			var item_slot = ITEM_SLOT.instance()
			item_slot.visible = true
			item_slot.set_name(item.item_name)
			item_slot.add_to_group('ItemSlot')
			item_slot.set_item(item)
			$KeyItemPanel/GridContainer.call_deferred('add_child', item_slot)

func refresh_inventory() -> void:
	call_deferred('_empty_inventory_panels')
	populate_inventory()
	var current_container: VBoxContainer
	match current_page:
		0:
			current_container = KeyItemsContainer
		1: 
			current_container = NormalItemsContainer
	if current_container.get_child_count() > 0:
		current_container.get_child(0).call_deferred("grab_focus")
		print(str(current_container.get_child(0)) + "grabbed focus")

func _empty_inventory_panels() -> void:
	if get_tree() == null:
		return
	for object in get_tree().get_nodes_in_group('ItemSlot'):
		object.queue_free()
	
func _on_InventoryHandler_inventory_changed() -> void:
	if InventoryHandler.loading == true:
		return
	refresh_inventory()
