extends "res://objects/sound_area/SoundArea.gd"


func _ready() -> void:
	connect("player_unpaused", self, "_on_SoundArea_player_unpaused")


func _on_SoundArea_player_unpaused():
	var lantern_node := player_node.get_node("Lantern")
	if GlobalHandler.lantern_fuel == 0:
		return
	GlobalHandler.lantern_fuel = 0
