extends Node2D

const MAX_FUEL : int = 300

onready var target = get_parent()
onready var static_effect = $Static/StaticAnim

var lantern_item: Item = Item.new("Lantern", 1, null, Item.ITEM_TYPES.KEY_ITEM)
var lantern_toggled : bool = false
var fuel_loss_per_second : int = 30 
var fuel : float = 300
var light_loss_per_second : float = 0.025
var static_per_second : float = 0.0025
var max_static : float = 0.5


func _ready() -> void:
	InventoryHandler.connect("inventory_item_used", self, "_on_item_used") 
	$Light2D/AnimationPlayer.play("flicker")
	$SpotLight/AnimationPlayer.play("flicker")
	$awno.play("awcrap")
	$Static/AnimationPlayer.play("static")
	# visible = false


func _process(delta: float) -> void:
	print(GlobalHandler.globalLight)
	if InventoryHandler.get_item(lantern_item) != -1:
		if DialogueHandler.get_child_count() == 0:
			$Light2D.visible = true
			$SpotLight.visible = true
	else:
		$Light2D.visible = false
		$SpotLight.visible = false
	
	visible = lantern_toggled

	# use up some fuel.
	if lantern_toggled:
		fuel -= fuel_loss_per_second * delta
		fuel = max(0.0, fuel)

	# ran out of fuel.
	if fuel == 0 and visible:
		print("good evening")
		visible = false

	# darken things up
	if visible == false:
		GlobalHandler.globalLight -= light_loss_per_second * delta
		GlobalHandler.globalLight = max(GlobalHandler.globalLight, GlobalHandler.min_global_light)
	else:
		GlobalHandler.globalLight = 0.2
		GlobalHandler.current_static = 0.0

	if GlobalHandler.do_static_effect:
		# Satan is that you?
		if GlobalHandler.globalLight < 0.06:
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
		print("Lantern used baby!")
		if lantern_toggled:
			lantern_toggled = false
		else:
			lantern_toggled = true
	elif item.item_name == "Oil":
		fuel = MAX_FUEL
