extends CanvasLayer

var text: String


func _ready() -> void:
	$Container/Label.text = text
	$Timer.wait_time = GlobalHandler.captions_duration
	$Timer.start()


func _on_Timer_timeout():
	$AnimationPlayer.play("fade_out")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
