extends Control

signal inventory_opened
signal inventory_closed

const ITEM_SLOT = preload("res://gui/inventory/item_slot/ItemSlot.tscn")

enum PAGES { NORMAL_ITEMS = 0, KEY_ITEMS = 1 }

onready var KeyItemsPanel := $KeyItemPanel
onready var NormalItemsPanel := $NormalItemPanel
onready var KeyItemsContainer := $KeyItemPanel/ScrollContainer/VBoxContainer
onready var NormalItemsContainer := $NormalItemPanel/ScrollContainer/VBoxContainer

export var player_path: NodePath

var current_page: int = PAGES.NORMAL_ITEMS


func _ready() -> void:
	GlobalHandler.InventoryGUI = self
# warning-ignore:return_value_discarded
	$"/root/InventoryHandler".connect(
		"inventory_changed", self, "_on_InventoryHandler_inventory_changed"
	)
	connect("inventory_opened", GlobalHandler.Player, "_on_InventoryGUI_inventory_opened")
	connect("inventory_closed", GlobalHandler.Player, "_on_InventoryGUI_inventory_closed")
	visible = false
	refresh_inventory()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_inventory"):
		if visible:
			visible = false
			emit_signal("inventory_closed")
		elif DialogueHandler.dialogue_open == false:
			visible = true
			emit_signal("inventory_opened")
			change_page(current_page)
	if visible:
		visible = !DialogueHandler.dialogue_open
		var page_change: bool = Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left")
		if page_change:
			change_page(!current_page)
			
	
func change_page(page: int) -> void:
	current_page = page
	refresh_inventory()
	var container: VBoxContainer
	match current_page:
		PAGES.NORMAL_ITEMS:
			KeyItemsPanel.hide()
			NormalItemsPanel.show()
			container = NormalItemsContainer
		PAGES.KEY_ITEMS:
			NormalItemsPanel.hide()
			KeyItemsPanel.show()
			container = KeyItemsContainer
	if container.get_child_count():
		container.get_child(0).grab_focus()


func populate_inventory() -> void:
	var container: VBoxContainer
	match current_page:
		PAGES.NORMAL_ITEMS:
			container = NormalItemsContainer
		PAGES.KEY_ITEMS:
			container = KeyItemsContainer
	for item in InventoryHandler.inventory[int(!current_page)]:
		var item_slot = ITEM_SLOT.instance()
		item_slot.visible = true
		item_slot.set_name(item.item_name)
		item_slot.add_to_group("ItemSlot")
		item_slot.set_item(item)
		container.call_deferred("add_child", item_slot)


func refresh_inventory() -> void:
	call_deferred("_empty_inventory_panels")
	populate_inventory()


func _empty_inventory_panels() -> void:
	if get_tree() == null:
		return
	for object in get_tree().get_nodes_in_group("ItemSlot"):
		object.queue_free()


func _on_InventoryHandler_inventory_changed() -> void:
	if InventoryHandler.loading == true:
		return
	refresh_inventory()
