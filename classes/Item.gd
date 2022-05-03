extends Object
class_name Item

var texture: Texture
var name: String
var quantity: int
var type: int = -1

enum ITEM_TYPES { KEY_ITEM = 0, NORMAL_ITEM = 1 }


func _init(_item_name := "", _quantity := 0, _texture = null, _item_type := -1) -> void:
	name = _item_name
	quantity = _quantity
	texture = _texture
	type = _item_type