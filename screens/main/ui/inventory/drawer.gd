#Wade Canavan
#adds ingredients to next available inventory slot 
extends Control

var packed_ingredient_scene = preload("res://common/items/ingredients/ingredient.tscn")
var template_inv_slot = preload("res://screens/main/ui/inventory/drawer_button.tscn")

var slots: Array[InventorySlot] = []

@onready var grid_container: GridContainer = $Background/M/V/ScrollContainer/GridContainer

## reads from inventory json file, creates each slot of inventory and fills it according to json
func _ready():
	var main_node: Node2D = get_node("/root/Main") # node to add ingredient instances to when loading from the inventory
	self.position.x = 100
	for i:InventorySlot in PlayerData.inventory: # for each inventory slot in the JSON
		slots.push_back(i)
		var inv_slot_new:Control = template_inv_slot.instantiate()
		inv_slot_new.connect("change_slot_item", _on_slot_contents_change.bind(slots.size() - 1))
		grid_container.add_child(inv_slot_new)
		
		## Spawn held items as children of inventory slot (with owner node "Main")
		## uses deferred so main is able to spawn the nodes at the end of the physics process
		var hold_deferred = func():
			var item_node: DraggableObject = packed_ingredient_scene.instantiate().with_data(i.item)
			item_node.global_position = Vector2(300, 300)
			main_node.add_child(item_node)
			inv_slot_new.slotNode.hold_node(item_node)
			item_node.collision_mask = 0
		if i:
			for n in i.quantity:
				hold_deferred.call_deferred()
	_on_exit_button_pressed() # disables slots since they are offscreen


func _on_slot_contents_change(item, quantity: int, slot_index: int):
	if item: 
		var slotData = InventorySlot.new()
		slotData.item = item
		slotData.quantity = quantity
		PlayerData.inventory[slot_index] = slotData
	else: 
		PlayerData.inventory[slot_index] = null


## move drawer on screen
func _on_tab_button_pressed():
	self.position.x = 1200
	$Tab.visible = false
	$add.visible = false
	await get_tree().create_timer(0.1).timeout
	for inventory_button in grid_container.get_children():
		inventory_button.set_disabled(false)


## move drawer off screen
func _on_exit_button_pressed():
	for inventory_button in grid_container.get_children(): 
		inventory_button.set_disabled(true)
	self.position.x = 100
	#self.position.x = 1865
	$Tab.visible = true
	$add.visible = false
