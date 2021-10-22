extends Node2D

export var levels: Dictionary = {
	"1F_main_room": preload("res://levels/1F_main_room.tscn").instance(),
	"1F_west_hall": preload("res://levels/1F_west_hall.tscn").instance(),
	"1F_west_main_hall": preload("res://levels/1F_west_main_hall.tscn").instance(),
	"2F_west_small_room": preload("res://levels/2F_west_small_room.tscn").instance(),
	"1F_west_office": preload("res://levels/1F_west_office.tscn").instance(),
	"1F_kitchen": preload("res://levels/1F_kitchen.tscn").instance(),
	"2F_east_main_hall": preload("res://levels/2F_east_main_hall.tscn").instance()
}
export var current_scene: String = "1F_main_room"

var save_key = "game"

func switch_scene(scene_name: String) -> void:
	if not scene_name in levels.keys():
		return
	for node in self.get_children():
		if not node is Node2D:
			continue
		#levels[node.get_name()] = node
		remove_child(node)
		print("removed level " + node.get_name())
		add_child(levels[scene_name])
		print("added level " + levels[scene_name].get_name())
		current_scene = scene_name	
		return
	# if game has no level
	add_child(levels[scene_name])
	print("added level " + levels[scene_name].get_name())
	current_scene = scene_name	
	print("no previous level. Added " + scene_name)

func _on_Door_player_entered(scene_name) -> void:
	switch_scene(scene_name)
	print(scene_name)


func save() -> Dictionary: 
	var save_dict : Dictionary
	# save levels
	for level in levels.keys():
		save_dict[level] = SaveGameHandler.SAVE_FOLDER + "levels/" + str(level) + ".tscn"
		var level_scene = PackedScene.new()
		level_scene.pack(levels[level])
		ResourceSaver.save(save_dict[level], level_scene)
		print("level saved at " + save_dict[level])
	
	# save player
	#save_dict["player"] = SaveGameHandler.SAVE_FOLDER + "player/player.tscn"
	#var player_scene = PackedScene.new()
	#player_scene.pack(GlobalHandler.Player)
	#ResourceSaver.save(save_dict["player"], player_scene)
	
	return save_dict

func load(save : Dictionary) -> void:
	for level in save.keys():
		if not level == "player":
			levels[level] = load(save[level]).instance(1)
	get_node(current_scene).queue_free()
	#var new_scene = levels[current_scene]
	#new_scene.name = current_scene
	#add_child(new_scene)
	switch_scene(current_scene)

	#GlobalHandler.Player.queue_free()
	#var player_node = load(save["player"]).instance()
	#get_node(current_scene).add_child(player_node)
