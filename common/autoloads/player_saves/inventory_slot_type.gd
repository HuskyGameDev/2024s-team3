extends Resource
class_name InventorySlot

@export var quantity: int = 0
@export var item: Item

func _to_json():
	return { "quantity": quantity, "item": item.id }


func fill_slot(id: String, quantity: int):
	self.quantity = quantity
	self.item = ResourceLoader.load(ResourcePaths.get_ingredient_path(id))
