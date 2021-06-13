extends Node2D


var konoDioDa: String = "Goodbye, Jojo!"
var saveKey = "GAME"

var levels: Dictionary = {
	"1F_main_room": preload("res://levels/1F_main_room.tscn").instance(),
	"1F_west_hall": preload("res://levels/1F_west_hall.tscn").instance(),
	"1F_west_main_hall": preload("res://levels/1F_west_main_hall.tscn").instance(),
	"2F_west_small_room": preload("res://levels/2F_west_small_room.tscn").instance(),
	"1F_west_office": preload("res://levels/1F_west_office.tscn").instance()
}
var current_scene : String = "1F_main_room"

func switch_scene(scene_name: String) -> void:
	if levels[scene_name] == null:
		return
	print(self.get_children())
	var c = self.get_children()
	var prev_scene : String
	var prev_scene_index : int
	for i in c.size():
#		if c[i].get_name().left(1) == "1" or c[i].get_name().left(1) == "2":
		if c[i] is Node2D:
			prev_scene = c[i].get_name()
			prev_scene_index = i
			continue
	print(prev_scene)
	levels[prev_scene] = c[prev_scene_index]
	add_child(levels[scene_name])
	remove_child(c[prev_scene_index])
	current_scene = scene_name


func save_game(game_save: Resource) -> void:
	game_save.data[saveKey] = {
		'levels': {
				'1F_main_room': levels["1F_main_room"],
				'1F_west_hall': levels["1F_west_hall"],
				'1F_west_main_hall': levels["1F_west_main_hall"],
				'2F_west_small_room': levels["2F_west_small_room"],
				'1F_west_office': levels["1F_west_office"]
		}
	}


func load_game(game_save: Resource) -> void:
	var data = game_save.data[saveKey]
	levels["1F_main_room"] = data['levels']['1F_main_room']
	levels["1F_west_hall"] = data['levels']['1F_west_hall']
	levels["1F_west_main_hall"] = data['levels']['1F_west_main_hall']
	levels["1F_west_office"] = data['levels']['1F_west_office']

func _on_Door_player_entered(scene_name) -> void:
	switch_scene(scene_name)
	print(scene_name)
