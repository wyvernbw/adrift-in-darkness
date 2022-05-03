extends Resource
class_name ItemResource

export var name: String
export var texture: Texture
export var type: int 
export var quantity: int

var _item: Item

func get_item() -> Item:
    if not _item:
        _item = Item.new(name, quantity, texture, type)
    return _item
