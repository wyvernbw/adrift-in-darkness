extends PanelContainer

export var sprite_path: NodePath
export var source_button_path: NodePath
export var open_file_dialog_path: NodePath
export var save_file_dialog_path: NodePath

onready var sprite := get_node(sprite_path)
onready var source_button := get_node(source_button_path)
onready var open_file_dialog := get_node(open_file_dialog_path)
onready var save_file_dialog := get_node(save_file_dialog_path)

func _on_SourceButton_pressed():
	open_file_dialog.popup()

func _on_YSlider_value_changed(value: float) -> void:
	sprite.position.y = value * 4

func _on_XSlider_value_changed(value: float) -> void:
	sprite.position.x = value * 4


func _on_LineEdit_text_entered(new_text: String) -> void:
	var new_scale = float(new_text)
	if new_scale:
		sprite.scale = Vector2(new_scale, new_scale)

func _on_SaveButton_pressed():
	save_file_dialog.popup()
	var filename = yield(save_file_dialog, "file_selected")
	hide()
	save_file_dialog.hide()
	yield(get_tree().create_timer(0.5), "timeout")
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.save_png(filename)
	yield(get_tree().create_timer(0.5), "timeout")
	show()


func _on_OpenDialog_file_selected(path):
	source_button.text = path
	var img = Image.new()
	img.load(path)
	var sprite_texture = ImageTexture.new()
	sprite_texture.create_from_image(img)
	sprite.texture = sprite_texture
