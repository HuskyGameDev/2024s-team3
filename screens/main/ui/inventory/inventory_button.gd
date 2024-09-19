extends Control

@onready var quantityLabel: Label = $Quantity
@onready var slotNode: Node2D = $ShelfSlot

# sends every time the slot item is changed, used in drawer.gd
signal change_slot_item(item, quantity: int)

func _on_slot_items_changed(nodeArr, newItem):
	## Update slot labels
	if nodeArr.size() > 0:
		quantityLabel.text = str(nodeArr.size())
	else:
		quantityLabel.text = ""
	
	## Update inventory variable
	change_slot_item.emit(newItem, nodeArr.size())
