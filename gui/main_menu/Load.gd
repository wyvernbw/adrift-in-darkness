extends Control


func _ready() -> void:
	get_tree().change_scene("res://levels/Game.tscn")
	SaveGameHandler.call_deferred("load_game")
