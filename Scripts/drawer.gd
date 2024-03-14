#Wade Canavan
#adds ingredients to next available inventory slot 
extends Control

var items :Array
var template_inv_slot = preload("res://Scenes/UI/Drawer_button.tscn")
@onready var gridcontainer = get_node("Background/M/V/ScrollContainer/GridContainer")
var inv_data
var slots = []

# Called when the node enters the scene tree for the first time.
#reads from inventory json file, creates each slot of inventory and fills it according to json
func _ready():
	inv_data = PlayerData.read_inv()
	for i in inv_data:
		slots.push_front(i)
		print(i)
		var inv_slot_new = template_inv_slot.instantiate()
		inv_slot_new.name = i
		gridcontainer.add_child(inv_slot_new, true)
		if inv_data[i]["Item"] != null:
			var quantity = str(inv_data[i]["Quantity"])
			var item_name = str(inv_data[i]["Item"])
			var path = "res://Assets/Resources/Ingredients/" + str(item_name) + ".tres"
			var resource = ResourceLoader.load(path)
			print(resource.id)
			inv_slot_new.get_node("Icon").set_texture(resource.image)
			print(quantity)
			inv_slot_new.get_node("Icon/Quantity").set_text(quantity)

	#populateButtons()
	pass # Replace with function body.

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
				print("a")
				PlayerData.write_inv(inv_data)
				Insert(item, slotAmount + quantity - item.stackSize) #add the rest to a different slot
				break
			else: #else just update the quantity
				inv_data[slot.name]["Quantity"] = slotAmount + quantity					
				print("b")
				UpdateButton(item, slotAmount , index)
				break
		elif inv_data[slot.name]["Item"] == null: #if this slot is empty 
			if quantity > 0:
				if quantity <= item.stackSize: #if quantity is not greater than allowed stack size add item to this slot
					print(inv_data[slot.name]["Item"])
					inv_data[slot.name]["Item"] = item.id
					inv_data[slot.name]["Quantity"] = quantity					
					print("c")
					UpdateButton(item, quantity, index)
					print(slot.name)

					break
				else: #else add max stack size to this slot and add the excess to another slot
					inv_data[slot.name]["Item"] = item.id
					inv_data[slot.name]["Quantity"] = item.stackSize
					UpdateButton(item, item.stackSize, index)					
					print("d")
					print(slot.name)
					print(inv_data[slot.name]["Item"])
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
	else:
		print(index)
		#gridcontainer.get_child(index).UpdateItem(null, 0, index)

func _on_button_button_down():
	Insert(ResourceLoader.load("res://Assets/Resources/Ingredients/thistle_root.tres"), 10)
