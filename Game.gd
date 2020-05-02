extends Node2D

var levels : Dictionary = {
	"1F_main_room" : preload("res://Scenes/levels/1F_main_room.tscn").instance(),
	"1F_west_hall" : preload("res://Scenes/levels/1F_west_hall.tscn").instance()
}

func switch_scene(scene_name : String) -> void:
	print("y e e t")
	if levels[scene_name] != null:
		var c = self.get_children()
		var prev_scene = c[0].get_name()
		print(prev_scene)
		levels[prev_scene] = c[0]
		remove_child(c[0])
		add_child(levels[scene_name])


func _on_Door_player_entered(scene_name) -> void:
	switch_scene(scene_name)
	print(scene_name)


