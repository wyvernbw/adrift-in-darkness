extends Node2D

var konoDioDa: String = "Goodbye, Jojo!"
var saveKey = "GAME"
var levels: Dictionary = {
	"1F_main_room": preload("res://Scenes/levels/1F_main_room.tscn").instance(),
	"1F_west_hall": preload("res://Scenes/levels/1F_west_hall.tscn").instance(),
	"1F_west_main_hall": preload("res://Scenes/levels/1F_west_main_hall.tscn").instance(),
	"2F_west_small_room": preload("res://Scenes/levels/2F_west_small_room.tscn").instance(),
	"1F_west_office": preload("res://Scenes/levels/1F_west_office.tscn").instance()
}
var current_scene : String = "1F_main_room"


func switch_scene(scene_name: String) -> void:
	if levels[scene_name] == null:
		return
	print(self.get_children())
	var c = self.get_children()
	var prev_scene = c[1].get_name()
	print(prev_scene)
	levels[prev_scene] = c[1]
	remove_child(c[1])
	add_child(levels[scene_name])
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
