extends StaticObject
class_name Sink

"""
EVENT ORDER: 
player interact -> sink dialogue -> reach pressed -> reach dialogue 
	-> red screen -> arm dialogue
player interact -> key obtained dialogue
player interact -> sink dialogue
"""

onready var sprite: AnimatedSprite = $AnimatedSprite
onready var red_screen: Polygon2D = $CanvasLayer/Polygon2D
onready var red_screen_anim := $CanvasLayer/Polygon2D/AnimationPlayer

export var reach_branch : int
export var initial_res : Resource
export var reach_res : Resource
export var arm_res : Resource
export var key_res : Resource

var event_finished: bool = false


func _ready() -> void:
	sprite.playing = false
	sprite.frame = 1
	add_to_group("save")
	

func _on_player_interacted(res : Resource) -> void:
	if res == key_res:
		yield(DialogueHandler, "dialogue_finished")
		event_finished = true
	elif not res == initial_res or event_finished:
		return

	yield(DialogueHandler, "branch_chosen") 
	if DialogueHandler.dialogue_branch == reach_branch:
		yield(DialogueHandler, "dialogue_finished")

		GlobalHandler.Player.position.y += 16
		Gui.red_screen.show()
		Gui.red_screen_anim.play("fade")
		HpHandler.cut_limb("left_arm")
		GlobalHandler.MainViewport.pallete = GlobalHandler.bloodshot_pallete
		yield(Gui.red_screen_anim, "animation_finished")
		
		DialogueHandler.start_dialogue(arm_res)
		has_dialogue = false
		yield(DialogueHandler, "dialogue_finished")
		print("dialogue finished arm res!")
		sprite.play("flood")
		yield(sprite, "animation_finished")
		sprite.play("aftermath")

		dialogue = key_res		
		has_dialogue = true

