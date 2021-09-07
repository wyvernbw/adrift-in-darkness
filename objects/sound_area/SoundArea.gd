extends Area2D

signal player_pause
signal player_unpause

onready var Sound = $Sound

var played : bool = false
var playerEntered : bool = false
var player_node : KinematicBody2D
var caption_box := preload("res://gui/caption/Caption.tscn").instance()
export var activateOnce : bool = false
export var volume : float = 0.0
export var pause_player : bool = true
export var pause_player_duration : float = 1 # seconds
export var caption : String = ""
export var player_path : NodePath


func _ready():
	Sound.volume_db = volume
	$PauseTimer.wait_time = pause_player_duration
	player_node = get_node(player_path)
	connect("player_pause", player_node, "_on_player_paused")
	connect("player_unpause", player_node, "_on_player_unpaused")


func _on_SoundArea_body_entered(body) -> void :
	if activateOnce == true and played == true:
		return
	if body is Player :
		Sound.play()
		played = true
		# add captions
		if GlobalHandler.captions_enabled:
			caption_box.text = caption
			add_child(caption_box)
		print("played")
		$PauseTimer.start()
		emit_signal("player_pause")


func _on_PauseTimer_timeout():
	emit_signal("player_unpause")
