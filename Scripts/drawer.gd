#Wade Canavan
#adds ingredients to next available inventory slot 
extends Control

signal make_inv_object(item:Resource) #emits to main scene to create ingredient object
var items :Array
var template_inv_slot = preload("res://Scenes/UI/Drawer_button.tscn")
@onready var gridcontainer = get_node("Background/M/V/ScrollContainer/GridContainer")
var inv_data
var slots = []
var dragSlot = null;
# Called when the node enters the scene tree for the first time.
#reads from inventory json file, creates each slot of inventory and fills it according to json
func _ready():
	PlayerData._ready()
	inv_data = PlayerData.read_inv()
	for i in inv_data:
		slots.push_front(i)
		var inv_slot_new = template_inv_slot.instantiate()
		inv_slot_new.name = i
		gridcontainer.add_child(inv_slot_new, true)
		if inv_data[i]["Item"] != null:
			var quantity = str(inv_data[i]["Quantity"])
			var item_name = str(inv_data[i]["Item"])
			var path = "res://Assets/Resources/Ingredients/" + str(item_name) + ".tres"
			var resource = ResourceLoader.load(path)
			inv_slot_new.get_node("Icon").set_texture(resource.image)
			inv_slot_new.get_node("Icon/Quantity").set_text(quantity)

func _get_dragging(inv_slot):
	dragSlot = inv_slot

func _notification(notification_type):
	match notification_type:
		NOTIFICATION_DRAG_END:
			if !is_drag_successful():
				make_inv_object.emit(dragSlot)
				var quantityNode = get_node("Background/M/V/ScrollContainer/GridContainer/" + str(dragSlot) + "/Icon/Quantity")
				if int(quantityNode.text) == 1:
					var iconNode = get_node("Background/M/V/ScrollContainer/GridContainer/" + str(dragSlot) + "/Icon" )
					iconNode.texture = null
					quantityNode.text = ""
				else:
					quantityNode.text =  str(int(quantityNode.text) - 1)

#insert an item of ingredient resource and quantity amount
func Insert(item : Resource, quantity : int):
	var index = 0;
	inv_data = PlayerData.read_inv()	
	for slot in  gridcontainer.get_children(): #find next available slot to put item
		
		var slotAmount = inv_data[slot.name]["Quantity"]
		if inv_data[slot.name]["Item"] == item.id && slotAmount != item.stackSize: #if this ingredient already exists in inventory
			if slotAmount + quantity > item.stackSize: #if adding this quantity to the amount in the stack would be larger than stack size
				inv_data[slot.name]["Quantity"] = item.stackSize #fill the slot
				UpdateButton(item, item.stackSize, index)					
				PlayerData.write_inv(inv_data)
				Insert(item, slotAmount + quantity - item.stackSize) #add the rest to a different slot
				break
			else: #else just update the quantity
				inv_data[slot.name]["Quantity"] = slotAmount + quantity					
				UpdateButton(item, slotAmount , index)
				break
		elif inv_data[slot.name]["Item"] == null: #if this slot is empty 
			if quantity > 0:
				if quantity <= item.stackSize: #if quantity is not greater than allowed stack size add item to this slot

					inv_data[slot.name]["Item"] = item.id
					inv_data[slot.name]["Quantity"] = quantity					
					UpdateButton(item, quantity, index)
					break
				else: #else add max stack size to this slot and add the excess to another slot
					inv_data[slot.name]["Item"] = item.id
					inv_data[slot.name]["Quantity"] = item.stackSize
					UpdateButton(item, item.stackSize, index)					
					PlayerData.write_inv(inv_data)
					Insert(item, quantity - item.stackSize)
					break
			else:
				return
		index = index + 1
	PlayerData.write_inv(inv_data)


func UpdateButton( item : Resource, quantity : int, index : int):
	if index < gridcontainer.get_child_count():
		gridcontainer.get_child(index).UpdateItem(item, quantity, index)
		#gridcontainer.get_child(index).UpdateItem(null, 0, index)

#adds an inventory slot
func add_inv_slot(): # just put this where we call it
	inv_data = PlayerData.read_inv()#reads from json	
	var numChild = str(gridcontainer.get_child_count()+1)
	inv_data["Inv" + numChild] = { #adds another inventory slot to inv_data
		"Item" : null,
		"Quantity" : 0 
	}
	PlayerData.write_inv(inv_data) #writes in_data to json
	var inv_slot_new = template_inv_slot.instantiate()
	inv_slot_new.name = "Inv" + numChild
	gridcontainer.add_child(inv_slot_new, true)

#testing
func _on_add_button_down():
	add_inv_slot()
	#Insert(ResourceLoader.load("res://Assets/Resources/Ingredients/thistle_root.tres"), 10)

#move drawer off screen
func _on_tab_button_down():
	self.position.x = 1200
	$Tab.visible = false
	$add.visible = false

#move drawer on screen
func _on_exit_button_down():
	self.position.x = 1865
	$Tab.visible = true
	$add.visible = false
