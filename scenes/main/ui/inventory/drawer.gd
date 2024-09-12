#Wade Canavan
#adds ingredients to next available inventory slot 
extends Control

signal make_inv_object(item:Resource) #emits to main scene to create ingredient object
var items: Array
var template_inv_slot = preload("res://scenes/main/ui/inventory/drawer_button.tscn")
@onready var gridcontainer = get_node("Background/M/V/ScrollContainer/GridContainer")
var inv_data
var slots: Array[InventorySlot] = []
var dragSlot = null;

#reads from inventory json file, creates each slot of inventory and fills it according to json
func _ready():
	for i:InventorySlot in PlayerData.inventory: #for each inventory slot in the JSON
		slots.push_front(i)
		var inv_slot_new = template_inv_slot.instantiate()
		gridcontainer.add_child(inv_slot_new)
		if i: #if it has somthing in it, save those attributes to the slot
			inv_slot_new.get_node("Icon").set_texture(i.item.image)
			inv_slot_new.get_node("Icon/Quantity").set_text(i.quantity)


 ##gets the plot the mouse is dragging something that is already in the inventory to
#func _get_dragging(inv_slot):
	#dragSlot = inv_slot
#
#
##if we drag something outside of the inventory, make that object in the scene
#func _notification(notification_type): 
	#match notification_type:
		#NOTIFICATION_DRAG_END:
			#if !is_drag_successful():
				#inv_data = PlayerData.read_inv()	
				#make_inv_object.emit(dragSlot) #sends signal to main to make the object
				#var quantityNode = get_node("Background/M/V/ScrollContainer/GridContainer/" + str(dragSlot) + "/Icon/Quantity") 
				#if int(quantityNode.text) == 1: #if there was only one thing in that slot, empty the slot
					#var iconNode = get_node("Background/M/V/ScrollContainer/GridContainer/" + str(dragSlot) + "/Icon" )
					#iconNode.texture = null
					#quantityNode.text = ""
					#inv_data[dragSlot]["Item"] = null
				#else:  #else decrease the slot quantity by one
					#quantityNode.text =  str(int(quantityNode.text) - 1)
					#inv_data[dragSlot]["Quantity"] = quantityNode.text
				#PlayerData.write_inv(inv_data)
#
#
##insert an item of ingredient resource and quantity amount
#func Insert(item : Resource, quantity : int):
	#var index = 0;
	#inv_data = PlayerData.read_inv()	
	#for slot in  gridcontainer.get_children(): #find next available slot to put item
		#
		#var slotAmount = inv_data[slot.name]["Quantity"]
		#if inv_data[slot.name]["Item"] == item.id && slotAmount != item.stackSize: #if this ingredient already exists in inventory
			#if slotAmount + quantity > item.stackSize: #if adding this quantity to the amount in the stack would be larger than stack size
				#inv_data[slot.name]["Quantity"] = item.stackSize #fill the slot
				#UpdateButton(item, item.stackSize, index)					
				#PlayerData.write_inv(inv_data)
				#Insert(item, slotAmount + quantity - item.stackSize) #add the rest to a different slot
				#break
			#else: #else just update the quantity
				#inv_data[slot.name]["Quantity"] = slotAmount + quantity					
				#UpdateButton(item, slotAmount , index)
				#break
		#elif inv_data[slot.name]["Item"] == null: #if this slot is empty 
			#if quantity > 0:
				#if quantity <= item.stackSize: #if quantity is not greater than allowed stack size add item to this slot
#
					#inv_data[slot.name]["Item"] = item.id
					#inv_data[slot.name]["Quantity"] = quantity					
					#UpdateButton(item, quantity, index)
					#break
				#else: #else add max stack size to this slot and add the excess to another slot
					#inv_data[slot.name]["Item"] = item.id
					#inv_data[slot.name]["Quantity"] = item.stackSize
					#UpdateButton(item, item.stackSize, index)					
					#PlayerData.write_inv(inv_data)
					#Insert(item, quantity - item.stackSize)
					#break
			#else:
				#return
		#index = index + 1
	#PlayerData.write_inv(inv_data)
#
#
#func UpdateButton( item : Resource, quantity : int, index : int):
	#if index < gridcontainer.get_child_count():
		#gridcontainer.get_child(index).UpdateItem(item, quantity, index)
		##gridcontainer.get_child(index).UpdateItem(null, 0, index)
#
#
##adds an inventory slot
#func add_inv_slot(): # just put this where we call it
	#inv_data = PlayerData.read_inv()#reads from json	
	#var numChild = str(gridcontainer.get_child_count()+1)
	#inv_data["Inv" + numChild] = { #adds another inventory slot to inv_data
		#"Item" : null,
		#"Quantity" : 0 
	#}
	#PlayerData.write_inv(inv_data) #writes in_data to json
	#var inv_slot_new = template_inv_slot.instantiate()
	#inv_slot_new.name = "Inv" + numChild
	#gridcontainer.add_child(inv_slot_new, true)
#
#
##testing
#func _on_add_button_down():
	#add_inv_slot()
	##Insert(ResourceLoader.load("res://Assets/Resources/Ingredients/thistle_root.tres"), 10)
#
#
#move drawer off screen
func _on_tab_button_pressed():
	self.position.x = 1200
	$Tab.visible = false
	$add.visible = false


#move drawer on screen
func _on_exit_button_pressed():
	self.position.x = 1865
	$Tab.visible = true
	$add.visible = false
