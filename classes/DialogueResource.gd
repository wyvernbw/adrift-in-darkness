extends Resource
class_name DialogueResource

export var text: Array = ["page 1 example"]
export var answers: Dictionary = {}

export var item_name: String
export var item_texture: Texture
export var item_quantity: int
export var item_type: int

export(String, MULTILINE) var read_box_text

var item_held: Item setget set_item_held


func _init():
    item_held = Item.new(item_name, item_quantity, item_texture, item_type)


func set_item_held(new_item : Item):
    # set properties
    item_name = new_item.item_name
    item_texture = new_item.texture
    item_quantity = new_item.quantity
    item_type = new_item.item_type
    # set item held
    item_held = new_item