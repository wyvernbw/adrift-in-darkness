extends Node

var SAVE_FOLDER: String = "res://saves/"
var SAVE_NAME: String = "save.tres"
var save_object_dict: Dictionary = {}


func _process(delta: float) -> void:
	_debug()


func _debug() -> void:
	if Input.is_action_just_pressed("debug_load"):
		load_game()


func save_game() -> void:
	var game_save := GameSave.new()
	game_save.game_version = ProjectSettings.get_setting("application/config/version")
	for Node in get_tree().get_nodes_in_group("save"):
		Node.save_game(game_save)

	var directory: Directory = Directory.new()
	if not directory.dir_exists(SAVE_FOLDER):
		directory.make_dir_recursive(SAVE_FOLDER)

	var save_path = SAVE_FOLDER + SAVE_NAME
	var error: int = ResourceSaver.save(save_path, game_save)
	if error != OK:
		print("an error occured when saving the game on path " + save_path)


func load_game() -> void:
	var save_file_path = SAVE_FOLDER + SAVE_NAME
	var file: File = File.new()

	if not file.file_exists(save_file_path):
		print("file doesnt exist")
		return

	var game_save: Resource = load(save_file_path)
	for node in get_tree().get_nodes_in_group('save'):
		node.load_game(game_save)
