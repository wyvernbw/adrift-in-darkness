extends PanelContainer

onready var anim := $AnimationPlayer


func _ready() -> void:
    anim.play("fade")