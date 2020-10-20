extends CanvasModulate

var lightValue : float

func _ready() -> void:
	setLightColor(GlobalHandler.globalLight)

func _process(delta : float) -> void:
	setLightColor(GlobalHandler.globalLight)

func setLightColor(lightValue : float) -> void:
	var lightColor : Color = Color(lightValue, lightValue, lightValue, 1.0)
	self.color = lightColor
