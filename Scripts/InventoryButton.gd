extends Button

var curItem
var curIcon
var curLabel
var index
signal OnButtonClick(Index, item)

# Called when the node enters the scene tree for the first time.
func _ready():
	curIcon = $Icon
	curLabel = $Icon/Quantity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func UpdateItem(item:Resource, quantity: int, index :int):
	self.index = index
	curItem = item
	if curItem == null:
		curIcon.texture= null
		curLabel.text = ""
	else:
		curIcon.texture = item.image
		curLabel.text = str(quantity)

func _on_area_2d_area_entered(area):
	pass # Replace with function body.


func _on_area_2d_area_exited(area):
	pass # Replace with function body.


func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	pass # Replace with function body.


func _on_area_2d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	pass # Replace with function body.


func _on_button_down():
	emit_signal("OnButtonClick", index, curItem)
