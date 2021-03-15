extends Node2D

func _ready() -> void:
	setBloodVisible(GlobalHandler.bloodstainsMainHall)

func setBloodVisible(_visible : bool) -> void:
	$blood1.visible = _visible
	$blood2.visible = _visible
