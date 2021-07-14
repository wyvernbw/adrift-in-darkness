extends StaticObject

onready var sprite : AnimatedSprite = $AnimatedSprite
onready var red_screen : Polygon2D = $CanvasLayer/Polygon2D
var arm_message : Resource = preload("res://objects/sink/Arm_severd.tres")

func _ready() -> void:
	sprite.playing = false
	sprite.frame = 1
	DialogueHandler.connect("player_unpause", self, "on_DialogueHandler_player_unpause")


func on_DialogueHandler_player_unpause() -> void:
	if GlobalHandler.left_arm == false:
		if DialogueHandler.dialogue == arm_message:
			$AnimatedSprite.play("flood")
			return
	if DialogueHandler.dialogue_branch == 1:
		print("arm gone!!")
		GlobalHandler.left_arm = false
		red_screen.visible = true
		red_screen.get_node("AnimationPlayer").play("fade")
		DialogueHandler.emit_signal("player_paused")
		player_node.position.y += 16


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade":
		print("phase 2")
		DialogueHandler.set_dialogue(arm_message)
		DialogueHandler.page_index = 0
		DialogueHandler.add_dialogue_box()


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "flood" :
		$AnimatedSprite.play("aftermath")
