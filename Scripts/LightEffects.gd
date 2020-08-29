extends CanvasModulate

var lightValue : float

func _ready():
	setLightColor(GlobalHandler.globalLight)

func setLightColor(lightValue : float):
	var lightColor : Color = Color(lightValue, lightValue, lightValue, 1.0)
	self.color = lightColor
