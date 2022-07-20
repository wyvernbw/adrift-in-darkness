extends AudioStreamPlayer2D

"""
Sound class for playing audio files in the game without worrying about loading resources or managing them. Can play globally or at a certain position.
"""

onready var global_sound: AudioStreamPlayer = $Global

var sounds := {}

export var paths: Array


func _ready():
	load_sounds(paths)
	play_sound("step_grass_1.wav")


func load_sounds(load_paths: Array) -> void:
	for path in load_paths:
		var dir := Directory.new()
		var error := dir.open(path)
		if not error == OK:
			print("Error opening directory: %s" % error)
			continue
		# start the file enumeration and skip navigationals like .. and .
		dir.list_dir_begin(true)
		var file_name := dir.get_next()
		while file_name:
			if file_name.get_extension() == "wav":
				sounds[file_name] = load(path + "/" + file_name)
				print("loaded %s" % file_name)
			file_name = dir.get_next()
		dir.list_dir_end()


func play_sound(id: String, source: Node2D = self) -> void:
	position = source.position
	if not id in sounds:
		return
	if source == self:
		global_sound.stream = sounds[id]
		global_sound.play()
		return
	stream = sounds[id]
	play()
