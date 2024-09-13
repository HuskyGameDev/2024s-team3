#Wade Canavan
#adds ingredients to next available inventory slot 
extends Control

var template_inv_slot = preload("res://scenes/main/ui/inventory/drawer_button.tscn")
var slots: Array[InventorySlot] = []

@onready var grid_container = get_node("Background/M/V/ScrollContainer/GridContainer")

signal spawn_slot_item(item: Item, pos: Vector2, throw: bool) #spawn item in inventory with main as parent

#reads from inventory json file, creates each slot of inventory and fills it according to json
func _ready():
	self.position.x = 800
	for i:InventorySlot in PlayerData.inventory: #for each inventory slot in the JSON
		slots.push_back(i)
		var inv_slot_new:Control = template_inv_slot.instantiate()
		inv_slot_new.connect("change_slot_item", _on_slot_contents_change.bind(slots.size() - 1))
		grid_container.add_child(inv_slot_new)
		
		## Send the signal deferred so the positions are correct
		var create_items_in_main = func():
			inv_slot_new.set_catch_items(true)
			if i: #if it has somthing in it, spawn it in the slot
				var center_of_slot = inv_slot_new.global_position + inv_slot_new.get_rect().size / 2
				for n in i.quantity:
					spawn_slot_item.emit(i.item, center_of_slot, false, {"collision_mask": 0})
		create_items_in_main.call_deferred()
		
	## Reset the catch items prop once they're created
	get_tree().create_timer(0.01).timeout.connect(func(): 
		for child in grid_container.get_children(): child.set_catch_items(false)
	, CONNECT_ONE_SHOT)



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
