extends CanvasLayer

onready var inventory := $InventoryGUI
onready var red_screen := $RedScreen/Polygon2D
onready var red_screen_anim := red_screen.get_node("AnimationPlayer")

