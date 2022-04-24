extends AnimatedSprite

export var mirror_pivot_path: NodePath
export var mirror_plane: Vector2

onready var mirror_pivot: Position2D = get_node(mirror_pivot_path)
onready var player = GlobalHandler.Player

func _physics_process(_delta):
	mirror_position()

func _process(_delta):
	mirror_animations()


func mirror_animations() -> void:	
	var player_look_dir: Vector2 = player.look_dir 
	var mirrored_dir = Vector2(
		player_look_dir.x,
		-player_look_dir.y
	)
	if player.moving:
		play_anim("move_", mirrored_dir)
	else:
		play_anim("idle_", mirrored_dir)


func play_anim(anim: String, dir: Vector2) -> void:
	var dir_str: String = "up"
	match dir:
		Vector2.RIGHT:
			dir_str = "right"
		Vector2.LEFT:
			dir_str = "left"
		Vector2.UP:
			dir_str = "up"
		Vector2.DOWN:
			dir_str = "down"
	var mirrored_animation: String = anim + dir_str + player.anim_suffix
	animation = mirrored_animation
	frame = player.sprite.frame


func mirror_position() -> void:
	var dist_vector := mirror_pivot.position.project(Vector2.DOWN)
	var dist_from_origin := dist_vector.length()
	var dist_from_plane = mirror_plane.dot(player.position) - dist_from_origin
	position = player.position - mirror_plane * dist_from_plane * 2
	print(dist_from_plane)
