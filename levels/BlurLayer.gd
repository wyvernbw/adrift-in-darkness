extends CanvasLayer

onready var anim_player := $BlurSprite/AnimationPlayer
onready var blur_sprite := $BlurSprite


func _ready() -> void:
	blur_sprite.visible = false
	HpHandler.connect("limb_cut", self, "_on_HpHandler_limb_cut")


func _on_HpHandler_limb_cut(limb: String) -> void:
	anim_player.play("blur")
	anim_player.advance(0.6)
	blur_sprite.visible = true
