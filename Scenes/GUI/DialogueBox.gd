extends CanvasLayer

onready var TypingTimer = $TypingTimer

var typing_finished : bool = false

func _on_TypingTimer_timeout():
	$Panel/Label.visible_characters += 1
	if $Panel/Label.visible_characters == $Panel/Label.text.length():
		typing_finished = true
		TypingTimer.stop()

