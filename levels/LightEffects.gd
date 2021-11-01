tool
extends CanvasModulate

var light_value : float

func _ready() -> void:
	setLightColor(GlobalHandler.global_light)
	visible = true

func _process(delta : float) -> void:
	setLightColor(GlobalHandler.current_light)

func setLightColor(light_value : float) -> void:
	var light_color : Color = Color(light_value, light_value, light_value, 1.0)
	self.color = light_color
