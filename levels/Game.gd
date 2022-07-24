extends Node2D

export var levels: Dictionary
export var current_scene: String = "1F_main_room"
export var load_paths: Array = ["res://levels"]
export var event_curve: Curve

var save_key = "game"

onready var grim = Grim.new({
	"curve": event_curve,
	"step": 0.1,
	"interval": 5,
	"intensity_range": 0.2,
	"manual": false,
})


func _ready():
	grim.connect("grim_ready", self, "_on_grim_ready")
	load_levels()
	GlobalHandler.previous_scene = get_tree().get_current_scene().get_filename()
	GlobalHandler.Game = self
	add_child(grim)


func _on_grim_ready():
	add_events()
	grim.grim_init()


func switch_scene(scene_name: String) -> void:
	if not scene_name in levels.keys():
		return
	for node in self.get_children():
		node = node as Node2D
		if not node:
			continue
		levels[node.get_name()] = node
		remove_child(node)
		print("removed level " + node.get_name())
		add_child(levels[scene_name])
		print("added level " + levels[scene_name].get_name())
		GlobalHandler.Player = levels[scene_name].get_node("Player")
		current_scene = scene_name
		return

	# if game has no level
	add_child(levels[scene_name])
	print("added level " + levels[scene_name].get_name())
	GlobalHandler.Player = levels[scene_name].get_node("Player")
	current_scene = scene_name

	print("no previous level. Added " + scene_name)


func _on_Door_player_entered(scene_name) -> void:
	switch_scene(scene_name)
	print(scene_name)


func add_events() -> void:
	var event_scripts = get_node("Events")
	grim.register(event_scripts.get_node("Creak"))

func save() -> Dictionary:
	var save_dict: Dictionary
	# save levels
	save_dict["levels"] = Dictionary()
	for level in levels.keys():
		save_dict["levels"][level] = SaveGameHandler.SAVE_FOLDER + "levels/" + str(level) + ".tscn"
		var level_scene = PackedScene.new()
		level_scene.pack(levels[level])
		ResourceSaver.save(save_dict["levels"][level], level_scene)
		print("level saved at " + save_dict["levels"][level])

	save_dict["current_scene"] = current_scene
	return save_dict


func load(save: Dictionary) -> void:
	for level in save["levels"].keys():
		levels[level] = load(save["levels"][level]).instance()
	remove_child(get_node(current_scene))
	#var new_scene = levels[current_scene]
	#new_scene.name = current_scene
	#add_child(new_scene)
	switch_scene(save["current_scene"])


func load_levels() -> void:
	print("game: loading levels...")
	var dir = Directory.new()
	for path in load_paths:
		dir.open(path)
		dir.list_dir_begin(true)
		var file = dir.get_next()
		while file:
			if file.get_extension() == "tscn":
				var key = file.get_file().get_basename()
				var level = load(path + "/" + file.get_file())
				levels[key] = level.instance()
			file = dir.get_next()
		dir.list_dir_end()
