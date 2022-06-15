extends Node

"""
Stores Info. about the current state of the player
(limbs left, blood loss) and interacts with other 
scripts.
"""

signal playerDied
signal limb_cut(limb)

const max_blood = 4500
const blood_loss_rate = 1
const total_limbs = 4

var blood = max_blood
var save_key = "hp_handler"
var using_bandages = false
var bandage_item: Item

export var current_limbs: Dictionary = {
	"right_arm": true, "left_arm": true, "right_leg": true, "left_leg": true
}

export var bleeding_limbs: Dictionary = {
	"right_arm": false, "left_arm": false, "right_leg": false, "left_leg": false
}


func _ready() -> void:
	add_to_group("persist")
	InventoryHandler.connect("inventory_item_used", self, "_on_item_used")


func _process(delta: float) -> void:
	calculate_blood_loss()


#Damage Player
func cut_limb(limb: String):
	if limb == null:
		return
	GlobalHandler.Player.anim_suffix = "_" + limb
	_remove_limb(limb)
	_set_limb_bleeding(limb)
	emit_signal("limb_cut", limb)


func _remove_limb(limb: String) -> void:
	if limb == null:
		return
	if current_limbs[limb] == null:
		return

	current_limbs[limb] = false


func _set_limb_bleeding(limb: String) -> void:
	if limb == null:
		return
	if bleeding_limbs[limb] == null:
		return

	bleeding_limbs[limb] = true
	GlobalHandler.Player.get_node("Particles2D").emitting = true


#Heal Player
func stop_limb_bleeding(limb: String) -> void:
	if limb == null:
		return
	if bleeding_limbs[limb] == null:
		return

	bleeding_limbs[limb] = false
	for element in bleeding_limbs.values():
		if element == true:
			return
	GlobalHandler.MainViewport.pallete = GlobalHandler.regular_pallete
	GlobalHandler.Player.get_node("Particles2D").emitting = false



func reset_blood() -> void:
	blood = max_blood


func reset_limbs() -> void:
	var possible_limbs: Array = current_limbs.keys()
	for i in total_limbs:
		current_limbs[possible_limbs[i]] = true
		bleeding_limbs[possible_limbs[i]] = false


#Apply blood loss logic
func calculate_blood_loss() -> void:
	if blood == 0:
		emit_signal("playerDied")
		return

	var possible_limbs: Array = current_limbs.keys()
	var bleeding_limbs_count: int

	for iter in total_limbs:
		if bleeding_limbs[possible_limbs[iter]] == true:
			bleeding_limbs_count += 1

	if bleeding_limbs_count == 0:
		return

	blood -= blood_loss_rate * bleeding_limbs_count


func _on_item_used(item : Item) -> void:
	var player = GlobalHandler.Player
	if item.name == "Bandages":
		bandage_item = item
		yield(get_tree(), "idle_frame")
		DialogueHandler.start_dialogue(player.stop_bleeding_dialogue)
		using_bandages = true


func _on_BranchingDialogueBox_option_pressed(branch: int) -> void:
	var player = GlobalHandler.Player
	if not using_bandages:
		return
	if branch == 1:
		if bleeding_limbs["left_arm"]:
			InventoryHandler.subtract_item(bandage_item)
			stop_limb_bleeding("left_arm")	
			DialogueHandler.start_dialogue(player.bleeding_stopped_dialogue)
			using_bandages = false
		else:
			DialogueHandler.start_dialogue(player.cant_use_bandages_dialogue)
			using_bandages = false


func save() -> Dictionary:
	var save_dict: Dictionary
	save_dict["current_limbs"] = current_limbs
	save_dict["bleeding_limbs"] = bleeding_limbs
	return save_dict


func load(save: Dictionary) -> void:
	current_limbs = save["current_limbs"]
	bleeding_limbs = save["bleeding_limbs"]
	for limb in current_limbs.keys():
		if not current_limbs[limb]:
			cut_limb(limb)
