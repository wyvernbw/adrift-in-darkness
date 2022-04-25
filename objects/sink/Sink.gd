extends StaticObject

onready var sprite: AnimatedSprite = $AnimatedSprite
onready var red_screen: Polygon2D = $CanvasLayer/Polygon2D
var arm_message: Resource = preload("res://objects/sink/Arm_severd.tres")
var key_found: Resource = preload("res://objects/sink/Basement_key.tres")
var event_finished: bool = false


func _ready() -> void:
	sprite.playing = false
	sprite.frame = 1
	DialogueHandler.connect("player_unpause", self, "on_DialogueHandler_player_unpause")
	add_to_group("save")


func on_DialogueHandler_player_unpause() -> void:
	if event_finished:
		return
	#if $AnimatedSprite.animation == "flood":
	#	self.dialogue = key_found
	if not HpHandler.current_limbs["left_arm"]:
		if DialogueHandler.dialogue == arm_message:
			$AnimatedSprite.play("flood")
			DialogueHandler.emit_signal("player_pause")
			return
		if dialogue == key_found:
			dialogue = null
			return
	if DialogueHandler.dialogue_branch == 1:
		print("arm gone!!")
		#GlobalHandler.left_arm = false
		HpHandler.cut_limb("left_arm")
		red_screen.visible = true
		red_screen.get_node("AnimationPlayer").play("fade")
		DialogueHandler.emit_signal("player_pause")
		GlobalHandler.Player.position.y += 16


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade":
		DialogueHandler.start_dialogue(arm_message)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "flood":
		$AnimatedSprite.play("aftermath")
		self.dialogue = key_found
		event_finished = true
		DialogueHandler.emit_signal("player_unpause")
