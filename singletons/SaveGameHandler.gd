extends Node

var SAVE_FOLDER: String = "res://saves/"
var SAVE_NAME: String = "gamesave.tres"
#var SAVE_NAME: String = "gamesave.tscn"
var save_path: String = SAVE_FOLDER + SAVE_NAME
#var save_file: Resource = GameSave.new()


func _process(_delta: float) -> void:
	_debug()


func _debug() -> void:
	if Input.is_action_just_pressed("debug_load"):
		load_game()
	if Input.is_action_just_pressed("debug_save"):
		save_game()


func save_game() -> void:
	var save_nodes = get_tree().get_nodes_in_group("persist")
	var save_game = GameSave.new()
	for node in save_nodes:
		if not node.has_method("save"):
			continue
		save_game.data[node.save_key] = node.save()
	ResourceSaver.save(save_path, save_game)
	print("game saved at " + save_path)


func load_game() -> void:
	var save_game = ResourceLoader.load(save_path)
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		if not node.has_method("load"):
			continue
		node.load(save_game.data[node.save_key])
	print("loaded game from " + save_path)
