extends Node2D

const MAX_FUEL : int = 9000

onready var target = get_parent()
onready var static_effect = $Static/StaticAnim

export var ran_out_of_fuel_resource : Resource
var lantern_item: Item = Item.new("Lantern", 1, null, Item.ITEM_TYPES.KEY_ITEM)
var lantern_toggled : bool = false
var fuel_loss_per_second : int = 30 
var fuel : float = MAX_FUEL
var light_loss_per_second : float = 0.025
var static_per_second : float = 0.025
var max_static : float = 0.5
var save_key: String = "lantern"


func _ready() -> void:
	add_to_group("persist")
	InventoryHandler.connect("inventory_item_used", self, "_on_item_used") 
	$Light/AnimationPlayer.play("flicker")
	$Spotlight/AnimationPlayer.play("flicker")
	$awno.play("awcrap")
	$Static/AnimationPlayer.play("static")
	self.lantern_toggled = GlobalHandler.lantern_toggled
	# visible = false
	if GlobalHandler.lantern_fuel != -1:
		fuel = GlobalHandler.lantern_fuel


func _process(delta: float) -> void:
	GlobalHandler.lantern_fuel = fuel
	GlobalHandler.lantern_toggled = self.lantern_toggled
	if InventoryHandler.get_item(lantern_item) == -1:
		visible = false
		lantern_toggled = false
	
	if not fuel == 0:
		visible = lantern_toggled

	# use up some fuel.
	if lantern_toggled:
		fuel -= fuel_loss_per_second * delta
		fuel = max(0.0, fuel)

	# ran out of fuel.
	if fuel == 0 and visible:
		visible = false
		if DialogueHandler.get_child_count() > 0:
			return
		DialogueHandler.dialogue = ran_out_of_fuel_resource
		DialogueHandler.page_index = 0
		DialogueHandler.add_dialogue_box()

	# darken things up
	if visible == false:
		GlobalHandler.current_light -= light_loss_per_second * delta
		GlobalHandler.current_light = max(GlobalHandler.current_light, GlobalHandler.min_global_light)
	else:
		GlobalHandler.current_light = GlobalHandler.global_light
		GlobalHandler.current_static = 0.0

	if GlobalHandler.do_static_effect:
		# Satan is that you?
		if GlobalHandler.global_light < 0.06:
			GlobalHandler.current_static += static_per_second * delta
			GlobalHandler.current_static = min(GlobalHandler.current_static, max_static)
		static_effect.modulate = Color(1.0, 1.0, 1.0, GlobalHandler.current_static) 

	if target.look_dir == Vector2.RIGHT:
		rotation_degrees = -90
	if target.look_dir == Vector2.LEFT:
		rotation_degrees = 90
	if target.look_dir == Vector2.DOWN:
		rotation_degrees = 360
	if target.look_dir == Vector2.UP:
		rotation_degrees = -180


func _on_item_used(item) -> void:
	if item.item_name == "Lantern":
		if lantern_toggled:
			lantern_toggled = false
		else:
			lantern_toggled = true
	elif item.item_name == "Oil":
		fuel = MAX_FUEL


func save() -> Dictionary:
	var save_dict: Dictionary
	save_dict["lantern_toggled"] = lantern_toggled
	save_dict["fuel"] = fuel
	return save_dict


func load(save : Dictionary) -> void:
	GlobalHandler.lantern_toggled = save["lantern_toggled"]
	lantern_toggled = save["lantern_toggled"]
	visible = lantern_toggled
	fuel = save["fuel"]
