extends Resource
class_name DialogueResource

export var text: Array = ["page 1 example"]
export var answers: Dictionary = {}
export var item_held: Resource setget set_item, get_item
export(String, MULTILINE) var read_box_text

var item_acquired := false

func expend_item() -> void:
   item_acquired = true 


func set_item(new_item: Resource) -> void:
    item_held = new_item


func get_item() -> Resource:
    if item_acquired:
        return null
    return item_held