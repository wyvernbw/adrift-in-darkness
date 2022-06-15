extends ViewportContainer

var pallete : Texture setget set_pallete

func _ready():
    GlobalHandler.MainViewport = self


func set_pallete(new_pallete : Texture) -> void:
    material.set_shader_param("u_color_tex", new_pallete)