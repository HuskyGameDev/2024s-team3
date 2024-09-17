extends Control

@onready var quantityLabel: Label = $Quantity
@onready var slotNode: Node2D = $ShelfSlot

signal change_slot_item(item, quantity: int)
signal spawn_slot_item(item, pos, throw)

func _on_slot_items_changed(nodeArr, newItem):
	## Update slot labels
	if nodeArr.size() > 0:
		quantityLabel.text = str(nodeArr.size())
	else:
		quantityLabel.text = ""
	
	## Update inventory variable
	change_slot_item.emit(newItem, nodeArr.size())


func set_disabled(val: bool):
	slotNode.force_center_nodes()
	slotNode.isDisabled = val


## If true, the inventory will catch items not being held by the player
func set_catch_items(val: bool):
	slotNode.requireDrag = not val
