extends Resource
class_name DialogueResource

export var text: Array = ["page 1 example"]
export var answers: Dictionary = {}

export var item_name: String
export var item_texture: Texture
export var item_quantity: int
export var item_type: int = -1

export(String, MULTILINE) var read_box_text

var item_held: Item setget set_item_held 


func set_item_held(new_item : Item):
    if not new_item:    
        item_name = "" 
        item_texture = null
        item_quantity = 0
        item_type = -1
        item_held = null
        return
    # set properties
    item_name = new_item.item_name
    item_texture = new_item.texture
    item_quantity = new_item.quantity
    item_type = new_item.item_type
    # set item held
    item_held = new_item


func expend_item() -> void:
    self.item_held = null