extends Object
class_name Item

var texture: Texture
var item_name: String
var quantity: int
var item_type: int

enum ITEM_TYPES { INVALID_ITEM = -1, KEY_ITEM = 0, NORMAL_ITEM = 1 }


func _init(_item_name, _quantity, _texture, _item_type) -> void:
	if _item_name.empty() or not _quantity or not _texture:
		return
	item_name = _item_name
	quantity = _quantity
	texture = _texture
	item_type = _item_type