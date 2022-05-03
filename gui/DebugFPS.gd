extends CanvasLayer

export var active: bool = false setget set_active

var current_fps : float
var fps : int = 1
var time : float = 0.0


func _ready() -> void: 
	self.active = active


func _process(delta : float) -> void:
	if not active:
		return
	fps += 1
	time += delta
	if time > 1: 
		current_fps = 1 / max(0.001, delta) # 100 ms (a second) divided by delta
		time = 0
	$Label.text = "FPS: " + str(current_fps)


func set_active(state: bool) -> void:
	$Label.visible = state
	active = state