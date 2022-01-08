extends CanvasLayer

var current_fps : float
var fps : int = 1
var time : float = 0.0

func _process(delta : float) -> void:
	fps += 1
	time += delta
	if time > 1: 
		current_fps = 1 / max(0.001, delta) # 100 ms (a second) divided by delta
		time = 0
	$Label.text = "FPS: " + str(current_fps)
