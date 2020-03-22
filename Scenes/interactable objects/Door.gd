extends Area2D

signal page_changed

const DIALOGUE_BOX_SCENE = preload("res://Scenes/GUI/DialogueBox.tscn")

onready var InventoryGUI 

var player_is_colliding : bool
var player_is_looking : bool
var required_item : Item

export(String) var scene_path : String
export(bool) var locked : bool 
export(String) var locked_text : String
export(String) var unlocked_text : String
export(String) var key_name : String 
export(bool) var unlock_on_interact : bool = false
export(NodePath) var inv_gui_path : NodePath 
export(Vector2) var required_look_dir : Vector2

func _ready() -> void:
	required_item = Item.new(key_name, 1, null, Item.ITEM_TYPES.KEY_ITEM)
	$CanvasLayer/Sprite.visible = true
	$CanvasLayer/Sprite/AnimationPlayer.play("fade out")

func _process(delta : float) -> void:
	InventoryGUI = get_node(inv_gui_path)
	var interact = Input.is_action_just_pressed("interact")
	if InventoryGUI:
		if not InventoryGUI.visible:
			if player_is_colliding and $"../Player".look_dir == required_look_dir and interact:
				if not locked:
					if scene_path:
						$CanvasLayer/Sprite/AnimationPlayer.play("fade in")
						$Sounds/Open.play()
				elif locked:
					if InventoryHandler.get_item(required_item) != -1:
						locked = false
						$Sounds/Unlocked.play()
						return
					if get_node("DialogueBox"):
						get_node("DialogueBox").queue_free()
						DialogueHandler.emit_signal("player_unpause")
						DialogueHandler.dialogue_open = false
					else:
						$Sounds/Locked.play()
						var dialogue_box = DIALOGUE_BOX_SCENE.instance()
						add_child(dialogue_box)
						dialogue_box.get_node("Panel/Label").text = locked_text
						DialogueHandler.emit_signal("player_pause")
						DialogueHandler.dialogue_open = true
		
func _on_Door_body_entered(body : Node) -> void:
	if body is Player:
		player_is_colliding = true

func _on_Door_body_exited(body : Node) -> void:
	if body is Player:
		player_is_colliding = false

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "fade in":
		get_tree().change_scene(scene_path)
		InventoryGUI.refresh_inventory()
		$CanvasLayer/Sprite/AnimationPlayer.play("fade out")
