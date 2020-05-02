extends Control

signal inventory_opened
signal inventory_closed

const ITEM_SLOT = preload("res://Scenes/GUI/ItemSlot.tscn")

onready var InventoryHandler = $"/root/InventoryHandler"
onready var KeyItemsPanel = $KeyItemPanel
onready var NormalItemsPanel = $NormalItemPanel
onready var KeyItemsContainer = $KeyItemPanel/GridContainer
onready var NormalItemsContainer = $NormalItemPanel/GridContainer

func _ready() -> void:
	$"/root/InventoryHandler".connect("inventory_changed", self, "_on_InventoryHandler_inventory_changed")
	visible = false
	refresh_inventory()
	
func _process(delta : float) -> void:
	if visible:
		if DialogueHandler.dialogue_open:
			visible = false
		if Input.is_action_just_pressed("ui_up"):
			$Select.play()
		if Input.is_action_just_pressed("ui_down"):
			$Select.play()
	if Input.is_action_just_pressed("ui_cancel") :
		if visible:
			visible = false
			emit_signal("inventory_closed")
		elif not visible and DialogueHandler.dialogue_open == false:
			visible = true
			if KeyItemsContainer.visible:
				if KeyItemsContainer.get_children():
					KeyItemsContainer.get_child(0).grab_focus()
			else:
				if NormalItemsContainer.get_children():
					NormalItemsContainer.get_child(0).grab_focus()
			emit_signal("inventory_opened")
			InventoryHandler.emit_signal("inventory_changed")
	if visible:
		if Input.is_action_just_pressed("ui_right") :
			KeyItemsPanel.visible = false
			NormalItemsPanel.visible = true
			if NormalItemsContainer.get_children():
				NormalItemsContainer.get_child(0).grab_focus()
		if Input.is_action_just_pressed("ui_left") :
			KeyItemsPanel.visible = true
			NormalItemsPanel.visible = false
			if KeyItemsContainer.get_children():
				KeyItemsContainer.get_child(0).grab_focus()

func populate_inventory() -> void:
	for i in InventoryHandler.inventory[Item.ITEM_TYPES.KEY_ITEM].size():
		var item_slot = ITEM_SLOT.instance()
		var current_item = InventoryHandler.inventory[Item.ITEM_TYPES.KEY_ITEM][i]
		
		$KeyItemPanel/GridContainer.add_child(item_slot)
		item_slot.set_name(str(current_item['item_name']))
		item_slot.add_to_group("ItemSlot")
		item_slot.set_item(current_item)
	for i in InventoryHandler.inventory[Item.ITEM_TYPES.NORMAL_ITEM].size():
		var item_slot = ITEM_SLOT.instance()
		var current_item = InventoryHandler.inventory[Item.ITEM_TYPES.NORMAL_ITEM][i]
		
		$NormalItemPanel/GridContainer.add_child(item_slot)
		item_slot.set_name(str(current_item['item_name']))
		item_slot.add_to_group("ItemSlot")
		item_slot.set_item(current_item)

func refresh_inventory() -> void:
	call_deferred("_empty_inventory_panels")
	populate_inventory()

func _empty_inventory_panels() -> void:
		if get_tree() != null:
			for object in get_tree().get_nodes_in_group("ItemSlot"):
				object.queue_free()
	
func _on_InventoryHandler_inventory_changed() -> void:
	if InventoryHandler.loading == false:
		refresh_inventory()
	pass
