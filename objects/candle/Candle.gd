extends StaticObject

var candle_item: Item = Item.new("Candle", 1, null, Item.ITEM_TYPES.NORMAL_ITEM)


func on_DialogueHandler_player_unpaused():
	if not InventoryHandler.get_item(candle_item) == -1:
		queue_free()
