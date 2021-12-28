extends CanvasLayer

var current_fps : float
var fps : int = 1

func _process(delta : float) -> void:
	fps += 1
	current_fps = 1 / max(0.01, delta) # 100 ms (a second) divided by delta
	$Label.text = "FPS: " + str(current_fps)
