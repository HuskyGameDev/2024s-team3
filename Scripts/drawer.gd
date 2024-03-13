extends Control

var items :Array
var template_inv_slot = preload("res://Scenes/UI/Drawer_button.tscn")
@onready var gridcontainer = get_node("Background/M/V/ScrollContainer/GridContainer")
var inv_data
var slots = []

# Called when the node enters the scene tree for the first time.
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
			#Insert(resource, inv_data[i]["Quantity"])
			print(resource.id)
			inv_slot_new.get_node("Icon").set_texture(resource.image)
			print(quantity)
			inv_slot_new.get_node("Icon/Quantity").set_text(quantity)

	#populateButtons()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func populateButtons():
	for i in inv_data:
		var packedScene = ResourceLoader.load("res://Scenes/UI/Drawer_button.tscn")
		var itemButton = packedScene.instantiate()
		itemButton.connect("OnButtonClick", OnButtonClicked)
		$Background/M/V/ScrollContainer/GridContainer.add_child(itemButton)

func OnButtonClicked(index, curItem):
	print("Clicked!")

func Insert(item : Resource, quantity : int):
	var index = 0;
	for slot in  gridcontainer.get_children():
		print(inv_data[slot.name]["Item"])
		print(item.id)
		if inv_data[slot.name]["Item"] == item.id:
			var slotAmount = inv_data[slot.name]["Quantity"]
			if  slotAmount != item.stackSize:
				if slotAmount + quantity > item.stackSize:
					inv_data[slot.name]["Quantity"] = item.stackSize
					UpdateButton(item, item.stackSize, index)					
					print("a")
					Insert(item, slotAmount + quantity - item.stackSize)
					PlayerData.write_inv(inv_data)
					return
				else:
					inv_data[slot.name]["Quantity"] = slotAmount + quantity					
					print("b")
					UpdateButton(item, inv_data[slot.name]["Quantity"] , index)
					PlayerData.write_inv(inv_data)
					return
		if inv_data[slot.name]["Item"] == null:
			if quantity > 0:
				if quantity <= item.stackSize:
					inv_data[slot.name]["Item"] = item.id
					inv_data[slot.name]["Quantity"] = quantity					
					print("c")
					UpdateButton(item, quantity, index)
					PlayerData.write_inv(inv_data)
					return
				else:
					inv_data[slot.name]["Item"] = item.id
					inv_data[slot.name]["Quantity"] = item.stackSize
					UpdateButton(item, item.stackSize, index)					
					print("d")
					Insert(item, quantity - item.stackSize)
					PlayerData.write_inv(inv_data)
					return
			else:
				return
		index = index + 1
	#UpdateButton(item, quantity, index)


func UpdateButton( item : Resource, quantity : int, index : int):
	if index < gridcontainer.get_child_count():
		gridcontainer.get_child(index).UpdateItem(item, quantity, index)
	else:
		print(index)
		#gridcontainer.get_child(index).UpdateItem(null, 0, index)

func _on_button_button_down():
	Insert(ResourceLoader.load("res://Assets/Resources/Ingredients/thistle_root.tres"), 10)
