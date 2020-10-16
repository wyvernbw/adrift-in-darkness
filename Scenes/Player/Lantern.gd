extends Node2D

const MAX_FUEL : int = 300

onready var target = get_parent()

var lantern_item: Item = Item.new("Lantern", 1, null, Item.ITEM_TYPES.KEY_ITEM)
var lantern_toggled : bool = false
var fuel_loss_per_second : int = 30 
var fuel : float = 300


func _ready() -> void:
	InventoryHandler.connect("inventory_item_used", self, "_on_item_used") 
	$Light2D/AnimationPlayer.play("flicker")
	$SpotLight/AnimationPlayer.play("flicker")
	$awno.play("awcrap")
	# visible = false


func _process(delta: float) -> void:
	if InventoryHandler.get_item(lantern_item) != -1:
		if DialogueHandler.get_child_count() == 0:
			$Light2D.visible = true
			$SpotLight.visible = true
	else:
		$Light2D.visible = false
		$SpotLight.visible = false
	
	visible = lantern_toggled
	if lantern_toggled:
		fuel -= fuel_loss_per_second * delta
		fuel = max(0.0, fuel)
	if fuel == 0 and visible:
		print("good evening")
		visible = false

	if target.look_dir == Vector2.RIGHT:
		rotation_degrees = -90
	if target.look_dir == Vector2.LEFT:
		rotation_degrees = 90
	if target.look_dir == Vector2.DOWN:
		rotation_degrees = 360
	if target.look_dir == Vector2.UP:
		rotation_degrees = -180


func _on_item_used(item) -> void:
	if not item.item_name == "Lantern":
		return
	print("Lantern used baby!")
	if lantern_toggled:
		lantern_toggled = false
	else:
		lantern_toggled = true

