extends CanvasLayer


onready var label := $MarginContainer/PanelContainer/MarginContainer/Text

func set_text(new_text: String) -> void:
    if not label:
        yield(self, "ready")
    label.text = new_text