extends Area2D

onready var Sound = $Sound

var played : bool = false
var playerEntered : bool = false
export var activateOnce : bool = false
export var volume : float = 0.0

func _ready():
	Sound.volume_db = volume 

func _on_SoundArea_body_entered(body) -> void :
	if activateOnce == true and played == true:
		return
	if body is Player :
		Sound.play()
		played = true
		print("played")


