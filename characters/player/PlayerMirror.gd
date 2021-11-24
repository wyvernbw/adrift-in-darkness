extends KinematicBody2D


export var offset := Vector2.ZERO


func _process(_delta: float) -> void:
	var velocity: Vector2
	if not GlobalHandler.Player.is_on_wall():
		velocity.x = GlobalHandler.Player.velocity.x
	if not GlobalHandler.Player.is_on_ceiling():
		if not GlobalHandler.Player.is_on_floor():
			velocity.y = -GlobalHandler.Player.velocity.y

	var player_anim: String = GlobalHandler.Player.get_node("AnimatedSprite").animation
	var anim_properties: Array = player_anim.split("_")

	if anim_properties[1] == "up":
		anim_properties[1] = "down"
	elif anim_properties[1] == "down":
		anim_properties[1] = "up"

	var anim: String
	for property in anim_properties:
		anim += property
		if property != anim_properties.back():
			anim += "_"

	$AnimatedSprite.play(anim)
	move_and_slide(velocity, Vector2.UP)
