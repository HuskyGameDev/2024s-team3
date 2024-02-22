extends Control

var gridContainer : GridContainer
var items :Array
# Called when the node enters the scene tree for the first time.
func _ready():
	gridContainer = $Background/M/V/ScrollContainer/GridContainer
	populateButtons()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func populateButtons():
	for i in 20:
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
