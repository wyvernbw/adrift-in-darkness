extends Node2D

const MAX_FUEL: int = 9000

onready var target = get_parent()
onready var static_effect = $Static/StaticAnim
onready var rotate_tween: Tween = $Rotate

export var ran_out_of_fuel_resource: Resource
var lantern_item: Item = Item.new("Lantern", 1, null, Item.ITEM_TYPES.KEY_ITEM)
var lantern_toggled: bool = false
var fuel_loss_per_second: int = 30
var fuel: float = MAX_FUEL
var light_loss_per_second: float = 0.025
var static_per_second: float = 0.025
var max_static: float = 0.5
var save_key: String = "lantern"
var last_dir: Vector2 = Vector2.DOWN
var last_rotation: float = 0.0


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
	else:
		GlobalHandler.lantern_fuel = MAX_FUEL


func _process(delta: float) -> void:
	fuel = GlobalHandler.lantern_fuel
	lantern_toggled = GlobalHandler.lantern_toggled
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
		$awno.stop()
		GlobalHandler.lantern_ran_out = true
		visible = false
		if not GlobalHandler.lantern_ran_out:
			if not DialogueHandler.get_child_count() > 0:
				DialogueHandler.dialogue = ran_out_of_fuel_resource
				DialogueHandler.page_index = 0
				DialogueHandler.add_dialogue_box()

	# darken things up
	if visible == false:
		GlobalHandler.current_light -= light_loss_per_second * delta
		GlobalHandler.current_light = max(
			GlobalHandler.current_light, GlobalHandler.min_global_light
		)
	else:
		GlobalHandler.current_light = GlobalHandler.global_light
		GlobalHandler.current_static = 0.0

	if GlobalHandler.do_static_effect:
		# Satan is that you?
		if GlobalHandler.global_light < 0.06:
			GlobalHandler.current_static += static_per_second * delta
			GlobalHandler.current_static = min(GlobalHandler.current_static, max_static)
		static_effect.modulate = Color(1.0, 1.0, 1.0, GlobalHandler.current_static)

	GlobalHandler.lantern_fuel = fuel
	GlobalHandler.lantern_toggled = self.lantern_toggled


func _on_item_used(item) -> void:
	if item.item_name == "Lantern":
		if lantern_toggled:
			lantern_toggled = false
		else:
			lantern_toggled = true
		GlobalHandler.lantern_toggled = self.lantern_toggled
	elif item.item_name == "Oil":
		fuel = MAX_FUEL
		GlobalHandler.lantern_ran_out = false
		$awno.play("awcrap")

func _on_player_look_dir_changed(dir: Vector2) -> void:
	rotate_tween.seek(1)
	rotate_tween.stop_all()
	var rotate := atan2(dir.y, dir.x) - atan2(1, 0)
	rotate_tween.interpolate_property(
		self, 
		"rotation", 
		rotation, rotate,
		1.0,
		Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	last_rotation = rotation
	rotate_tween.start()
	#rotation_degrees = target_rotation
	last_dir = dir
	

func save() -> Dictionary:
	var save_dict: Dictionary
	save_dict["lantern_toggled"] = lantern_toggled
	save_dict["fuel"] = fuel
	return save_dict


func load(save: Dictionary) -> void:
	GlobalHandler.lantern_toggled = save["lantern_toggled"]
	lantern_toggled = save["lantern_toggled"]
	visible = lantern_toggled
	fuel = save["fuel"]

