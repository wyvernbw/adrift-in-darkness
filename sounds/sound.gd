extends AudioStreamPlayer2D

"""
Sound class for playing audio files in the game without worrying about loading resources or managing them. Can play globally or at a certain position.
"""

signal finished_loading

const CAPTION = preload('res://gui/caption/Caption.tscn')

onready var global_sound: AudioStreamPlayer = $Global

var sounds := {}
var subtitles := {}

export var paths: Array


func _ready():
	load_sounds(paths)

func load_sounds(load_paths: Array) -> void:
	for path in load_paths:
		var dir := Directory.new()
		var error := dir.open(path)
		if not error == OK:
			print("Error opening directory: %s" % error)
			continue
		# start the file enumeration and skip navigationals like .. and .
		error = dir.list_dir_begin(true)
		if not error == OK:
			print("Error listing directory: %s" % error)
			continue
		var file_name := dir.get_next()
		while file_name:
			var id = file_name.get_basename()
			if file_name.get_extension() == "wav":
				sounds[id] = load(path + "/" + file_name)
				print("loaded %s" % file_name)
			if file_name.get_extension() == "txt":
				var file = File.new()
				error = file.open(path + "/" + file_name, File.READ)
				subtitles[id] = file.get_as_text()
				print("loaded %s" % file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	emit_signal("finished_loading")


func play_sound(id: String, source: Node2D = self) -> void:
	if not id in sounds:
		return

	position = source.position
	if id in subtitles:
		var caption := CAPTION.instance()
		caption.text = subtitles[id]
		add_child(caption)
		print(caption)
	if source == self:
		global_sound.stream = sounds[id]
		global_sound.play()
		return
	stream = sounds[id]
	play()


func _on_Sound_finished_loading():
	play_sound("step_grass_1")
