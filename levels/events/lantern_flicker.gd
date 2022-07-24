extends Event


func action() -> Dictionary:
    GlobalHandler.lantern_toggled = false
    Sound.play_sound("fire_out_1")
    return deps

