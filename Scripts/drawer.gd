extends Control

var gridContainer : GridContainer
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
		#var inv_slot_new = template_inv_slot.instantiate()
		#if PlayerData.inv_data[i]["Item"] != null:
			#var item_name = PlayerData.item_data[str(PlayerData.inv_data[i]["Item"])]["Name"]
			#var icon_texture = load("res://Assets/Resources/Ingredients/" + item_name + ".tres")
			#inv_slot_new.get_node("Icon").set_texture(icon_texture)
		#gridcontainer.add_child(inv_slot_new, true)
	populateButtons()
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


func Add(item : Resource):
	var curItem = item.duplicate()
	for i in items.size() :
		if items[i].ID == curItem.ID && items[i].Quantity != items[i].StackSize:
			if items[i].Quantity + curItem.Quantity > items[i].StackSize:
				items[i].Quantity = curItem.StackSize
				curItem.Quantity = -( curItem.Quantity - items[i].StackSize)
				UpdateButton(i)
				print(1)
			else:
				items[i].Quantity += curItem.Quantity
				curItem.Quantity = 0
				UpdateButton(i)
				print(2)
	if curItem.Quantity > 0:
		if curItem.Quantity < curItem.StackSize:
			items.append(curItem)
			UpdateButton(items.size() - 1)
			print(3)
		else:
			var tempItem = curItem.duplicate()
			tempItem.Quantity = curItem.StackSize
			items.append(tempItem)
			UpdateButton(items.size() - 1)
			curItem.Quantity -= curItem.StackSize
			Add(curItem)
			print(4)
			
	UpdateButton(items.size() - 1)
	
func UpdateButton( index : int ):
	if range(items.size()).has((index)):
		gridContainer.get_child(index).UpdateItem(items[index], index)
	else:
		gridContainer.get_child(index).UpdateItem(null, index)
		

func _on_button_button_down():
	Add(ResourceLoader.load("res://Assets/Sprites/Ingredients/Resources/TestItem.tres"))
