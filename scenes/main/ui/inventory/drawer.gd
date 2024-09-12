#Wade Canavan
#adds ingredients to next available inventory slot 
extends Control

var template_inv_slot = preload("res://scenes/main/ui/inventory/drawer_button.tscn")
var slots: Array[InventorySlot] = []

@onready var grid_container = get_node("Background/M/V/ScrollContainer/GridContainer")

#reads from inventory json file, creates each slot of inventory and fills it according to json
func _ready():
	for i:InventorySlot in PlayerData.inventory: #for each inventory slot in the JSON
		slots.push_back(i)
		var inv_slot_new = template_inv_slot.instantiate()
		grid_container.add_child(inv_slot_new)
		if i: #if it has somthing in it, save those attributes to the slot
			inv_slot_new.get_node("Icon").set_texture(i.item.image)
			inv_slot_new.get_node("Icon/Quantity").set_text(i.quantity)
		inv_slot_new.connect("change_slot_item", _on_slot_contents_change.bind(slots.size() - 1))


func _on_slot_contents_change(item, quantity: int, slot_index: int):
	if item: 
		var slotData = InventorySlot.new()
		slotData.item = item
		slotData.quantity = quantity
		PlayerData.inventory[slot_index] = slotData
	else: 
		PlayerData.inventory[slot_index] = null


#move drawer on screen
func _on_tab_button_pressed():
	self.position.x = 1200
	$Tab.visible = false
	$add.visible = false
	for inventory_button in grid_container.get_children(): 
		inventory_button.set_disabled(false)


#move drawer off screen
func _on_exit_button_pressed():
	for inventory_button in grid_container.get_children(): 
		inventory_button.set_disabled(true)
	self.position.x = 1865
	$Tab.visible = true
	$add.visible = false
