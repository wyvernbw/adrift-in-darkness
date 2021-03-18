extends Area2D

signal page_changed
signal player_entered(scene_name)

const DIALOGUE_BOX_SCENE = preload("res://gui/dialogue_box/DialogueBox.tscn")
const INTERACT_DELAY : float = 0.2 # seconds

onready var inventory_gui 
onready var player_node
onready var interact_delay_timer : Timer = $InteractDelay

var player_is_colliding : bool
var player_is_looking : bool
var required_item : Item
var can_interact : bool = true

export var scene_name : String
export var locked : bool 
export var unlock_on_interact : bool = false
export var locked_dialogue : Resource
export var unlocked_text : String
export var key_name : String 
export var inventory_gui_path : NodePath 
export var player_path : NodePath
export var required_look_dir : Vector2

func _ready() -> void:
	# get nodes
	var game_node = get_node("/root/Game")
	inventory_gui = get_node(inventory_gui_path)
	player_node = get_node(player_path)

	connect("player_entered", game_node, "_on_Door_player_entered")
	DialogueHandler.connect("dialogue_box_removed", self, "_on_dialogue_box_removed")

	required_item = Item.new(key_name, 1, null, Item.ITEM_TYPES.KEY_ITEM)

	$CanvasLayer/Sprite.visible = true
	$CanvasLayer/Sprite/AnimationPlayer.play("fade out")

func _process(_delta : float) -> void:
	var interact = Input.is_action_just_pressed("interact")

	# things that prevent the player from opening the door
	if not can_interact:
		return
	if DialogueHandler.dialogue_open:
		return
	if not inventory_gui:
		return
	if inventory_gui.visible:
		return
	if not  player_node.look_dir == required_look_dir:
		return
	if not player_is_colliding :
		return

	# nothing preventing the player from opening the door
	if  interact:
		print("interacted with door " + str(self))
		if not locked and scene_name:
			$CanvasLayer/Sprite/AnimationPlayer.play("fade in")
			$Sounds/Open.play()
		elif locked:
			if InventoryHandler.get_item(required_item) != -1:
				locked = false
				$Sounds/Unlocked.play()
				return
			else:
				$Sounds/Locked.play()
				print("locked")
				DialogueHandler.dialogue = locked_dialogue
				DialogueHandler.page_index += 1 
				DialogueHandler.add_dialogue_box()
				# var dialogue_box = DIALOGUE_BOX_SCENE.instance()
				# varadd_child(dialogue_box)
				# vardialogue_box.get_node("Panel/Label").bbcode_text = locked_text
				# varDialogueHandler.emit_signal("player_pause")
				# varDialogueHandler.dialogue_open = true

func _on_dialogue_box_removed() -> void:
	start_delay()
		
func _on_Door_body_entered(body : Node) -> void:
	if body is Player:
		player_is_colliding = true

func _on_Door_body_exited(body : Node) -> void:
	if body is Player:
		player_is_colliding = false

func _on_Open_finished():
	emit_signal("player_entered", scene_name)
	inventory_gui.refresh_inventory()
	$CanvasLayer/Sprite/AnimationPlayer.play("fade out")


func _on_InteractDelay_timeout():
	can_interact = true

func start_delay() -> void:
	can_interact = false
	interact_delay_timer.start()
