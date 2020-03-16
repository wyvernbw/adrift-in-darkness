extends Node2D

onready var target = get_parent()

var lantern_item : Item = Item.new("lantern", 1, null, Item.ITEM_TYPES.KEY_ITEM)

func _ready() -> void:
	$Light2D/AnimationPlayer.play("flicker")

func _process(delta: float) -> void:
	if InventoryHandler.get_item(lantern_item) != -1:
		if DialogueHandler.get_child_count() == 0:
			$Light2D.visible = true
	else:
		$Light2D.visible = false
	if target.look_dir == Vector2.RIGHT:
		rotation_degrees = -90
	if target.look_dir == Vector2.LEFT:
		rotation_degrees = 90
	if target.look_dir == Vector2.DOWN:
		rotation_degrees = 360
	if target.look_dir == Vector2.UP:
		rotation_degrees = -180
